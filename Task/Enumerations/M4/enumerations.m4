define(`enums',
   `define(`$2',$1)`'ifelse(eval($#>2),1,`enums(incr($1),shift(shift($@)))')')
define(`enum',
   `enums(1,$@)')
enum(a,b,c,d)
`c='c
