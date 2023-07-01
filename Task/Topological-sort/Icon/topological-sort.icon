record graph(nodes,arcs)
global ex_name, in_name

procedure main()
   show(tsort(getgraph()))
end

procedure tsort(g)
   t := ""
   while (n := g.nodes -- pnodes(g)) ~== "" do {
      t ||:= "("||n||")"
      g := delete(g,n)
      }
   if g.nodes == '' then return t
   write("graph contains the cycle:")
   write("\t",genpath(fn := !g.nodes,fn,g))
end

## pnodes(g) -- return the predecessor nodes of g
#     (those that have an arc from them)
procedure pnodes(g)
   static labels, fromnodes
   initial {
           labels := &ucase
           fromnodes := 'ACEGIKMOQSUWY'
           }
   return cset(select(g.arcs,labels, fromnodes))
end

## select(s,image,object) - efficient node selection
procedure select(s,image,object)
   slen := *s
   ilen := *image
   return if slen <= ilen then map(object[1+:slen/2],image[1+:slen],s)
          else map(object,image,s[1+:ilen]) || select(s[1+ilen:0],image,object)
end

## delete(g,x) -- deletes all nodes in x from graph g
#     note that arcs must be deleted as well
procedure delete(g,x)
   t := ""
   g.arcs ? while arc := move(2) do if not upto(x,arc) then t ||:= arc
   return graph(g.nodes--x,t)
end


## getgraph() -- read and construct a graph
#      graph is described via sets of arcs, as in:
#
#           from to1 to2 to3
#
# external names are converted to single character names for efficiency
# self-referential arcs are ignored
procedure getgraph()
   static labels
   initial labels := &cset
   ex_name := table()
   in_name := table()
   count := 0
   arcstr := ""
   nodes := ''
   every line := !&input do {
       nextWord := create genWords(line)
       if nfrom := @nextWord then {
           /in_name[nfrom] := &cset[count +:= 1]
           /ex_name[in_name[nfrom]] := nfrom
           nodes ++:= in_name[nfrom]
           while nto := @nextWord do {
               if nfrom ~== nto then {
                   /in_name[nto] := &cset[count +:= 1]
                   /ex_name[in_name[nto]] := nto
                   nodes ++:= in_name[nto]
                   arcstr ||:= in_name[nfrom] || in_name[nto]
                   }
               }
           }
       }
   return graph(nodes,arcstr)
end

# generate all 'words' in string
procedure genWords(s)
    static wchars
    initial wchars := &cset -- ' \t'
    s ?  while tab(upto(wchars))\1 do suspend tab(many(wchars))\1
end

## show(t) - return the external names (in order) for the nodes in t
#  Each output line contains names that are independent of each other
procedure show(t)
   line := ""
   every n := !t do
      case n of {
         "(" : line ||:= "\n\t("
         ")" : line[-1] := ")"
         default : line ||:= ex_name[n] || " "
      }
   write(line)
end

## genpath(f,t,g) -- generate paths from f to t in g
procedure genpath(f,t,g, seen)
   /seen := ''
   seen ++:= f
   sn := nnodes(f,g)
   if t ** sn == t then return ex_name[f] || " -> " || ex_name[t]
   suspend ex_name[f] || " -> " || genpath(!(sn --seen),t,g,seen)
end

## nnodes(f,g) -- compute all nodes that could follow f in g
procedure nnodes(f,g)
   t := ''
   g.arcs ? while arc := move(2) do if arc[1] == f then t ++:= arc[2]
   return t
end
