: stern(n)
| l i |
   ListBuffer new dup add(1) dup add(1) dup ->l
   n 1- 2 / loop: i [ l at(i) l at(i 1+) tuck + l add l add ]
   n 2 mod ifFalse: [ dup removeLast drop ] dup freeze ;

stern(10000) Constant new: Sterns
