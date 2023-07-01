def smallint(i): i as $i
  | if (i|type) == "number" and i == (i|floor) and i > 0 and i < 11 then {"type": "smallint", "value": i}
     else empty
     end ;

# A convenience function to save typing:
def s(i): smallint(i);

# To convert from the pretty-print representation back to smallint:
def tosmallint:
  if type == "string" and startswith("smallint::") then
     split("::") | smallint( .[1] | tonumber )
  else empty
  end ;
