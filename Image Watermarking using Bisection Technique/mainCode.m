clc;
clear all;
close all;

N_Img = imread('images/Baboon.jpg');
bin_img= imread('images/pi.bmp');
bin_Img2=imresize(bin_img, [128 128]);

k=1;
for i=1:128
    for j=1:128
        bin_Img1(k)=bin_Img2(i,j);
        k=k+1;
    end
end



Img=imresize(N_Img, [128 128]);

IR = Img(:,:,1);
IG = Img(:,:,2);
IB = double(Img(:,:,3));

A = IB; 

V = zeros(3,3);
WM = zeros(256,256);
[a b] = size(A);
%%%%%%%%% Break into 2*2 Blocks *************************
k=1;
for i=1:2:a
for j=1:2:b
    C=A((i:i+1),(j:j+1));
    eval(['block_' num2str(k) '=C']);
    k=k+1;
end
end
%%%%%%%%%%%%%%%%%%%%%Convert to 3 * 3 Blocks %%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:k-1
    W  = eval(['block_' num2str(i)]);
    
    V(1,1)=W(1,1);
    V(1,3)=W(1,2);
    V(3,1)=W(2,1);
    V(3,3)=W(2,2);
    V(1,2)= round((W(1,1)+W(1,2))/2);
    V(2,1)= round((W(1,1)+W(2,1))/2);
    V(2,3)= round((W(1,2)+W(2,2))/2);
    V(3,2)= round((W(2,1)+W(2,2))/2);
    V(2,2)= round((V(1,2)+V(3,2))/2);
%     V(1,2) = round(nthroot(((W(1,1)^2)+(W(1,2)^2)),2)/2);
%     V(2,1) = round(nthroot(((W(1,1)^2)+(W(2,1)^2)),2)/2);
%     V(2,3) = round(nthroot(((W(1,2)^2)+(W(2,2)^2)),2)/2);
%     V(3,2) = round(nthroot(((W(2,1)^2)+(W(2,2)^2)),2)/2);
%     V(2,2) = round(nthroot(((V(1,2)^2)+(V(3,2)^2)),2)/2);
    
    eval(['Wblock_' num2str(i) '=V']);
end



%%%%%%%%%%%%%%%%%% Embeding  %%%%%%%%%%%%%%%%%%%%%%%%%%%
    for q=1:16384
    bs(q)=bin_Img1(q);
    end

m=1;
for i=1:k-1
    W  = eval(['Wblock_' num2str(i)]);
    n1=round(log10(W(1,2)));
    n2=round(log10(W(2,1)));
    n3=round(log10(W(2,2)));
    n4=round(log10(W(2,3)));
    n5=round(log10(W(3,2)));

   
    
    bs1=zeros(1,n1);
    for n=1:n1
        if m<16385
            bs1(n)=bs(m);
            m=m+1;
        end
    end
    W(1,2)=W(1,2)+ makedeci(bs1);


    bs2=zeros(1,n2);
    for n=1:n2
        if m<16385
            bs2(n)=bs(m);
            m=m+1;
        end
    end
    W(2,1)=W(2,1)+ makedeci(bs2);
    

    bs3=zeros(1,n3);
    for n=1:n3
        if m<16385
            bs3(n)=bs(m);
            m=m+1;
        end
    end
    W(2,2)=W(2,2)+ makedeci(bs3);


    bs4=zeros(1,n4);
    for n=1:n4
        if m<16385
            bs4(n)=bs(m);
            m=m+1;
        end
    end
    W(2,3)=W(2,3)+ makedeci(bs4);
    
    
    bs5=zeros(1,n5);
    for n=1:n5
        if m<16385
            bs5(n)=bs(m);
            m=m+1;
        end
    end
    W(3,2)=W(3,2)+ makedeci(bs5);
    
    
    eval(['Wblock_embed' num2str(i) '=W']);
end


 %%%%%%%%%%%%%%%%%%%%%%% combine %%%%%%%%%%%%%%%%%%%%%%
p=1;
for i = 1:64:4096
    Y = eval(['Wblock_embed' num2str(i)]);
    for j=1:63
    Y1=eval(['Wblock_embed' num2str(i+j)]);
    Y = horzcat(Y,Y1);
    end
    eval(['Y_tab' num2str(p) '=Y']);
    p=p+1;
end
WM = eval('Y_tab1');
for i=2:p-1
    WM1=eval(['Y_tab' num2str(i)]);
    WM=vertcat(WM,WM1);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

WMA=uint8(WM);
WMB = imresize(WMA, [128 128]);

FImg = cat(3,IR, IG, WMB);

corr=corr2(A,WMB)
snr=PSNR_RGB(double(Img),double(FImg))


figure,imshow(WMA)
imwrite(WMA,'resgray.jpg');
IR1 = imresize(IR, [192 192]);
IG1 = imresize(IG, [192 192]);
FImg1 = cat(3,IR1, IG1, WMA);
figure,imshow(FImg1)
imwrite(FImg1,'res.jpg');


%%%%%%%%%%%%%%%%%%%%%%% Extraction %%%%%%%%%%%%%%%%%%%%%%
[a b] = size(WMA);
k=1;
for i=1:3:a
for j=1:3:b
    C=round(WMA((i:i+2),(j:j+2)));
    eval(['Mblock_' num2str(k) '=C']);
    k=k+1;
end
end

for i=1:k-1
    W  = eval(['Mblock_' num2str(i)]);
    myblock = eval(['Wblock_' num2str(i)]);
    a12 = myblock(1,2);
    a21 = myblock(2,1);
    a23 = myblock(2,3);
    a32 = myblock(3,2);
    a22 = myblock(2,2);
    
    lg12 = round(log10(a12)); if isinf(lg12) lg12=0; end
    lg21 = round(log10(a21)); if isinf(lg21) lg21=0; end
    lg23 = round(log10(a23)); if isinf(lg23) lg23=0; end
    lg32 = round(log10(a32)); if isinf(lg32) lg32=0; end
    lg22 = round(log10(a22)); if isinf(lg22) lg22=0; end
    
    Mbs1 = dec2bin((W(1,2)-a12),lg12);
    Mbs2 = dec2bin((W(2,1)-a21),lg21);
    Mbs3 = dec2bin((W(2,2)-a22),lg22);
    Mbs4 = dec2bin((W(2,3)-a23),lg23);
    Mbs5 = dec2bin((W(3,2)-a32),lg32);
    
    Mbs=strcat(Mbs1,Mbs2,Mbs3,Mbs4,Mbs5);
    Mbs=double(Mbs)-'0';
    eval(['Mbs_block_' num2str(i) '=Mbs']);
end

Y = eval(['Mbs_block_' num2str(1)]);
for i=2:k-1
    Y1=eval(['Mbs_block_' num2str(i)]);
    Y = horzcat(Y,Y1);
end

for i=1:16384
    Mbs(i)=Y(i);
end

Mbs
bs
bitcorr=corr2(Mbs,bs)

k=1;
for i=1:128
    for j=1:128
        X(i,j)=Mbs(k);
        k=k+1;
    end
end
figure,imshow(X)
imwrite(X,'ext.bmp');