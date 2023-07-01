v=.vector~new(12,-3);  Say "v=.vector~new(12,-3) =>" v~print
v~ab(1,1,6,4);         Say "v~ab(1,1,6,4)        =>" v~print
v~al(45,2);            Say "v~al(45,2)           =>" v~print
w=v~'+'(v);            Say "w=v~'+'(v)           =>" w~print
x=v~'-'(w);            Say "x=v~'-'(w)           =>" x~print
y=x~'*'(3);            Say "y=x~'*'(3)           =>" y~print
z=x~'/'(0.1);          Say "z=x~'/'(0.1)         =>" z~print

::class vector
::attribute x
::attribute y
::method init
Use Arg a,b
self~x=a
self~y=b

::method ab      /* set vector from point (a,b) to point (c,d)       */
Use Arg a,b,c,d
self~x=c-a
self~y=d-b

::method al      /* set vector given angle a and length l            */
Use Arg a,l
self~x=l*rxCalccos(a)
self~y=l*rxCalcsin(a)

::method '+'     /* add: Return sum of self and argument             */
Use Arg v
x=self~x+v~x
y=self~y+v~y
res=.vector~new(x,y)
Return res

::method '-'     /* subtract: Return difference of self and argument */
Use Arg v
x=self~x-v~x
y=self~y-v~y
res=.vector~new(x,y)
Return res

::method '*'     /* multiply: Return self multiplied by t            */
Use Arg t
x=self~x*t
y=self~y*t
res=.vector~new(x,y)
Return res

::method '/'     /* divide: Return self divided by t                 */
Use Arg t
x=self~x/t
y=self~y/t
res=.vector~new(x,y)
Return res

::method print   /* prettyprint a vector                             */
return '['self~x','self~y']'

::requires rxMath Library
