record graph(nodes,arcs)

procedure main()
   show(tsort(getgraph()))
end

procedure tsort(g)
   t := []
   while *(n := g.nodes -- pnodes(g)) > 0 do {
      every put(p := [], !n)
      put(t, p)
      g := delete(g,n)
      }
   if *g.nodes = 0 then return t
   write("graph contains the cycle:")
   write("\t",genpath(fn := !g.nodes,fn,g))
end

procedure pnodes(g)
   cp := create !g.arcs
   every insert(p := set(), |1(@cp,@cp))
   return p
end

procedure delete(g,x)
   arcs := []
   cp := create !g.arcs
   while (f := @cp, t := @cp) do {
        if !x == (f|t) then next
        every put(arcs,f|t)
        }
   return graph(g.nodes--x, arcs)
end

procedure getgraph()
   arcs := []
   nodes := set()
   every line := !&input do {
       nextWord := create genWords(line)
       if nfrom := @nextWord then {
           insert(nodes, nfrom)
           while nto := @nextWord do {
               if nfrom ~== nto then {
                   insert(nodes, nto)
                   every put(arcs, nfrom | nto)
                   }
               }
           }
       }
   return graph(nodes,arcs)
end

procedure genWords(s)
    static wchars
    initial wchars := &cset -- ' \t'
    s ?  while tab(upto(wchars))\1 do suspend tab(many(wchars))\1
end

procedure show(t)
   line := ""
   every n := !t do
      case type(n) of {
         "list" : line ||:= "\n\t("||toString(n)||")"
         default : line ||:= " "||n
         }
   write(line)
end

procedure toString(n)
   every (s := "") ||:= !n || " "
   return s[1:-1] | s
end

procedure genpath(f,t,g, seen)
   /seen := set()
   insert(seen, f)
   sn := nnodes(f,g)
   if member(sn, t) then return f || " -> " || t
   suspend f || " -> " || genpath(!(sn--seen),t,g,seen)
end

procedure nnodes(f,g)
   t := set()
   cp := create !g.arcs
   while (af := @cp, at := @cp) do if af == f then insert(t, at)
   return t
end
