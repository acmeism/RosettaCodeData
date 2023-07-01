#!/usr/bin/a68g --script #
# -*- coding: utf-8 -*- #

# Define some generic vector initialisation and printing operations #

COMMENT REQUIRES:
  MODE SCAL = ~ # a scalar, eg REAL #;
  FORMAT scal fmt := ~;
END COMMENT

INT vec lwb := 1, vec upb := 0;
MODE VECNEW = [vec lwb:vec upb]SCAL; MODE VEC = REF VECNEW;
FORMAT vec fmt := $"("n(vec upb-vec lwb)(f(scal fmt)", ")f(scal fmt)")"$;

PRIO INIT = 1;

OP INIT = (VEC self, SCAL scal)VEC: (
  FOR col FROM LWB self TO UPB self DO self[col]:= scal OD;
  self
);

# ZEROINIT: defines the additive identity #
OP ZEROINIT = (VEC self)VEC:
  self INIT SCAL(0);

OP REPR = (VEC self)STRING: (
  FILE f; STRING s; associate(f,s);
  vec lwb := LWB self; vec upb := UPB self;
  putf(f, (vec fmt, self)); close(f);
  s
);

SKIP
