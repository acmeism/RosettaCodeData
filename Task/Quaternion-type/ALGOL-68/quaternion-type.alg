MODE QUAT = STRUCT(REAL re, i, j, k);
MODE QUATERNION = QUAT;
MODE SUBQUAT = UNION(QUAT, #COMPL, # REAL#, INT, [4]REAL, [4]INT # );

MODE CLASSQUAT = STRUCT(
    PROC (REF QUAT #new#, REAL #re#, REAL #i#, REAL #j#, REAL #k#)REF QUAT new,
    PROC (REF QUAT #self#)QUAT conjugate,
    PROC (REF QUAT #self#)REAL norm sq,
    PROC (REF QUAT #self#)REAL norm,
    PROC (REF QUAT #self#)QUAT reciprocal,
    PROC (REF QUAT #self#)STRING repr,
    PROC (REF QUAT #self#)QUAT neg,
    PROC (REF QUAT #self#, SUBQUAT #other#)QUAT add,
    PROC (REF QUAT #self#, SUBQUAT #other#)QUAT radd,
    PROC (REF QUAT #self#, SUBQUAT #other#)QUAT sub,
    PROC (REF QUAT #self#, SUBQUAT #other#)QUAT mul,
    PROC (REF QUAT #self#, SUBQUAT #other#)QUAT rmul,
    PROC (REF QUAT #self#, SUBQUAT #other#)QUAT div,
    PROC (REF QUAT #self#, SUBQUAT #other#)QUAT rdiv,
    PROC (REF QUAT #self#)QUAT exp
);

CLASSQUAT class quat = (

  # PROC new =#(REF QUAT new, REAL re, i, j, k)REF QUAT: (
        # 'Defaults all parts of quaternion to zero' #
        IF new ISNT REF QUAT(NIL) THEN new ELSE HEAP QUAT FI := (re, i, j, k)
    ),

  # PROC conjugate =#(REF QUAT self)QUAT:
        (re OF self, -i OF self, -j OF self, -k OF self),

  # PROC norm sq =#(REF QUAT self)REAL:
        re OF self**2 + i OF self**2 + j OF self**2 + k OF self**2,

  # PROC norm =#(REF QUAT self)REAL:
        sqrt((norm sq OF class quat)(self)),

  # PROC reciprocal =#(REF QUAT self)QUAT:(
        REAL n2 = (norm sq OF class quat)(self);
        QUAT conj = (conjugate OF class quat)(self);
        (re OF conj/n2, i OF conj/n2, j OF conj/n2, k OF conj/n2)
    ),

  # PROC repr =#(REF QUAT self)STRING: (
        # 'Shorter form of Quaternion as string' #
        FILE f; STRING s; associate(f, s);
        putf(f, (squat fmt, re OF self>=0, re OF self,
             i OF self>=0, i OF self, j OF self>=0, j OF self, k OF self>=0, k OF self));
        close(f);
        s
    ),

  # PROC neg =#(REF QUAT self)QUAT:
        (-re OF self, -i OF self, -j OF self, -k OF self),

  # PROC add =#(REF QUAT self, SUBQUAT other)QUAT:
        CASE other IN
            (QUAT other): (re OF self + re OF other, i OF self + i OF other, j OF self + j OF other, k OF self + k OF other),
            (REAL other): (re OF self + other, i OF self, j OF self, k OF self)
        ESAC,

  # PROC radd =#(REF QUAT self, SUBQUAT other)QUAT:
        (add OF class quat)(self, other),

  # PROC sub =#(REF QUAT self, SUBQUAT other)QUAT:
        CASE other IN
            (QUAT other): (re OF self - re OF other, i OF self - i OF other, j OF self - j OF other, k OF self - k OF other),
            (REAL other): (re OF self - other, i OF self, j OF self, k OF self)
        ESAC,

  # PROC mul =#(REF QUAT self, SUBQUAT other)QUAT:
        CASE other IN
            (QUAT other):(
                 re OF self*re OF other - i OF self*i  OF other - j OF self*j  OF other - k OF self*k  OF other,
                 re OF self*i  OF other + i OF self*re OF other + j OF self*k  OF other - k OF self*j  OF other,
                 re OF self*j  OF other - i OF self*k  OF other + j OF self*re OF other + k OF self*i  OF other,
                 re OF self*k  OF other + i OF self*j  OF other - j OF self*i  OF other + k OF self*re OF other
            ),
            (REAL other): ( re OF self * other, i OF self * other, j OF self * other, k OF self * other)
        ESAC,

  # PROC rmul =#(REF QUAT self, SUBQUAT other)QUAT:
        CASE other IN
          (QUAT other): (mul OF class quat)(LOC QUAT := other, self),
          (REAL other): (mul OF class quat)(self, other)
        ESAC,

  # PROC div =#(REF QUAT self, SUBQUAT other)QUAT:
        CASE other IN
            (QUAT other): (mul OF class quat)(self, (reciprocal OF class quat)(LOC QUAT := other)),
            (REAL other): (mul OF class quat)(self, 1/other)
        ESAC,

  # PROC rdiv =#(REF QUAT self, SUBQUAT other)QUAT:
        CASE other IN
          (QUAT other): (div OF class quat)(LOC QUAT := other, self),
          (REAL other): (div OF class quat)(LOC QUAT := (other, 0, 0, 0), self)
        ESAC,

  # PROC exp =#(REF QUAT self)QUAT: (
    QUAT fac := self;
    QUAT sum := 1.0 + fac;
    FOR i FROM 2 WHILE ABS(fac + small real) /= small real DO
      VOID(sum +:= (fac *:= self / REAL(i)))
    OD;
    sum
  )
);

FORMAT real fmt = $g(-0, 4)$;
FORMAT signed fmt = $b("+", "")f(real fmt)$;

FORMAT quat fmt = $f(real fmt)"+"f(real fmt)"i+"f(real fmt)"j+"f(real fmt)"k"$;
FORMAT squat fmt = $f(signed fmt)f(signed fmt)"i"f(signed fmt)"j"f(signed fmt)"k"$;

PRIO INIT = 1;
OP INIT = (REF QUAT new)REF QUAT: new := (0, 0, 0, 0);
OP INIT = (REF QUAT new, []REAL rijk)REF QUAT:
    (new OF class quat)(LOC QUAT := new, rijk[1], rijk[2], rijk[3], rijk[4]);

OP +    = (QUAT q)QUAT:   q,
   -    = (QUAT q)QUAT:   (neg  OF class quat)(LOC QUAT := q),
   CONJ = (QUAT q)QUAT:   (conjugate OF class quat)(LOC QUAT := q),
   ABS  = (QUAT q)REAL:   (norm OF class quat)(LOC QUAT := q),
   REPR = (QUAT q)STRING: (repr OF class quat)(LOC QUAT := q);
# missing: Diadic: I, J, K END #

OP +:= = (REF QUAT a, QUAT b)QUAT: a:=( add OF class quat)(a, b),
   +:= = (REF QUAT a, REAL b)QUAT: a:=( add OF class quat)(a, b),
   +=: = (QUAT a, REF QUAT b)QUAT: b:=(radd OF class quat)(b, a),
   +=: = (REAL a, REF QUAT b)QUAT: b:=(radd OF class quat)(b, a);
# missing: Worthy PLUSAB, PLUSTO for SHORT/LONG INT REAL & COMPL #

OP -:= = (REF QUAT a, QUAT b)QUAT: a:=( sub OF class quat)(a, b),
   -:= = (REF QUAT a, REAL b)QUAT: a:=( sub OF class quat)(a, b);
# missing: Worthy MINUSAB for SHORT/LONG INT REAL & COMPL #

PRIO *=: = 1, /=: = 1;
OP *:= = (REF QUAT a, QUAT b)QUAT: a:=( mul OF class quat)(a, b),
   *:= = (REF QUAT a, REAL b)QUAT: a:=( mul OF class quat)(a, b),
   *=: = (QUAT a, REF QUAT b)QUAT: b:=(rmul OF class quat)(b, a),
   *=: = (REAL a, REF QUAT b)QUAT: b:=(rmul OF class quat)(b, a);
# missing: Worthy TIMESAB, TIMESTO for SHORT/LONG INT REAL & COMPL #

OP /:= = (REF QUAT a, QUAT b)QUAT: a:=( div OF class quat)(a, b),
   /:= = (REF QUAT a, REAL b)QUAT: a:=( div OF class quat)(a, b),
   /=: = (QUAT a, REF QUAT b)QUAT: b:=(rdiv OF class quat)(b, a),
   /=: = (REAL a, REF QUAT b)QUAT: b:=(rdiv OF class quat)(b, a);
# missing: Worthy OVERAB, OVERTO for SHORT/LONG INT REAL & COMPL #

OP + = (QUAT a, b)QUAT:      ( add OF class quat)(LOC QUAT := a, b),
   + = (QUAT a, REAL b)QUAT: ( add OF class quat)(LOC QUAT := a, b),
   + = (REAL a, QUAT b)QUAT: (radd OF class quat)(LOC QUAT := b, a);

OP - = (QUAT a, b)QUAT:      ( sub OF class quat)(LOC QUAT := a, b),
   - = (QUAT a, REAL b)QUAT: ( sub OF class quat)(LOC QUAT := a, b),
   - = (REAL a, QUAT b)QUAT:-( sub OF class quat)(LOC QUAT := b, a);

OP * = (QUAT a, b)QUAT:      ( mul OF class quat)(LOC QUAT := a, b),
   * = (QUAT a, REAL b)QUAT: ( mul OF class quat)(LOC QUAT := a, b),
   * = (REAL a, QUAT b)QUAT: (rmul OF class quat)(LOC QUAT := b, a);

OP / = (QUAT a, b)QUAT:      ( div OF class quat)(LOC QUAT := a, b),
   / = (QUAT a, REAL b)QUAT: ( div OF class quat)(LOC QUAT := a, b),
   / = (REAL a, QUAT b)QUAT: ( div OF class quat)(LOC QUAT := b, 1/a);

PROC quat exp = (QUAT q)QUAT:   (exp OF class quat)(LOC QUAT := q);
# missing: quat arc{sin, cos, tan}h, log, exp, ln etc END #

test:(
    REAL r = 7;
    QUAT q  = (1, 2, 3, 4),
         q1 = (2, 3, 4, 5),
         q2 = (3, 4, 5, 6);

    printf((
        $"r = "      f(real fmt)l$, r,
        $"q = "      f(quat fmt)l$, q,
        $"q1 = "     f(quat fmt)l$, q1,
        $"q2 = "     f(quat fmt)l$, q2,
        $"ABS q = "  f(real fmt)", "$, ABS q,
        $"ABS q1 = " f(real fmt)", "$, ABS q1,
        $"ABS q2 = " f(real fmt)l$, ABS q2,
        $"-q = "     f(quat fmt)l$, -q,
        $"CONJ q = " f(quat fmt)l$, CONJ q,
        $"r + q = "  f(quat fmt)l$, r + q,
        $"q + r = "  f(quat fmt)l$, q + r,
        $"q1 + q2 = "f(quat fmt)l$, q1 + q2,
        $"q2 + q1 = "f(quat fmt)l$, q2 + q1,
        $"q * r = "  f(quat fmt)l$, q * r,
        $"r * q = "  f(quat fmt)l$, r * q,
        $"q1 * q2 = "f(quat fmt)l$, q1 * q2,
        $"q2 * q1 = "f(quat fmt)l$, q2 * q1
    ));

CO
        $"ASSERT q1 * q2 != q2 * q1 = "f(quat fmt)l$, ASSERT q1 * q2 != q2 * q1, $l$);
END CO

    QUAT i=(0, 1, 0, 0),
         j=(0, 0, 1, 0),
         k=(0, 0, 0, 1);

    printf((
        $"i*i = "         f(quat fmt)l$, i*i,
        $"j*j = "         f(quat fmt)l$, j*j,
        $"k*k = "         f(quat fmt)l$, k*k,
        $"i*j*k = "       f(quat fmt)l$, i*j*k,
        $"q1 / q2 = "     f(quat fmt)l$, q1 / q2,
        $"q1 / q2 * q2 = "f(quat fmt)l$, q1 / q2 * q2,
        $"q2 * q1 / q2 = "f(quat fmt)l$, q2 * q1 / q2,
        $"1/q1 * q1 = "   f(quat fmt)l$, 1.0/q1 * q1,
        $"q1 / q1 = "     f(quat fmt)l$, q1 / q1,
        $"quat exp(pi * i) = " f(quat fmt)l$, quat exp(pi * i),
        $"quat exp(pi * j) = " f(quat fmt)l$, quat exp(pi * j),
        $"quat exp(pi * i) = " f(quat fmt)l$, quat exp(pi * k)
    ));
    print((REPR(-q1*q2), ", ", REPR(-q2*q1), new line))
)
