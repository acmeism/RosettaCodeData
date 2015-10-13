BEGIN
   MODE PASSWD = STRUCT (STRING name, passwd, INT uid, gid, STRING gecos, dir, shell);
   PROC getpwnam = (STRING name) PASSWD :
   BEGIN
      FILE c source;
      create (c source, stand out channel);
      putf (c source, ($gl$,
"#include <sys/types.h>",
"#include <pwd.h>",
"#include <stdio.h>",
"main ()",
"{",
"  char name[256];",
"  scanf (""%s"", name);",
"  struct passwd *pass = getpwnam (name);",
"  if (pass == (struct passwd *) NULL) {",
"    putchar ('\n');",
"  } else {",
"    printf (""%s\n"", pass->pw_name);",
"    printf (""%s\n"", pass->pw_passwd);",
"    printf (""%d\n"", pass->pw_uid);",
"    printf (""%d\n"", pass->pw_gid);",
"    printf (""%s\n"", pass->pw_gecos);",
"    printf (""%s\n"", pass->pw_dir);",
"    printf (""%s\n"", pass->pw_shell);",
"  }",
"}"
		       ));
      STRING source name = idf (c source);
      STRING bin name = source name + ".bin";
      INT child pid = execve child ("/usr/bin/gcc",
				    ("gcc", "-x", "c", source name, "-o", bin name),
				    "");
      wait pid (child pid);
      PIPE p = execve child pipe (bin name, "Ding dong, a68g calling", "");
      put (write OF p, (name, newline));
      STRING line;
      PASSWD result;
      IF get (read OF p, (line, newline)); line = ""
      THEN
	 result := ("", "", -1, -1, "", "", "")
	 CO
         Return to sender, address unknown.
         No such number, no such zone.
	 CO
      ELSE
	 name OF result := line;
	 get (read OF p, (passwd OF result, newline));
	 get (read OF p, (uid OF result, newline));
	 get (read OF p, (gid OF result, newline));
	 get (read OF p, (gecos OF result, newline));
	 get (read OF p, (dir OF result, newline));
	 get (read OF p, (shell OF result, newline))
      FI;
      close (write OF p);			CO Sundry cleaning up. CO
      close (read OF p);
      execve child ("/bin/rm", ("rm", "-f", source name, bin name), "");
      result
   END;
   PASSWD mr root = getpwnam ("root");
   IF name OF mr root = ""
   THEN
      print (("Oh dear, we seem to be rootless.", newline))
   ELSE
      printf (($2(g,":"), 2(g(0),":"), 2(g,":"), gl$, mr root))
   FI
END
