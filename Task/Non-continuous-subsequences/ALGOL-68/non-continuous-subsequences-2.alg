MODE SEQMODE = STRING;
MODE SEQ = [1:0]SEQMODE;
MODE YIELDSEQ = PROC(SEQ)VOID;

PROC gen ncs = (SEQ seq, YIELDSEQ yield)VOID:
BEGIN
  IF UPB seq - 1 > bits width THEN stop FI;
  [UPB seq]SEQMODE out;  INT upb out;

  BITS lim := 16r1 SHL UPB seq;
  BITS upb k := lim SHR 1;
  # assert(lim); #

  BITS empty = 16r000000000; # const #

  FOR j TO ABS lim-1 DO
    INT state := 1;
    BITS k1 := upb k;
    WHILE k1 NE empty DO
      BITS b := BIN j AND k1;
      CASE state IN
        # state 1 # IF b NE empty THEN state +:= 1 FI,
        # state 2 # IF b EQ empty THEN state +:= 1 FI,
        # state 3 #
          BEGIN
            IF b EQ empty THEN GO TO continue k1 FI;
            upb out := 0;
            BITS k2 := upb k; FOR i WHILE k2 NE empty DO
              IF (BIN j AND k2) NE empty THEN out[upb out +:= 1] := seq[i] FI;
              k2 := k2 SHR 1
            OD;
            yield(out[:upb out]);
            k1 := empty # empty: ending containing loop #
         END
      ESAC;
      continue k1: k1 := k1 SHR 1
    OD
  OD
END;

main:(
  []STRING seqs = ("a","e","i","o","u");
# FOR SEQ seq IN # gen ncs(seqs, # ) DO ( #
##   (SEQ seq)VOID:
    print((seq, new line))
# OD # )
)
