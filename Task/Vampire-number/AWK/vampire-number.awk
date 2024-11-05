function H(n,i, d, h) {
    h=!split(n,d,X)
    asort(d)
    for(i in d)h=h d[i]
    return h
}

BEGIN{
  for(n=1000;n<=1000000;n++){
    if(split(n,d,X)%2)continue
    l=length(n)
    if(l%2)break
    A=0
    t=l/2
    for(f=10^(t-1);f<=int(sqrt(n));f++)
      if((n%f==0&&g=n/f)&&(length(f)==t&&length(g)==t&&!(f%10==0&&g%10==0)&&H(f g)==H(n)&&A=1))break
    if(A)print n
  }
}
