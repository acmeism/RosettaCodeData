PROC clrscr = VOID:
        printf(($g"[2J"$,REPR 27)); # ansi.sys #

PROC gotoxy = (INT x,y)VOID:
        printf(($g"["g(0)";"g(0)"H"$,REPR 27, y,x)); # ansi.sys #

MODE POINT = STRUCT(
    INT x,y
);

INT radius = 15;
INT inside radius = 10;

POINT center = (radius+1, radius+1);

FLEX[0]POINT set;

PROC swap with last set = (INT position,INT where last set)VOID:
(
        INT temp := x OF set[position];
        x OF set[position]:=x OF set[where last set];
        x OF set[where last set] := temp;

        temp := y OF set[position];
        y OF set[position]:=y OF set[where last set];
        y OF set[where last set] := temp
);

PROC create set = VOID:
(
        set := HEAP[(2*radius+1)**2]POINT;
        INT x,y,i:=LWB set;

        FOR x FROM -radius TO radius DO
                FOR y FROM -radius TO radius DO
                        IF sqrt(x*x+y*y)>=inside radius AND sqrt(x*x+y*y)<=radius THEN
                                x OF set[i] := x;
                                y OF set[i] := y;
                                i+:=1
                        FI
                OD
        OD;

        set:=set[:i-1]
);

PROC plot fuzzy set = (CHAR ch)VOID:
(
        INT pos,i;

        TO UPB set DO
                pos := ENTIER(random * UPB set) + 1;

                gotoxy(x OF center + x OF set[pos],y OF center + y OF set[pos]);

                print(ch);

                swap with last set(pos,UPB set)

        OD
);

main:
(
        # srand((INT)time(NIL)); #

        clrscr;
        create set;
        plot fuzzy set("*");
        gotoxy(2*radius+1, 2*radius+1);
        newline(stand in)
)
