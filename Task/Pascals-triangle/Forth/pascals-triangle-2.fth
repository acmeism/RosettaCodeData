: PascTriangle
  cr dup 0
  ?do
     1 over 1- i - 2* spaces i 1+ 0 ?do dup 4 .r j i - * i 1+ / loop cr drop
  loop drop
;

13 PascTriangle
