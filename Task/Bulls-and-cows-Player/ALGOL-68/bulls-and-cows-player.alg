# This breaks a unique code of `n' pegs and `m' colours you think of. #

INT pegs = 4, colours = 6;

MODE LIST = FLEX [1 : 0] COMBINATION,
     COMBINATION = [pegs] COLOUR,
     COLOUR = INT;

OP +:= = (REF LIST u, COMBINATION v) REF LIST:
   # Add one combination to a list. #
   ([UPB u + 1] COMBINATION w; w[ : UPB u] := u; w[UPB w] := v; u := w);

PROC gen = (REF COMBINATION part, INT peg) VOID:
     # Generate all unique [colours!/(colours-pegs)!] combinations. #
     IF peg > pegs
     THEN all combs +:= part
     ELSE FOR i TO colours
          DO IF BOOL unique := TRUE;
                FOR j TO peg - 1 WHILE unique
                DO unique := part[j] ~= i
                OD;
                unique
             THEN part[peg] := i;
                  gen (part, peg + 1)
             FI
          OD
     FI;

LIST all combs;
gen (LOC COMBINATION, 1);

PROC break code = (LIST sieved) VOID:
     # Present a trial and sieve the list with the entered score. #
     CASE UPB sieved + 1
     IN # No elements. # printf ($l"Inconsistent scores"l$),
        # One element. # printf (($l"Solution is "4(xd)l$, sieved[1]))
     OUT printf (($l4(dx)$, sieved[1]));
     # Read the score as a sequence of "c" and "b". #
         INT col ok := 0, pos ok := 0, STRING z := "";
         WHILE z = ""
         DO read ((z, new line))
         OD;
         FOR i TO UPB z
         DO (z[i] = "c" | col ok |: z[i] = "b" | pos ok) +:= 1
         OD;
         (pos ok = pegs | stop);
     # Survivors are combinations with score as entered. #
         LIST survivors;
         FOR i FROM 2 TO UPB sieved
         DO INT col ok i := 0, pos ok i := 0;
            FOR u TO pegs
            DO FOR v TO pegs
               DO IF sieved[1][u] = sieved[i][v]
                  THEN (u = v | pos ok i | col ok i) +:= 1
                  FI
               OD
            OD;
            (col ok = col ok i AND pos ok = pos ok i | survivors +:= sieved[i])
         OD;
     # Solution must be among the survivors. #
         break code (survivors)
     ESAC;

break code (all combs)
