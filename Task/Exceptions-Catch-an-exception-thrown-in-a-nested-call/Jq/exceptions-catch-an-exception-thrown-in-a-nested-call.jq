# n is assumed to be the number of times baz has been previously called:
def baz(n):
  if n==0 then error("U0")
  elif n==1 then error("U1")
  else "Goodbye"
  end;

def bar(n): baz(n);

def foo:
  (try bar(0) catch if . == "U0" then "We caught U0" else error(.) end),
  (try bar(1) catch if . == "U0" then "We caught U0" else error(.) end);

foo
