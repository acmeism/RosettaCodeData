: main(n)
| l m std i nb |

   // Create list and calculate avg and stddev
   ListBuffer init(n, #[ Float rand ]) dup ->l avg ->m
   0 l apply(#[ sq +]) n / m sq - sqrt ->std
   System.Out "n = " << n << ", avg = " << m << ", std = " << std << cr

   // Histo
   0.0 0.9 0.1 step: i [
      l count(#[ between(i, i 0.1 +) ]) 400 * n / asInteger ->nb
      System.Out i <<wjp(3, JUSTIFY_RIGHT, 2) " - " <<
                 i 0.1 + <<wjp(3, JUSTIFY_RIGHT, 2) " - " <<
                 StringBuffer new "*" <<n(nb) << cr
      ] ;
