function isprime(n, i) {
  if(n==2)return 1
  if(n<2||n%2==0)return 0
  for(i=3;i*i<=n;i+=2)
    if(n%i==0)return 0
  return 1
}

BEGIN {
  for(x=i=1;z<10;i++){
    x*=i
    if(isprime(x-1)){z++;print i"! - 1 = "x-1}
    if(isprime(x+1)){z++;print i"! + 1 = "x+1}
  }
}
