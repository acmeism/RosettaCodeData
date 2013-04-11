/*REXX program to extract student names from an  XML string(s).         */
g.=
g.1='<Students>                                                             '
g.2='  <Student Name="April" Gender="F" DateOfBirth="1989-01-02" />         '
g.3='  <Student Name="Bob" Gender="M"  DateOfBirth="1990-03-04" />          '
g.4='  <Student Name="Chad" Gender="M"  DateOfBirth="1991-05-06" />         '
g.5='  <Student Name="Dave" Gender="M"  DateOfBirth="1992-07-08">           '
g.6='    <Pet Type="dog" Name="Rover" />                                    '
g.7='  </Student>                                                           '
g.8='  <Student DateOfBirth="1993-09-10" Gender="F" Name="&#x00C9;mily" />  '
g.9='</Students>                                                            '

  do j=1 while g.j\==''
  g.j=space(g.j)
  parse var g.j 'Name="' studname '"'
  if studname\==''  then say studname
  end   /*j*/
                                       /*stick a fork in it, we're done.*/
