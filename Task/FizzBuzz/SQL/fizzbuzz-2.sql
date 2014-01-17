select nvl(decode(mod(n,3),0,'Fizz')||decode(mod(n,5),0,'Buzz'),n)
from (select level n from dual connect by level<=100)
