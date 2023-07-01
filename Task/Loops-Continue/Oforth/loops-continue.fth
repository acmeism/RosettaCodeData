: loopCont
| i |
   10 loop: i [
      i dup print 5 mod ifZero: [ printcr continue ]
      "," .
      ] ;
