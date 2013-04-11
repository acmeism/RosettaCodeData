PRIO DICE = 9; # ideally = 11 #

OP DICE = ([]SCALAR in, INT step)[]SCALAR: (
    ### Dice the array, extract array values a "step" apart ###
    IF step = 1 THEN
        in
    ELSE
        INT upb out := 0;
        [(UPB in-LWB in)%step+1]SCALAR out;
        FOR index FROM LWB in BY step TO UPB in DO
            out[upb out+:=1] := in[index] OD;
        out[@LWB in]
    FI
);

PROC fft = ([]SCALAR in t)[]SCALAR: (
    ### The Cooley-Tukey FFT algorithm ###
    IF LWB in t >= UPB in t THEN
      in t[@0]
    ELSE
        []SCALAR t = in t[@0];
        INT n = UPB t + 1, half n = n % 2;
        [LWB t:UPB t]SCALAR coef;

        []SCALAR even = fft(t    DICE 2),
                  odd = fft(t[1:]DICE 2);

        COMPL i = 0 I 1;

        REAL w =  2*pi / n;
        FOR k FROM LWB t TO half n-1 DO
            COMPL cis t = scalar exp(0 I (-w * k))*odd[k];
            coef[k]          := even[k] + cis t;
            coef[k + half n] := even[k] - cis t
        OD;
        coef
    FI
);
