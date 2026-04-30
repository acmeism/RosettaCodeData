function noargs return Integer;
function twoargs (a, b : Integer) return Integer;
--  varargs do not exist
function optionalargs (a, b : Integer := 0) return Integer;
--  all parameters are always named, only calling by name differs
procedure dostuff (a : Integer);
