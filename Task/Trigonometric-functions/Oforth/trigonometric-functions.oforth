import: math

: testTrigo
| rad deg hyp z |
   Pi 4 / ->rad
   45.0   ->deg
    0.5   ->hyp

   System.Out rad sin << " - " << deg asRadian sin << cr
   System.Out rad cos << " - " << deg asRadian cos << cr
   System.Out rad tan << " - " << deg asRadian tan << cr

   printcr

   rad sin asin ->z
   System.Out z << " - " << z asDegree << cr

   rad cos acos ->z
   System.Out z << " - " << z asDegree << cr

   rad tan atan ->z
   System.Out z << " - " << z asDegree << cr

   printcr

   System.Out hyp sinh << " - " << hyp sinh asinh << cr
   System.Out hyp cosh << " - " << hyp cosh acosh << cr
   System.Out hyp tanh << " - " << hyp tanh atanh << cr ;
