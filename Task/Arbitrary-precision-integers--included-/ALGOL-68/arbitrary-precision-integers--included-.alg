BEGIN
COMMENT
   The task specifies

   "Strictly speaking, this should not be solved by fixed-precision
   numeric libraries where the precision has to be manually set to a
   large value; although if this is the only recourse then it may be
   used with a note explaining that the precision must be set manually
   to a large enough value."

   Now one should always speak strictly, especially to animals and
   small children and, strictly speaking, Algol 68 Genie requires that
   a non-default numeric precision for a LONG LONG INT be specified by
   "precision=<integral denotation>" either in a source code PRAGMAT
   or as a command line argument.  However, that specification need
   not be made manually.  This snippet of code outputs an appropriate
   PRAGMAT

   printf (($gg(0)xgl$, "PR precision=",
	    ENTIER (1.0 + log (5) * 4^(3^(2))), "PR"));

   and the technique shown in the "Call a foreign-language function"
   task used to write, compile and run an Algol 68 program in which
   the precision is programmatically determined.

   The default stack size on this machine is also inadequate but twice
   the default is sufficient.  The PRAGMAT below can be machine
   generated with

   printf (($gg(0)xgl$, "PR stack=", 2 * system stack size, "PR"));

COMMENT
   PR precision=183231 PR
   PR stack=16777216 PR
   INT digits = ENTIER (1.0 + log (5) * 4^(3^(2))), exponent = 4^(3^2);
   LONG LONG INT big = LONG LONG 5^exponent;
   printf (($gxg(0)l$, " First 20 digits:", big % LONG LONG 10 ^ (digits - 20)));
   printf (($gxg(0)l$, "  Last 20 digits:", big MOD LONG LONG 10 ^ 20));
   printf (($gxg(0)l$, "Number of digits:", digits))
END
