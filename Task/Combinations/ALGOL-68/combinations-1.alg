# -*- coding: utf-8 -*- #

COMMENT REQUIRED BY "prelude_combinations_generative.a68"
  MODE COMBDATA = ~;
PROVIDES:
# COMBDATA*=~* #
# comb*=~ list* #
END COMMENT

MODE COMBDATALIST = REF[]COMBDATA;
MODE COMBDATALISTYIELD = PROC(COMBDATALIST)VOID;

PROC comb gen combinations = (INT m, COMBDATALIST list, COMBDATALISTYIELD yield)VOID:(
  CASE m IN
  # case 1: transpose list #
    FOR i TO UPB list DO yield(list[i]) OD
  OUT
    [m + LWB list - 1]COMBDATA out;
    INT index out := 1;
    FOR i TO UPB list DO
      COMBDATA first = list[i];
    # FOR COMBDATALIST sub recombination IN # comb gen combinations(m - 1, list[i+1:] #) DO (#,
    ##   (COMBDATALIST sub recombination)VOID:(
        out[LWB list   ] := first;
        out[LWB list+1:] := sub recombination;
        yield(out)
    # OD #))
    OD
  ESAC
);

SKIP
