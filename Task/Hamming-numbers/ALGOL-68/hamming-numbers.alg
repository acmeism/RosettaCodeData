PR precision=100 PR

MODE SERIES = FLEX [1 : 0] UNT, # Initially, no elements #
     UNT = LONG LONG INT; # A 100-digit unsigned integer #

PROC hamming number = (INT n) UNT: # The n-th Hamming number #
     CASE n
     IN 1, 2, 3, 4, 5, 6, 8, 9, 10, 12 # First 10 in a table #
     OUT # Additional operators #
         OP MIN = (INT i, j) INT: (i < j | i | j), MIN = (UNT i, j) UNT: (i < j | i | j);
         PRIO MIN = 9;
         OP LAST = (SERIES h) UNT: h[UPB h]; # Last element of a series #
         OP +:= = (REF SERIES s, UNT elem) VOID:
            # Extend a series by one element, only keep the elements you need #
            (INT lwb = (i MIN j) MIN k, upb = UPB s;
             REF SERIES new s = HEAP FLEX [lwb : upb + 1] UNT;
             (new s[lwb : upb] := s[lwb : upb], new s[upb + 1] := elem);
             s := new s
            );
         # Determine the n-th hamming number iteratively #
         SERIES h := 1, # Series, initially one element #
         UNT m2 := 2, m3 := 3, m5 := 5, # Multipliers #
         INT i := 1, j := 1, k := 1; # Counters #
         TO n - 1
         DO h +:= (m2 MIN m3) MIN m5;
            (LAST h = m2 | m2 := 2 * h[i +:= 1]);
            (LAST h = m3 | m3 := 3 * h[j +:= 1]);
            (LAST h = m5 | m5 := 5 * h[k +:= 1])
         OD;
         LAST h
     ESAC;

FOR k TO 20
DO print ((whole (hamming number (k), 0), blank))
OD;
print ((newline, whole (hamming number (1 691), 0)));
print ((newline, whole (hamming number (1 000 000), 0)))
