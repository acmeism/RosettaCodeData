/* REXX ***************************************************************
* Same Fringe
*           1                A                 A
*          / \              / \               / \
*         /   \            /   \             /   \
*        /     \          /     \           /     \
*       2       3        B       C         B       C
*      / \     /        / \     /         / \     /
*     4   5   6        D   E   F         D   E   F
*    /       / \      /       / \       /       / \
*   7       8   9    G       H   I     G       *   I
*
* 23.08.2012 Walter Pachl derived from
*                            http://rosettacode.org/wiki/Tree_traversal
* Tree A: A B D G E C F H I
* Tree B: A B D G E C F * I
**********************************************************************/
debug=0
node.=0
lvl=0

Call mktree 'A'
Call mktree 'B'

done.=0
za=root.a; leafa=node.a.za.0name
zb=root.a; leafb=node.b.zb.0name
done.a.za=1
done.b.zb=1
Do i=1 To 12
  if leafa=leafb Then Do
    If leafa=0 Then Do
      Say 'Fringes are equal'
      Leave
      End
    Say leafa '=' leafb
    Do j=1 To 12 Until done.a.za=0
      za=go_next(za,'A'); leafa=node.a.za.0name
      End
    done.a.za=1
    Do j=1 To 12 Until done.b.zb=0
      zb=go_next(zb,'B'); leafb=node.b.zb.0name
      End
    done.b.zb=1
    End
  Else Do
    Select
      When leafa=0 Then
        Say leafb 'exceeds leaves in tree A'
      When leafb=0 Then
        Say leafa 'exceeds leaves in tree B'
      Otherwise
        Say 'First difference' leafa '<>' leafb
      End
    Leave
    End
  End
Exit


note:
/**********************************************************************
* add the node to the preorder list unless it's already there
* add the node to the level list
**********************************************************************/
  Parse Arg z,t
  If z<>0 &,                           /* it's a node                */
     done.z=0 Then Do                  /* not yet done               */
    wl.t=wl.t z                        /* add it to the preorder list*/
    ll.lvl=ll.lvl z                    /* add it to the level list   */
    done.z=1                           /* remember it's done         */
    leafl=leafl node.t.z.0name
    End
  Return

go_next: Procedure Expose node. lvl
/**********************************************************************
* find the next node to visit in the treewalk
**********************************************************************/
  next=0
  Parse arg z,t
  If node.t.z.0left<>0 Then Do         /* there is a left son        */
    If node.t.z.0left.done=0 Then Do   /* we have not visited it     */
      next=node.t.z.0left              /* so we go there             */
      node.t.z.0left.done=1            /* note we were here          */
      lvl=lvl+1                        /* increase the level         */
      End
    End
  If next=0 Then Do                    /* not moved yet              */
    If node.t.z.0rite<>0 Then Do       /* there is a right son       */
      If node.t.z.0rite.done=0 Then Do /* we have not visited it     */
        next=node.t.z.0rite            /* so we go there             */
        node.t.z.0rite.done=1          /* note we were here          */
        lvl=lvl+1                      /* increase the level         */
        End
      End
    End
  If next=0 Then Do                    /* not moved yet              */
    next=node.t.z.0father              /* go to the father           */
    lvl=lvl-1                          /* decrease the level         */
    End
  Return next                          /* that's the next node       */
                                       /* or zero if we are done     */

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
