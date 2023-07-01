# -*- coding: utf-8 -*- #

COMMENT REQUIRED BY "prelude_permutations.a68"
  MODE PERMDATA = ~;
PROVIDES:
# PERMDATA*=~* #
# perm*=~ list* #
END COMMENT

MODE PERMDATALIST = REF[]PERMDATA;
MODE PERMDATALISTYIELD = PROC(PERMDATALIST)VOID;

# Generate permutations of the input data list of data list #
PROC perm gen permutations = (PERMDATALIST data list, PERMDATALISTYIELD yield)VOID: (
# Warning: this routine does not correctly handle duplicate elements #
  IF LWB data list = UPB data list THEN
    yield(data list)
  ELSE
    FOR elem FROM LWB data list TO UPB data list DO
      PERMDATA first = data list[elem];
      data list[LWB data list+1:elem] := data list[:elem-1];
      data list[LWB data list] := first;
    # FOR PERMDATALIST next data list IN # perm gen permutations(data list[LWB data list+1:] # ) DO #,
    ##   (PERMDATALIST next)VOID:(
        yield(data list)
    # OD #));
      data list[:elem-1] := data list[LWB data list+1:elem];
      data list[elem] := first
    OD
  FI
);

SKIP
