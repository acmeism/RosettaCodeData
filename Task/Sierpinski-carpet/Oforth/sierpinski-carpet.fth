: carpet(n)
| dim i j k |
   3 n pow ->dim

   0 dim 1 - for: i [
      0 dim 1 - for: j [
          dim 3 / ->k
          while(k) [
             i k 3 * mod k / 1 == j k 3 * mod k / 1 == and ifTrue: [ break ]
             k 3 / ->k
             ]
          k ifTrue: [ " " ] else: [ "#" ] print
          ]
      printcr
      ] ;
