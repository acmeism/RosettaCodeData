# -*- coding: utf-8 -*- #

# Define some generic matrix initialisation and printing operations #

COMMENT REQUIRES:
  MODE SCAL = ~ # a scalar, eg REAL #;
  MODE VEC = []SCAL;
  FORMAT scal fmt := ~;
  et al.
END COMMENT

INT mat lwb := 1, mat upb := 0;
MODE MATNEW = [mat lwb:mat upb, vec lwb: vec upb]SCAL; MODE MAT = REF MATNEW;
FORMAT mat fmt = $"("n(vec upb-vec lwb)(f(vec fmt)","lx)f(vec fmt)")"l$;

PRIO DIAGINIT = 1;

OP INIT = (MAT self, SCAL scal)MAT: (
  FOR row FROM LWB self TO UPB self DO self[row,] INIT scal OD;
  self
);

# ZEROINIT: defines the additive identity #
OP ZEROINIT = (MAT self)MAT:
  self INIT SCAL(0);

OP REPR = (MATNEW self)STRING: (
  FILE f; STRING s; associate(f,s);
  vec lwb := 2 LWB self; vec upb := 2 UPB self;
  mat lwb :=   LWB self; mat upb :=   UPB self;
  putf(f, (mat fmt, self)); close(f);
  s
);

OP DIAGINIT = (MAT self, VEC diag)MAT: (
  ZEROINIT self;
  FOR d FROM LWB diag TO UPB diag DO self[d,d]:= diag[d] OD;
# or alternatively using TORRIX ...
  DIAG self := diag;
#
  self
);

# ONEINIT: defines the multiplicative identity #
OP ONEINIT = (MAT self)MAT: (
  ZEROINIT self DIAGINIT (LOC[LWB self:UPB self]SCAL INIT SCAL(1))
# or alternatively using TORRIX ...
  (DIAG out) VECINIT SCAL(1)
#
);

SKIP
