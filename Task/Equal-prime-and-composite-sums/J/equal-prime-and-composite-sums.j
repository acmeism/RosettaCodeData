Pn=: +/\ pn=: p: i.1e6 NB. first million primes pn and their running sum Pn
Cn=: +/\(4+i.{:pn)-.pn NB. running sum of composites starting at 4 and excluding those primes
both=: Pn(e.#[)Cn NB. numbers in both sequences

   both,.(Pn i.both),.Cn i.both NB. values, Pn index m, Cn index n
         10      2      1
       1988     32     50
      14697     79    146
      83292    174    360
    1503397    659   1581
   18859052   2142   5698
   93952013   4555  12820
89171409882 118784 403340
