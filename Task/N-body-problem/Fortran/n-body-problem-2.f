Calculate some parameters for the solar system of Sun, Earth and Moon.
      IMPLICIT REAL*8 (A-Z)	!No integers need apply.
      CBRT(X) = SIGN(EXP(LOG(ABS(X))/3),X)	!Crude. Fails for zero.
      PI = 4*ATAN(1D0)
      G = 6.674210D-11		!Gravitational constant, MKS units.
      MS = 1.98844D+30		!Mass of the sun.
      ME = 5.9742D+24		!Mass of the earth.
      MM = 7.3483D+22		!Mass of the moon.
      RE = 1.49597870D+11	!Radius of the earth's orbit around the sun. 1 Astronomical Unit = semi-major axis.
      RM = 3.844D+8		!Radius of the moon's orbit around the earth.
      YS = 31556925.9747D0	!Earth's tropical year, in seconds. This includes precession.
      Y = YS/24/3600            !In days. This is *not* the proper orbit-repetition time!

      WRITE (6,*) Y,"Tropical year, days."
      WRITE (6,*) "Earth's orbit taken as circular, but using Rmax."
      WRITE (6,*) 2*PI*SQRT(RE**3/(G*MS))/3600/24,"Year, in days"
      WRITE (6,*) 2*PI*SQRT(RE**3/(G*(MS + ME)))/3600/24,"Me included."
      RC = CBRT(G*(MS + ME)*YS**2/(4*PI**2))
      WRITE (6,*) "Circular orbit of period one tropical year."
      WRITE (6,*) RC,"Rc: Earth's circular orbit radius."
      WRITE (6,*) RE,"Re: Actual semi-major axis."
      WRITE (6,*) RE - RC,"Re - Rc"
      OS  = RC*ME/MS
      WRITE (6,*) OS ,"Os: Sun's offset from CoM due to Earth at Rc."
      VE = 2*PI*RC/YS
      WRITE (6,*) VE,"Ve: Earth's circular orbit velocity."
      WS = 2*PI*OS/YS
      WRITE (6,*) WS,"Ws: Sun's circular orbit velocity due to Earth."

      WRITE (6,*)
      WRITE (6,*) RM,"Rm: radius of the moon's orbit around the earth."
      TM = 2*PI*SQRT(RM**3/(G*(ME + MM)))/3600/24
      WRITE (6,*) TM,"Tm: time for the moon's circular orbit, days."
      OE = RM*MM/ME
      WRITE (6,*) OE,"Oe: Earth's offset from CoM due to Moon at Rm."
      VM = 2*PI*RM/(TM*3600*24)
      WRITE (6,*) VM,"Vm: Moon's circular orbit velocity."
      WE = 2*PI*OE/(TM*3600*24)
      WRITE (6,*) WE,"We: Earth's circular orbit velocity due to Moon."
Combine the offsets and wobbles for the Sun-----Earth-Moon in a straight line
      WRITE (6,*)
      WRITE (6,*) "   (CoM)"
      WRITE (6,*) "Sun--0-----------------------------Earth--Moon-->x"
      RC = CBRT(G*(MS + ME + MM)*YS**2/(4*PI**2))
      WRITE (6,*) RC," Rc: Earth's circular orbit for Sun+Earth+Moon."
      SX = -(ME*(RC - OE) + MM*(RC + RM))/MS
      WRITE (6,*) SX," Sx: Sun's   x-position, offset by Earth+Moon."
      SVY = 2*PI*SX/YS
      WRITE (6,*) SVY,"SVy: Sun's   y-velocity."
      EX = RC - OE
      WRITE (6,*) EX," Ex: Earth's x-position, offset by Moon."
      EVY = VE - WE
      WRITE (6,*) EVY,"EVy: Earth's y-velocity."
      MX = RC + RM
      WRITE (6,*) MX," Mx: Moon's  x-position."
      MVY = VE + VM
      WRITE (6,*) MVY,"MVy: Moon's  y-velocity."
Convert to 'AU', being one earth orbit radius for a circular orbit taking one year.
      WRITE (6,10)
   10 FORMAT (/," Time in years, masses in suns, distances in 'AU'",
     1 /,12X,"Solar masses        x-position        y-velocity.")
      WRITE (6,11) "Sun",1.0,SX/RC,SVY/RC*YS
      WRITE (6,11) "Earth",ME/MS,EX/RC,EVY/RC*YS
      WRITE (6,11) "Moon",MM/MS,MX/RC,MVY/RC*YS
   11 FORMAT (A6,3F18.14)
      WRITE (6,*)
      WRITE (6,*) 4*PI**2,"4Pi^2: G in AU/year units."
      WRITE (6,*) 2*PI,"2Pi: distance per year for R = 1."
      END
