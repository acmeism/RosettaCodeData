PROC test non continuous = VOID: BEGIN
   MODE SEQMODE = CHAR;
   MODE SEQ = [1:0]SEQMODE;
   MODE YIELDSEQ = PROC(SEQ)VOID;

   PROC gen ncs =
             (  SEQ tail,       # To generate subsequences of #
                SEQ head,       #           Already generated #
                BOOL contiguous,#      It is still continuous #
                YIELDSEQ yield
             )  VOID:
   BEGIN
      IF NOT contiguous ANDTH UPB head > 1 THEN
         yield (head)
      FI;
      IF UPB tail /= 0 THEN
            [UPB head+1]SEQMODE new head;
            new head [:UPB head] := head;
            FOR i TO UPB tail DO
               new head [UPB new head] := tail [i];
               gen ncs
               (  tail[i + 1:UPB tail],
                  new head,
                  contiguous ANDTH (i = LWB tail OREL UPB head = 0),
                  yield
               )
            OD
      FI
   END # put ncs #;

 # FOR SEQ seq IN # gen ncs(("a","e","i","o","u"), (), TRUE, # ) DO ( #
 ##   (SEQ seq)VOID:
      print((seq, new line))
 # OD # )
END; test non continuous
