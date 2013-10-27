sum=0

  do j=1  to 1000
  if j//3==0 | j//7==0  then iterate
  sum=sum+j
  end

           /*shows sum of 1k numbers except those divisible by 3 or 7.*/
say 'sum='sum
...
numeric digits 5000
prod=0

  do k=1  to 2000

     do m=1  to k
     if m>99  then iterate k
     prod=prod*m
     end

  end
say 'prod=' prod
