MODE ARGTYPE = INT;
MODE ARGLIST = FLEX[0]ARGTYPE;

OP + = (ARGLIST a, b)ARGLIST: (
  [LWB a:UPB a - LWB a + 1 + UPB b - LWB b + 1 ]ARGTYPE out;
  (
    out[LWB a:UPB a]:=a,
    out[UPB a+1:]:=b
  );
  out
);

# Append #
OP +:=    = (REF ARGLIST lhs, ARGLIST rhs)ARGLIST: lhs := lhs + rhs;
OP PLUSAB = (REF ARGLIST lhs, ARGLIST rhs)ARGLIST: lhs := lhs + rhs;

# Prefix #
OP +=:    = (ARGLIST lhs, REF ARGLIST rhs)ARGLIST: rhs := lhs + rhs;
OP PLUSTO = (ARGLIST lhs, REF ARGLIST rhs)ARGLIST: rhs := lhs + rhs;

ARGLIST a := (1,2),
        b := (3,4,5);

print(("a + b",a + b, new line));

VOID(a +:= b);
print(("a +:= b", a, new line));

VOID(a +=: b);
print(("a +=: b", b, new line))
