global mlck, nCons

procedure main()
    mlck := mutex()
    nCons := 0
    while f := open(":12321","na") do {
        handle_client(f)
        critical mlck: if nCons <= 0 then close(f)
        }
end

procedure handle_client(f)
    critical mlck: nCons +:= 1
    thread {
        select(f,1000) & repeat writes(f,reads(f))
        critical mlck: nCons -:= 1
        }
end
