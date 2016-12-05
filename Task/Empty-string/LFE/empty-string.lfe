> (set str "")
()
> (length str)
0
> (=:= 0 (length str))
true
> (=:= 0 (length "apple"))
false
> (=:= "apple" "")
false
> (=/= "apple" "")
true
> (=:= str "")
true
> (=:= "apple" '())
false
> (=/= "apple" '())
true
> (=:= str '())
true
> (case str  ('() 'empty) ((cons head tail) 'not-empty))
empty
> (case "apple"  ('() 'empty) ((cons head tail) 'not-empty))
not-empty
