SELECT nvl(decode(MOD(level,3),0,'Fizz')||decode(MOD(level,5),0,'Buzz'),level)
FROM dual
CONNECT BY level<=100;
