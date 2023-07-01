BEGIN
COMMENT
   Algol 68 Genie checks for integer overflow whereas the reference
   language leaves the result undefined so for portability we need to
   see how wide a variable must be to hold the maximum possible value
   before range reduction. This occurs in the BSD RNG when
   rseed=2147483647 and is therefore 2147483647 * 1103515245 + 12345 =
   2369780942852710860, which itself is 19 decimal digits.  Use
   evironmental queries to determine the width needed.
COMMENT
   MODE RANDINT = UNION (INT, LONG INT, LONG LONG INT);
   RANDINT rseed := (int width > 18 | 0 |:
		     long int width > 18 |
		     LONG 0 | LONG LONG 0);
   PROC srand = (INT x) VOID :
   (rseed | (INT): rseed := x,
    (LONG INT): rseed := LENG x | rseed := LENG LENG x);
   PROC bsd rand = INT :
   BEGIN
      CASE rseed IN
      (INT ri):
      BEGIN
	 INT a = 1103515245, c = 12345, m1 = 2^16, m2 = 2^15;
COMMENT
   That curious declaration is because 2^31 might overflow during
   compilation but the MODE declaration for RANDINT guarantees that it
   will not overflow at run-time.  We assume that an INT is at least
   32 bits wide, otherwise a similar workaround would be needed for
   the declaration of a.
COMMENT
	 INT result = (ri * a + c) MOD (m1 * m2); rseed := result;
	 result
      END,
      (LONG INT rli):
      BEGIN
	 LONG INT a = LONG 1103515245, c = LONG 12345, m = LONG 2^31;
	 LONG INT result = (rli * a + c) MOD m; rseed := result;
	 SHORTEN result
      END,
      (LONG LONG INT rlli) :
      BEGIN
	 LONG LONG INT a = LONG LONG 1103515245,
	 c = LONG LONG 12345, m = LONG LONG 2^31;
	 LONG LONG INT result = (rlli * a + c) MOD  m; rseed := result;
	 SHORTEN SHORTEN result
      END
      ESAC
   END;
   PROC ms rand = INT :
   BEGIN
      CASE rseed IN
      (INT ri):
      BEGIN
	 INT a = 214013, c = 2531011, m1 = 2^15, m2 = 2^16;
	 INT result = (ri * a + c) MOD (m1 * m2); rseed := result;
	 result % m2
      END,
      (LONG INT rli):
      BEGIN
	 LONG INT a = LONG 214013, c = LONG 2531011, m = LONG 2^31, m2 = LONG 2^16;
	 LONG INT result = (rli * a + c) MOD m; rseed := result;
	 SHORTEN (result % m2)
      END,
      (LONG LONG INT rlli) :
      BEGIN
	 LONG LONG INT a = LONG LONG 214013,
	 c = LONG LONG 2531011, m = LONG LONG 2^31, m2 = LONG LONG 2^16;
	 LONG LONG INT result = (rlli * a + c) MOD m; rseed := result;
	 SHORTEN SHORTEN (result % m2)
      END
      ESAC
   END;
   srand (0);
   TO 10 DO printf (($g(0)l$, bsd rand)) OD;
   print (newline);
   srand (0);
   TO 10 DO printf (($g(0)l$, ms rand)) OD;
   srand (0)
END
