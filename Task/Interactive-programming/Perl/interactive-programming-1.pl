$ perl -de1

Loading DB routines from perl5db.pl version 1.3
Editor support available.

Enter h or `h h' for help, or `man perldebug' for more help.

main::(-e:1):   1
  DB<1> sub f {my ($s1, $s2, $sep) = @_; $s1 . $sep . $sep . $s2}

  DB<2> p f('Rosetta', 'Code', ':')
Rosetta::Code
  DB<3> q
