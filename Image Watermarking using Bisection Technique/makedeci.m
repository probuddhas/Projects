function d=makedeci(a)
  [row col] = size(a);
  d=0;
  p=0;
  for x=col:-1:1
      d = d + a(x)*2^(p);
      p = p + 1;
  end