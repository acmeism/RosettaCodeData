MODE YIELDINT = PROC(INT)VOID;

MODE RANGE = STRUCT(INT lwb, upb);
MODE RANGEINT = UNION(RANGE, INT);

OP SIZEOF = ([]RANGEINT list)INT: (
# determine the length of the output array #
  INT upb := LWB list - 1;
  FOR key FROM LWB list TO UPB list DO
    CASE list[key] IN
      (RANGE value): upb +:= upb OF value - lwb OF value + 1,
      (INT): upb +:= 1
    ESAC
  OD;
  upb
);

PROC gen range expand = ([]RANGEINT list, YIELDINT yield)VOID:
  FOR key FROM LWB list TO UPB list DO
    CASE list[key] IN
      (RANGE range): FOR value FROM lwb OF range TO upb OF range DO yield(value) OD,
      (INT int): yield(int)
    ESAC
  OD;

PROC range expand = ([]RANGEINT list)[]INT: (
  [LWB list: LWB list + SIZEOF list - 1]INT out;
  INT upb := LWB out - 1;
# FOR INT value IN # gen range expand(list, # ) DO #
##   (INT value)VOID:
    out[upb +:= 1] := value
# OD #);
  out
);

test:(
  []RANGEINT list = (-6, RANGE(-3, -1), RANGE(3, 5),  RANGE(7, 11), 14, 15, RANGE(17, 20));
  print((range expand(list), new line))
)
