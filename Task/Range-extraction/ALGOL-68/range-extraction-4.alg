###
  REQUIRES(MODE SCALAR, OP(SCALAR,SCALAR)BOOL =, OP(SCALAR,SCALAR)SCALAR +);
###
PR READ "Template_Range_extraction_Base.a68" PR

PROC gen range = (UNIRANGELISTS unirange list, YIELDRANGE yield range)VOID:
### Take a []SCALAR, []RANGE or []URANGE, and generatively yield an unnormalised RANGE ###

  FOR key FROM LWB unirange list TO UPB unirange list DO
# Note: Algol 68RS cannot handle LWB and UPB of a UNION in the following: #
    UNIRANGE value = CASE unirange list IN
                       (SCALARLIST list):list[key],
                       (RANGELIST list):list[key],
                       (UNIRANGELIST list):list[key]
                     ESAC;
    yield range(
      CASE value IN
        (RANGE range): range,
        (SCALAR value): (value, value)
      ESAC
    )
  OD;

PROC gen range merge = (UNIRANGELISTS unirange list, YIELDRANGE yield)VOID: (
### Take a []SCALAR, []RANGE or []URANGE , and generatively yield a normalised RANGE ###

  UNION(VOID, RANGE) prev range := EMPTY;

# FOR RANGE next range IN # gen range(unirange list, # ) DO #
##   (RANGE next range)VOID:
# if the ranges cannot be merge, then yield 1st, and return 2nd #
    prev range :=
      CASE prev range IN
        (VOID): next range,
        (RANGE prev range):
          IF upb OF prev range + 1 = lwb OF next range THEN
            RANGE(lwb OF prev range, upb OF next range) # merge the range #
          ELSE
            #IF lwb OF prev range <= upb OF prev range THEN#
              yield(prev range);
            #FI;#
            next range
          FI
        OUT SKIP
      ESAC
# OD # );

  CASE prev range IN (RANGE last range): yield(last range) ESAC
);

PROC gen unirange merge = (UNIRANGELISTS unirange list, YIELDUNIRANGE yield)VOID: (
### Take a []SCALAR, []RANGE or []UNIRANGE and generatively yield a normalised UNIRANGE ###

  PROC unpack = (RANGE value)VOID:(
    IF lwb OF value = upb OF value THEN
      yield(lwb OF value)
    ELIF lwb OF value + 1 = upb OF value THEN
      yield(lwb OF value);
      yield(upb OF value)
    ELSE
      yield(value)
    FI
  );

  gen range merge(unirange list, unpack)
);

PROC unirange list init = (UNIRANGELISTS unirange list)UNIRANGELIST: (
### Take a []SCALAR, []RANGE or []UNIRANGE and return a static []UNIRANGE ###

  INT len = UPB unirange list - LWB unirange list + 1;
  [LWB unirange list: LWB unirange list + len * 2]UNIRANGE out unirange list; # estimate #
  SCALAR upb out unirange list := LWB out unirange list - 1;

# FOR UNIRANGE unirange IN # gen unirange merge(unirange list, # ) DO #
##   (UNIRANGE unirange)VOID:
    out unirange list[upb out unirange list+:=1] := unirange
# OD # );

  out unirange list[:upb out unirange list]
);

OP (UNIRANGELISTS)UNIRANGELIST INITUNIRANGE = unirange list init; # alias #
