/* REXX ---------------------------------------------------------------
* 12.02.2014 Walter Pachl
*--------------------------------------------------------------------*/
  Parse Arg topn .                 /* get number for top N salaries. */
  Select
    When topn='' Then              /* no argument                    */
      topn=1                       /* assume only  1.                */
    When topn='?' Then             /* user wants help                */
      Call help
    When datatype(topn)<>'NUM' Then /* Argument is not a number      */
      Call exit 'Invalid argument ('topn'). Must be a number!'
    Otherwise
      Nop
    End
Parse Value '0 0 0 0' with en dn esal. de. deptl
         /*employee name,  ID, salary, dept.*/
Call read "Tyler Bennett,E10297,32000,D101"
Call read "George Woltman,E00127,53500,D101"
Call read "John Rappl,E21437,47000,D050"
Call read "Adam Smith,E63535,18000,D202"
Call read "Claire Buckman,E39876,27800,D202"
Call read "David McClellan,E04242,41500,D101"
Call read "Rich Holcomb,E01234,49500,D202"
Call read "Nathan Adams,E41298,21900,D050"
Call read "Richard Potter,E43128,15900,D101"
Call read "David Motsinger,E27002,19250,D202"
Call read "Tim Sampair,E03033,27000,D101"
Call read "Kim Arlich,E10001,57000,D190"
Call read "Timothy Grove,E16398,29900,D190"
Say en 'employees,' dn "departments:" deptl
Do e=1 To en
  d=dept.e
  Do di=1 To de.d
    If esal.d.di<sal.e Then
      Leave
    End
  Do j=de.d To di By -1
    j1=j+1
    esal.d.j1=esal.d.j
    enum.d.j1=enum.d.j
    End
  esal.d.di=sal.e
  enum.d.di=id.e
  de.d=de.d+1
  End
/*---------------------------------------------------------------------
* Output
*--------------------------------------------------------------------*/
Say ' '
Say 'Showing top' topn 'salaries in each department.'
Say ' '
Do While deptl<>''
  Parse Var deptl d deptl
  Do i=1 To min(topn,de.d)
    id=enum.d.i
    Say 'department:  'd'  $'esal.d.i id name.id
    End
  Say ' '
  End
Exit

read:
en=en+1
Parse Arg name ',' id.en "," sal.en ',' dept.en
If wordpos(dept.en,deptl)=0 Then Do
  dn=dn+1
  deptl=deptl dept.en
  End
z=id.en
name.z=name
Return

exit: Say arg(1)
help: Say 'Syntax: rexx topsal [topn]'
      Exit
