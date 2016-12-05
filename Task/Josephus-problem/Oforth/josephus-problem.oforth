: josephus(n, k)
| prisoners killed i |
   n seq asListBuffer ->prisoners
   ListBuffer newSize(n) ->killed

   0 n 1- loop: i [
      k 1- + prisoners size mod dup 1+ prisoners removeAt
      killed add
      ] drop

   System.Out "Killed : " << killed << "\nSurvivor : " << prisoners << cr
;
