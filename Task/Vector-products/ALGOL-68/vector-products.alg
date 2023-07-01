MODE FIELD = INT;
FORMAT field fmt = $g(-0)$;

MODE VEC = [3]FIELD;
FORMAT vec fmt = $"("f(field fmt)", "f(field fmt)", "f(field fmt)")"$;

PROC crossp = (VEC a, b)VEC:(
    #Cross product of two 3D vectors#
    CO ASSERT(LWB a = LWB b AND UPB a = UPB b AND UPB b = 3 # "For 3D vectors only" #); CO
    (a[2]*b[3] - a[3]*b[2], a[3]*b[1] - a[1]*b[3], a[1]*b[2] - a[2]*b[1])
);

PRIO MAXLWB = 8, MINUPB=8;

OP MAXLWB = (VEC a, b)INT: (LWB a<LWB b|LWB a|LWB b);
OP MINUPB = (VEC a, b)INT: (UPB a>UPB b|UPB a|UPB b);

PROC dotp = (VEC a, b)FIELD:(
    #Dot product of two vectors#
    FIELD sum := 0;
    FOR i FROM a MAXLWB b TO a MINUPB b DO sum +:= a[i]*b[i] OD;
    sum
);

PROC scalartriplep = (VEC a, b, c)VEC:(
    #Scalar triple product of three vectors: "a . (b x c)"#
    dotp(a, crossp(b, c))
);

PROC vectortriplep = (VEC a, b, c)VEC:(
    #Vector triple product of three vectors: "a x (b x c)"#
    crossp(a, crossp(b, c))
);

# Declare some useful operators #
PRIO DOT = 5, X = 5;
OP (VEC, VEC)FIELD DOT = dotp;
OP (VEC, VEC)VEC X = crossp;

main:(
    VEC a=(3, 4, 5), b=(4, 3, 5), c=(-5, -12, -13);
    printf(($"a = "f(vec fmt)";  b = "f(vec fmt)";  c = "f(vec fmt)l$ , a, b, c));
    printf($"Using PROCedures:"l$);
    printf(($"a . b = "f(field fmt)l$, dotp(a,b)));
    printf(($"a x b = "f(vec fmt)l$, crossp(a,b)));
    printf(($"a . (b x c) = "f(field fmt)l$, scalartriplep(a, b, c)));
    printf(($"a x (b x c) = "f(vec fmt)l$, vectortriplep(a, b, c)));
    printf($"Using OPerators:"l$);
    printf(($"a . b = "f(field fmt)l$, a DOT b));
    printf(($"a x b = "f(vec fmt)l$, a X b));
    printf(($"a . (b x c) = "f(field fmt)l$, a DOT (b X c)));
    printf(($"a x (b x c) = "f(vec fmt)l$, a X (b X c)))
)
