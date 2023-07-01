x='alphaBETA';                    Say '  x='||x
                                  Say 'three ways to uppercase'
u1=translate(x);                  Say '  u1='u1
u2=upper(x);                      Say '  u2='u2
parse upper var x u3;             Say '  u3='u3

abc ='abcdefghijklmnopqrstuvwxyz'
abcu=translate(abc);              Say 'three ways to lowercase'
l1=translate(x,abc,abcu);         Say '  l1='l1
l2=lower(x);                      Say '  l2='l2
parse lower var x l3;             Say '  l3='l3
