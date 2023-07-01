: selectSort(l)
| b j i k s |
   l size ->s
   l asListBuffer ->b

   s loop: i [
      i dup ->k b at
      i 1 + s for: j [ b at(j) 2dup <= ifTrue: [ drop ] else: [ nip j ->k ] ]
      k i b at b put i swap b put
      ]
   b dup freeze ;
