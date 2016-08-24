% function psnr = psnr(recpixel,orgpixel,row,col);
% 
% recpixel=double(recpixel);
% orgpixel=double(orgpixel);
% 
% e2=(recpixel - orgpixel).^2;
% MSE=sum(sum(e2))/(row*col);
% psnr=10*log10(255^2/MSE)

function psnr = psnr(Watermark,AttackedWatermark)
x=Watermark;
y=AttackedWatermark;

%if x == y
 %  error('Images are identical: PSNR has infinite value')
%end
x=double(x(:,:,1));
y=double(y(:,:,1));
d = mean( mean( (x(:)-y(:)).^2 ) );
m1 = max( abs(x(:)) );
m2 = max( abs(y(:)) );
m = max(m1,m2);

psnr = 10*log10( m^2/d );
