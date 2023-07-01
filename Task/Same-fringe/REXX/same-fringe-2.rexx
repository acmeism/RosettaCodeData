/* REXX ***************************************************************
* Same Fringe
=           1                A                 A
=          / \              / \               / \
=         /   \            /   \             /   \
=        /     \          /     \           /     \
=       2       3        B       C         B       C
=      / \     /        / \     /         / \     /
=     4   5   6        D   E   F         D   E   F
=    /       / \      /       / \       /       / \
=   7       8   9    G       H   I     G       *   I
=
* 23.08.2012 Walter Pachl derived from
*                            http://rosettacode.org/wiki/Tree_traversal
* Tree A: A B D G E C F H I
* Tree B: A B D G E C F * I
**********************************************************************/
node.=0

Call mktree 'A'
Call mktree 'B'

sideboard.=0

za=root.a; leafa=node.a.za.0name
zb=root.b; leafb=node.b.zb.0name
Do i=1 To 20 Until za=0 & zb=0
  If leafa=leafb Then Do
    Say leafa '=' leafb
    Parse Value get_next(za,'A') with za leafa
    Parse Value get_next(zb,'B') with zb leafb
    End
  Else Do
    Select
      When za=0 Then Say leafb 'exceeds tree A'
      When zb=0 Then Say leafa 'exceeds tree B'
      Otherwise Say 'First difference' leafa '<>' leafb
      End
    Leave
    Exit
    End
  End
exit

get_next: Procedure Expose node. sideboard.
  Parse Arg za,t
  Select
    When node.t.za.0left<>0 Then Do
      If node.t.za.0rite<>0 Then Do
        z=sideboard.t.0+1
        sideboard.t.z=node.t.za.0rite
        sideboard.t.0=z
        End
      za=node.t.za.0left
      End
    When node.t.za.0rite<>0 Then Do
      za=node.t.za.0rite
      End
    Otherwise Do
      z=sideboard.t.0
      za=sideboard.t.z
      z=z-1
      sideboard.t.0=z
      End
    End
  Return za node.t.za.0name

mknode: Procedure Expose node.
/**********************************************************************
* create a new node
**********************************************************************/
  Parse Arg name,t
  z=node.t.0+1
  node.t.z.0name=name
  node.t.z.0father=0
  node.t.z.0left =0
  node.t.z.0rite =0
  node.t.0=z
  Return z                        /* number of the node just created */

attleft: Procedure Expose node.
/**********************************************************************
* make son the left son of father
**********************************************************************/
  Parse Arg son,father,t
  node.t.son.0father=father
  z=node.t.father.0left
  If z<>0 Then Do
    node.t.z.0father=son
    node.t.son.0left=z
    End
  node.t.father.0left=son
  Return

attrite: Procedure Expose node.
/**********************************************************************
* make son the right son of father
**********************************************************************/
  Parse Arg son,father,t
  node.t.son.0father=father
  z=node.t.father.0rite
  If z<>0 Then Do
    node.t.z.0father=son
    node.t.son.0rite=z
    End
  node.t.father.0rite=son
  le=node.t.father.0left
  If le>0 Then
    node.t.le.0brother=node.t.father.0rite
  Return

mktree: Procedure Expose node. root.
/**********************************************************************
* build the tree according to the task
**********************************************************************/
  Parse Arg t
  If t='A' Then Do
    a=mknode('A',t); root.t=a
    b=mknode('B',t); Call attleft b,a,t
    c=mknode('C',t); Call attrite c,a,t
    d=mknode('D',t); Call attleft d,b,t
    e=mknode('E',t); Call attrite e,b,t
    f=mknode('F',t); Call attleft f,c,t
    g=mknode('G',t); Call attleft g,d,t
    h=mknode('H',t); Call attleft h,f,t
    i=mknode('I',t); Call attrite i,f,t
    End
  Else Do
    a=mknode('A',t); root.t=a
    b=mknode('B',t); Call attleft b,a,t
    c=mknode('C',t); Call attrite c,a,t
    d=mknode('D',t); Call attleft d,b,t
    e=mknode('E',t); Call attrite e,b,t
    f=mknode('F',t); Call attleft f,c,t
    g=mknode('G',t); Call attleft g,d,t
    h=mknode('*',t); Call attleft h,f,t
    i=mknode('I',t); Call attrite i,f,t
    End
  Return
