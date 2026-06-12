const a_f = '{a,b,c,d,e,f}'

$'0x{,1}{{0..9}($a_f),($a_f){{0..9},($a_f)}}'
| str expand
| into int
| take while { $in < 501 }
| str join ' '
