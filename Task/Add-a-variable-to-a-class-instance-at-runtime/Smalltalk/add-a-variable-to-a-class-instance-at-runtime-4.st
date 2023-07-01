p := Point x:10 y:20.
p addSlot:'z'.  "instance specific added slot"
p z:30.
p z.
p z:40.
p inspect. "shows 3 slots"
"Point class is unaffected:"
p2 := Point x:20 y:30.
p2 z:40.  -> error; Point does not implement z:
p2 inspect. "shows 2 slots"
"but we can create another instance of the enhanced point (even though its an anon class)"
p3 := p class new.
p3 x:1 y:2.
p3 z:4.
p3 inspect. "shows 3 slots"
