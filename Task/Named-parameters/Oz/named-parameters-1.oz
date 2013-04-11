declare
class Foo
   meth init skip end
   meth bar(PP %% positional parameter
	    named1:N1
	    named2:N2
	    namedWithDefault:NWD <= 42)
      {System.showInfo "PP: "#PP#", N1: "#N1#", N2: "#N2#", NWD: "#NWD}
   end
end

O = {New Foo init}
{O bar(1 named1:2 named2:3 namedWithDefault:4)} %% ok
{O bar(1 named2:2 named1:3)} %% ok
{O bar(1 named1:2)} %% not ok, "missing message feature in object application"
