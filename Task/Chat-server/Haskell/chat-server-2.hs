global mlck, nCons, cons

procedure main()
    mlck := mutex()
    nCons := 0
    cons := mutex(set())
    while f := open(":12321","na") do {
        handle_client(f)
        critical mlck: if nCons <= 0 then close(f)
        }
end

procedure handle_client(f)
    critical mlck: nCons +:= 1
    thread {
        select(f,1000) & {
            writes(f, "Name? ")
            nick := (read(f) ? tab(upto('\n\r')))
            every write(!cons, nick," has joined.")
            insert(cons, f)
            while s := read(f) do every write(!cons, nick,": ",s)
            }
        delete(cons, f)
        every write(!cons, nick," has left.")
        critical mlck: nCons -:= 1
        }
end
