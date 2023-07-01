/*REXX program shows a secret message to the terminal by using REXX built─in functions. */
z.=' ';   z= 12-25-2002;   y= z;   w= -y
 z.0= translate( right( time('c'), substr(z, 4, z==y)))
 z.1= left( substr( format(z, 2, z==y, , z==y.1), 5), z==y)
 z.2= copies( right( symbol('z.'20), z==y), left(w, 1))
 z.3= translate( right( date('w'), z==y))
 z.5= right( form(), z==y)
 z.6= x2c( d2x( x2d( c2x( substr( symbol( substr(z, 2)), 2, z==y))) - 1))
 z.7= right( symbol('z.' || (z\==z) ), z==y)
 z.8= substr( form(), (z==y) + left(w, 1), z==y)
 z.9= reverse( left( form(), z==y))
z.10= left( substr( form(), 6), z==y)
z.11= right( datatype(z), z==y)
z.12= substr( symbol(left(z, z=z)), left(w, 1), z==y)
z.13= left( form(), z==y)

      do z=-31  to 31;   z.32= z.32 || z.z;  end
say
say z.32
say
exit 0                                           /*stick a fork in it,  we're all done. */
