# -*- coding: utf-8 -*- #

COMMENT REQUIRES:
  MODE QUATSCAL = REAL; # Scalar #
  QUATSCAL quat small scal = small real;
END COMMENT

# PROVIDES: #
FORMAT quat scal fmt := $g(-0, 4)$;
FORMAT signed fmt = $b("+", "")f(quat scal fmt)$;

FORMAT quat fmt = $f(quat scal fmt)"+"f(quat scal fmt)"i+"f(quat scal fmt)"j+"f(quat scal fmt)"k"$;
FORMAT squat fmt = $f(signed fmt)f(signed fmt)"i"f(signed fmt)"j"f(signed fmt)"k"$;

MODE QUAT = STRUCT(QUATSCAL r, i, j, k);
QUAT i=(0, 1, 0, 0),
     j=(0, 0, 1, 0),
     k=(0, 0, 0, 1);

MODE QUATCOSCAL = UNION(INT, SHORT REAL, SHORT INT);
MODE QUATSUBSCAL = UNION(QUATCOSCAL, QUATSCAL);

MODE COMPLSCAL = STRUCT(QUATSCAL r, im);
# compatable but not the same #
MODE ISOQUAT = UNION([]REAL, []INT, []SHORT REAL, []SHORT INT, []QUATSCAL);
MODE COQUAT  = UNION(COMPLSCAL, QUATCOSCAL, ISOQUAT);
MODE SUBQUAT = UNION(COQUAT, QUAT); # subset is itself #

MODE QUATERNION = QUAT;

PROC quat fix type error = (QUAT quat, []STRING msg)BOOL: (
  putf(stand error, ($"Type error:"$,$" "g$, msg, quat fmt, quat, $l$));
  stop
);

COMMENT
For a list of coercions expected in A68 c.f.
* http://rosettacode.org/wiki/ALGOL_68#Coercion_.28casting.29 # ...

Pre-Strong context: Deproceduring, dereferencing & uniting. e.g. OP arguments
  * soft(deproceduring for assignment),
  * weak(dereferencing for slicing and OF selection),
  * meek(dereferencing for indexing, enquiries and PROC calls),
  * firm(uniting of OPerators),
Strong context only: widening (INT=>REAL=>COMPL), rowing (REAL=>[]REAL) & voiding
  * strong(widening,rowing,voiding for identities/initialisations, arguments and casts et al)
Key points:
  * arguments to OPerators do not widen or row!
  * UNITING is permitted in OP/String ccontext.

There are 4 principle scenerios for most operators:
+---------------+-------------------------------+-------------------------------+
|  OP e.g. *    |  SCALar                       |  QUATernion                   |
+---------------+-------------------------------+-------------------------------+
|  SCALar       |  SCAL * SCAL ... inherit      |  SCAL * QUAT                  |
+---------------+-------------------------------+-------------------------------+
|  QUATernion   |  QUAT * SCAL                  |  QUAT * QUAT                  |
+---------------+-------------------------------+-------------------------------+
However this is compounded with SUBtypes of the SCALar & isomorphs the QUATernion,
e.g.
* SCAL may be a superset of SHORT REAL or INT - a widening coercion is required
* QUAT may be a superset eg of COMPL or [4]INT
* QUAT may be a structural isomorph eg of [4]REAL
+---------------+---------------+---------------+---------------+---------------+
|  OP e.g. *    |  SUBSCAL      |  SCALar       |  COQUAT       |  QUATernion   |
+---------------+---------------+---------------+---------------+---------------+
|  SUBSCAL      |                               |  inherit      |  SUBSCAT*QUAT |
+---------------+           inherit             +---------------+---------------+
|  SCALar       |                               |  inherit      |  SCAL * QUAT  |
+---------------+---------------+---------------+---------------+---------------+
|  COQUAT       |  inherit      |  inherit      |  inherit      |  COQUAT*QUAT  |
+---------------+---------------+---------------+---------------+---------------+
|  QUATernion   | QUAT*SUBSCAL  |  QUAT*SCAL    | QUAT * COQUAT |  QUAT * QUAT  |
+---------------+---------------+---------------+---------------+---------------+
Keypoint: if an EXPLICIT QUAT is not involved, then we can simple inherit, OR QUATINIT!
END COMMENT

MODE CLASSQUAT = STRUCT(
    PROC (REF QUAT #new#, QUATSCAL #r#, QUATSCAL #i#, QUATSCAL #j#, QUATSCAL #k#)REF QUAT new,
    PROC (REF QUAT #self#)QUAT conjugate,
    PROC (REF QUAT #self#)QUATSCAL norm sq,
    PROC (REF QUAT #self#)QUATSCAL norm,
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

  # PROC new =#(REF QUAT new, QUATSCAL r, i, j, k)REF QUAT: (
        # 'Defaults all parts of quaternion to zero' #
        IF new ISNT REF QUAT(NIL) THEN new ELSE HEAP QUAT FI := (r, i, j, k)
    ),

  # PROC conjugate =#(REF QUAT self)QUAT:
        (r OF self, -i OF self, -j OF self, -k OF self),

  # PROC norm sq =#(REF QUAT self)QUATSCAL:
        r OF self**2 + i OF self**2 + j OF self**2 + k OF self**2,

  # PROC norm =#(REF QUAT self)QUATSCAL:
        sqrt((norm sq OF class quat)(self)),

  # PROC reciprocal =#(REF QUAT self)QUAT:(
        QUATSCAL n2 = (norm sq OF class quat)(self);
        QUAT conj = (conjugate OF class quat)(self);
        (r OF conj/n2, i OF conj/n2, j OF conj/n2, k OF conj/n2)
    ),

  # PROC repr =#(REF QUAT self)STRING: (
        # 'Shorter form of Quaternion as string' #
        FILE f; STRING s; associate(f, s);
        putf(f, (squat fmt, r OF self>=0, r OF self,
             i OF self>=0, i OF self, j OF self>=0, j OF self, k OF self>=0, k OF self));
        close(f);
        s
    ),

  # PROC neg =#(REF QUAT self)QUAT:
        (-r OF self, -i OF self, -j OF self, -k OF self),

  # PROC add =#(REF QUAT self, SUBQUAT other)QUAT:
        CASE other IN
            (QUAT other): (r OF self + r OF other, i OF self + i OF other, j OF self + j OF other, k OF self + k OF other),
            (QUATSUBSCAL other): (r OF self + QUATSCALINIT other, i OF self, j OF self, k OF self)
        OUT IF quat fix type error(SKIP,"in add") THEN SKIP ELSE stop FI
        ESAC,

  # PROC radd =#(REF QUAT self, SUBQUAT other)QUAT:
        (add OF class quat)(self, other),

  # PROC sub =#(REF QUAT self, SUBQUAT other)QUAT:
        CASE other IN
            (QUAT other): (r OF self - r OF other, i OF self - i OF other, j OF self - j OF other, k OF self - k OF other),
            (QUATSCAL other): (r OF self - other, i OF self, j OF self, k OF self)
        OUT IF quat fix type error(self,"in sub") THEN SKIP ELSE stop FI
        ESAC,

  # PROC mul =#(REF QUAT self, SUBQUAT other)QUAT:
        CASE other IN
            (QUAT other):(
                 r OF self*r OF other - i OF self*i  OF other - j OF self*j  OF other - k OF self*k  OF other,
                 r OF self*i  OF other + i OF self*r OF other + j OF self*k  OF other - k OF self*j  OF other,
                 r OF self*j  OF other - i OF self*k  OF other + j OF self*r OF other + k OF self*i  OF other,
                 r OF self*k  OF other + i OF self*j  OF other - j OF self*i  OF other + k OF self*r OF other
            ),
            (QUATSCAL other): ( r OF self * other, i OF self * other, j OF self * other, k OF self * other)
        OUT IF quat fix type error(self,"in mul") THEN SKIP ELSE stop FI
        ESAC,

  # PROC rmul =#(REF QUAT self, SUBQUAT other)QUAT:
        CASE other IN
          (QUAT other): (mul OF class quat)(LOC QUAT := other, self),
          (QUATSCAL other): (mul OF class quat)(self, other)
        OUT IF quat fix type error(self,"in rmul") THEN SKIP ELSE stop FI
        ESAC,

  # PROC div =#(REF QUAT self, SUBQUAT other)QUAT:
        CASE other IN
            (QUAT other): (mul OF class quat)(self, (reciprocal OF class quat)(LOC QUAT := other)),
            (QUATSCAL other): (mul OF class quat)(self, 1/other)
        OUT IF quat fix type error(self,"in div") THEN SKIP ELSE stop FI
        ESAC,

  # PROC rdiv =#(REF QUAT self, SUBQUAT other)QUAT:
        CASE other IN
          (QUAT other): (div OF class quat)(LOC QUAT := other, self),
          (QUATSCAL other): (div OF class quat)(LOC QUAT := (other, 0, 0, 0), self)
        OUT IF quat fix type error(self,"in rdiv") THEN SKIP ELSE stop FI
        ESAC,

  # PROC exp =#(REF QUAT self)QUAT: (
    QUAT fac := self;
    QUAT sum := 1.0 + fac;
    FOR i FROM 2 TO bits width WHILE ABS(fac + quat small scal) /= quat small scal DO
      VOID(sum +:= (fac *:= self / ##QUATSCAL(i)))
    OD;
    sum
  )
);

PRIO INIT = 1;
OP QUATSCALINIT = (QUATSUBSCAL scal)QUATSCAL:
  CASE scal IN
    (INT scal): scal,
    (SHORT INT scal): scal,
    (SHORT REAL scal): scal
    OUT IF quat fix type error(SKIP,"in QUATSCALINIT") THEN SKIP ELSE stop FI
  ESAC;

OP INIT = (REF QUAT new, SUBQUAT from)REF QUAT:
  new :=
    CASE from IN
      (QUATSUBSCAL scal):(QUATSCALINIT scal, 0, 0, 0)
      #(COQUAT rijk):(new OF class quat)(LOC QUAT := new, rijk[1], rijk[2], rijk[3], rijk[4]),#
    OUT IF quat fix type error(SKIP,"in INIT") THEN SKIP ELSE stop FI
    ESAC;


OP QUATINIT = (COQUAT lhs)REF QUAT: (HEAP QUAT)INIT lhs;

OP +    = (QUAT q)QUAT:   q,
   -    = (QUAT q)QUAT:   (neg  OF class quat)(LOC QUAT := q),
   CONJ = (QUAT q)QUAT:   (conjugate OF class quat)(LOC QUAT := q),
   ABS  = (QUAT q)QUATSCAL:   (norm OF class quat)(LOC QUAT := q),
   REPR = (QUAT q)STRING: (repr OF class quat)(LOC QUAT := q);
# missing: Diadic: I, J, K END #

OP +:= = (REF QUAT a, QUAT b)QUAT: a:=( add OF class quat)(a, b),
   +:= = (REF QUAT a, COQUAT b)QUAT: a:=( add OF class quat)(a, b),
   +=: = (QUAT a, REF QUAT b)QUAT: b:=(radd OF class quat)(b, a),
   +=: = (COQUAT a, REF QUAT b)QUAT: b:=(radd OF class quat)(b, a);
# missing: Worthy PLUSAB, PLUSTO for SHORT/LONG INT QUATSCAL & COMPL #

OP -:= = (REF QUAT a, QUAT b)QUAT: a:=( sub OF class quat)(a, b),
   -:= = (REF QUAT a, COQUAT b)QUAT: a:=( sub OF class quat)(a, b);
# missing: Worthy MINUSAB for SHORT/LONG INT ##COQUAT & COMPL #

PRIO *=: = 1, /=: = 1;
OP *:= = (REF QUAT a, QUAT b)QUAT: a:=( mul OF class quat)(a, b),
   *:= = (REF QUAT a, COQUAT b)QUAT: a:=( mul OF class quat)(a, b),
   *=: = (QUAT a, REF QUAT b)QUAT: b:=(rmul OF class quat)(b, a),
   *=: = (COQUAT a, REF QUAT b)QUAT: b:=(rmul OF class quat)(b, a);
# missing: Worthy TIMESAB, TIMESTO for SHORT/LONG INT ##COQUAT & COMPL #

OP /:= = (REF QUAT a, QUAT b)QUAT: a:=( div OF class quat)(a, b),
   /:= = (REF QUAT a, COQUAT b)QUAT: a:=( div OF class quat)(a, b),
   /=: = (QUAT a, REF QUAT b)QUAT: b:=(rdiv OF class quat)(b, a),
   /=: = (COQUAT a, REF QUAT b)QUAT: b:=(rdiv OF class quat)(b, a);
# missing: Worthy OVERAB, OVERTO for SHORT/LONG INT ##COQUAT & COMPL #

OP + = (QUAT a, b)QUAT:      ( add OF class quat)(LOC QUAT := a, b),
   + = (QUAT a, COQUAT b)QUAT: ( add OF class quat)(LOC QUAT := a, b),
   + = (COQUAT a, QUAT b)QUAT: (radd OF class quat)(LOC QUAT := b, a);

OP - = (QUAT a, b)QUAT:      ( sub OF class quat)(LOC QUAT := a, b),
   - = (QUAT a, COQUAT b)QUAT: ( sub OF class quat)(LOC QUAT := a, b),
   - = (COQUAT a, QUAT b)QUAT:-( sub OF class quat)(LOC QUAT := b, a);

OP * = (QUAT a, b)QUAT:      ( mul OF class quat)(LOC QUAT := a, b),
   * = (QUAT a, COQUAT b)QUAT: ( mul OF class quat)(LOC QUAT := a, b),
   * = (COQUAT a, QUAT b)QUAT: (rmul OF class quat)(LOC QUAT := b, a);

OP / = (QUAT a, b)QUAT:      ( div OF class quat)(LOC QUAT := a, b),
   / = (QUAT a, COQUAT b)QUAT: ( div OF class quat)(LOC QUAT := a, b),
   / = (COQUAT a, QUAT b)QUAT:
         ( div OF class quat)(LOC QUAT := QUATINIT 1, a);

PROC quat exp = (QUAT q)QUAT:   (exp OF class quat)(LOC QUAT := q);

SKIP # missing: quat arc{sin, cos, tan}h, log, exp, ln etc END #
