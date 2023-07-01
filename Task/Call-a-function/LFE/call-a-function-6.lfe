> (slurp '"args.lfe")
#(ok args)
> (my-func)
[] [] []
ok
> (my-func '"apple")
"apple" [] []
ok
> (my-func '"apple" '"banana")
"apple" "banana" []
ok
> (my-func '"apple" '"banana" '"cranberry")
"apple" "banana" "cranberry"
ok
> (my-func '"apple" '"banana" '"cranberry" '"bad arg")
exception error: #(unbound_func #(my-func 4))
