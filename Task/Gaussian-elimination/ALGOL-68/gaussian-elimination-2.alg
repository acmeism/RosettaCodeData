# -*- coding: utf-8 -*- #
COMMENT PRELUDE REQUIRES
  MODE SCAL = REAL;
  FORMAT scal repr = real repr
  # and various SCAL OPerators #
END COMMENT

COMMENT PRELUDE PROIVIDES
  MODE VEC, MAT;
  OP :=:, -:=, +:=, *:=, /:=;
  FORMAT sub, sep, bus;
  FORMAT vec repr, mat repr
END COMMENT

# Note: ℵ indicates attribute is "private", and
        should not be used outside of this prelude #

INT #ℵ#lwb vec := 1, #ℵ#upb vec := 0;
INT #ℵ#lwb mat := 1, #ℵ#upb mat := 0;
MODE VEC = [lwb vec:upb vec]SCAL,
     MAT = [lwb mat:upb mat,lwb vec:upb vec]SCAL;

FORMAT sub := $"( "$, sep := $", "$, bus := $")"$, nl:=$lxx$;
FORMAT vec repr := $f(sub)n(upb vec - lwb vec)(f(scal repr)f(sep))f(scal repr)f(bus)$;
FORMAT mat repr := $f(sub)n(upb mat - lwb mat)(f( vec repr)f(nl))f( vec repr)f(bus)$;

# OPerators to swap the contents of two VECtors #
PRIO =:= = 1;
OP =:= = (REF VEC u, v)VOID:
  FOR i TO UPB u DO SCAL scal=u[i]; u[i]:=v[i]; v[i]:=scal OD;

OP +:= = (REF VEC lhs, VEC rhs)REF VEC: (
  FOR i TO UPB lhs DO lhs[i] +:= rhs[i] OD;
  lhs
);

OP -:= = (REF VEC lhs, VEC rhs)REF VEC: (
  FOR i TO UPB lhs DO lhs[i] -:= rhs[i] OD;
  lhs
);

OP *:= = (REF VEC lhs, SCAL rhs)REF VEC: (
  FOR i TO UPB lhs DO lhs[i] *:= rhs OD;
  lhs
);

OP /:= = (REF VEC lhs, SCAL rhs)REF VEC: (
  SCAL inv = 1 / rhs; # multiplication is faster #
  FOR i TO UPB lhs DO lhs[i] *:= inv OD;
  lhs
);

SKIP
