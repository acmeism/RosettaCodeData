###
  REQUIRES(MODE SCALAR, OP(SCALAR,SCALAR)BOOL =, OP(SCALAR,SCALAR)SCALAR +);
###
PR READ "Template_Range_extraction_Base.a68" PR

OP (UNIRANGELISTS)UNIRANGELIST INITUNIRANGE = init unirange list; # alias #

PROC init unirange list = (UNIRANGELISTS unirange list)UNIRANGELIST: (
### Take a []SCALAR, []RANGE or []UNIRANGE, and return a normalised []UNIRANGE ###

  INT len = UPB unirange list-LWB unirange list+1;
  [LWB unirange list: LWB unirange list+len*2]UNIRANGE out unirange list;
  SCALAR upb out unirange list := LWB out unirange list - 1;
  UNION(VOID, RANGE) prev range := EMPTY;

  PROC out unirange list append = (RANGE value)VOID:(

    IF lwb OF value = upb OF value THEN
      out unirange list[upb out unirange list+:=1] := lwb OF value
    ELIF lwb OF value + 1 = upb OF value THEN
      out unirange list[upb out unirange list+:=1] := lwb OF value;
      out unirange list[upb out unirange list+:=1] := upb OF value
    ELSE
      out unirange list[upb out unirange list+:=1] := value
    FI
  );

  FOR key FROM LWB unirange list TO UPB unirange list DO
    UNIRANGE value = CASE unirange list IN
                       (SCALARLIST list):list[key],
                       (RANGELIST list):list[key],
                       (UNIRANGELIST list):list[key]
                     ESAC;

    RANGE next range := CASE value IN
        (RANGE range): range,
        (SCALAR value): RANGE(value, value)
      ESAC;

    prev range :=
      CASE prev range IN
        (VOID): next range,
        (RANGE prev range):
          IF upb OF prev range + 1 = lwb OF next range THEN
            RANGE(lwb OF prev range, upb OF next range) # merge the range #
          ELSE
            out unirange list append(prev range);
            next range
          FI
        OUT SKIP
      ESAC

  OD;

  CASE prev range IN
    (RANGE last range): out unirange list append(last range)
  ESAC;

  out unirange list[:upb out unirange list]
);
