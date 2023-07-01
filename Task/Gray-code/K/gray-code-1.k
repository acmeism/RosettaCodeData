   xor: {~x=y}
   gray:{x[0],xor':x}

   / variant: using shift
   gray1:{(x[0],xor[1_ x;-1_ x])}

   / variant: iterative
   gray2:{x[0],{:[x[y-1]=1;~x[y];x[y]]}[x]'1+!(#x)-1}
