      function agm(a,b)
      implicit none
      double precision agm,a,b,eps,c
      parameter(eps=1.0d-15)
   10 c=0.5d0*(a+b)
      b=sqrt(a*b)
      a=c
      if(a-b.gt.eps*a) go to 10
      agm=0.5d0*(a+b)
      end
      program test
      implicit none
      double precision agm
      print*,agm(1.0d0,1.0d0/sqrt(2.0d0))
      end
