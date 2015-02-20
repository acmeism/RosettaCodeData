/* REXX ***************************************************************
* Tree traversal
=           1
=          / \
=         /   \
=        /     \
=       2       3
=      / \     /
=     4   5   6
=    /       / \
=   7       8   9
=
= The correct output should look like this:
=  preorder:    1 2 4 7 5 3 6 8 9
=  level-order: 1 2 3 4 5 6 7 8 9
=  postorder:   7 4 5 2 8 9 6 3 1
=  inorder:     7 4 2 5 1 8 6 9 3

* 17.06.2012 Walter Pachl not thoroughly tested
**********************************************************************/
debug=0
wl_soll=1 2 4 7 5 3 6 8 9
il_soll=7 4 2 5 1 8 6 9 3
pl_soll=7 4 5 2 8 9 6 3 1
ll_soll=1 2 3 4 5 6 7 8 9

Call mktree
wl.=''; wl='' /* preorder    */
ll.=''; ll='' /* level-order */
        il='' /* inorder     */
        pl='' /* postorder   */

/**********************************************************************
* First walk the tree and construct preorder and level-order lists
**********************************************************************/
done.=0
lvl=1
z=root
Call note z
Do Until z=0
  z=go_next(z)
  Call note z
  End
Call show 'preorder:   ',wl,wl_soll
Do lvl=1 To 4
  ll=ll ll.lvl
  End
Call show 'level-order:',ll,ll_soll

/**********************************************************************
* Next construct postorder list
**********************************************************************/
done.=0
ridone.=0
z=lbot(root)
Call notep z
Do Until z=0
  br=brother(z)
  If br>0 &,
     done.br=0 Then Do
    ridone.br=1
    z=lbot(br)
    Call notep z
    End
  Else
  z=father(z)
  Call notep z
  End
Call show 'postorder:  ',pl,pl_soll

/**********************************************************************
* Finally construct inorder list
**********************************************************************/
done.=0
ridone.=0
z=lbot(root)
Call notei z
Do Until z=0
  z=father(z)
  Call notei z
  ri=node.z.0rite
  If ridone.z=0 Then Do
    ridone.z=1
    If ri>0 Then Do
      z=lbot(ri)
      Call notei z
      End
    End
  End

/**********************************************************************
* And now show the results and check them for correctness
**********************************************************************/
Call show 'inorder:    ',il,il_soll

Exit

show: Parse Arg Which,have,soll
/**********************************************************************
* Show our result and show it it's correct
**********************************************************************/
have=space(have)
If have=soll Then
  tag=''
Else
  tag='*wrong*'
Say which have tag
If tag<>'' Then
  Say '------------>'soll 'is the expected result'
Return

brother: Procedure Expose node.
/**********************************************************************
* Return the right node of this node's father or 0
**********************************************************************/
  Parse arg no
  nof=node.no.0father
  brot1=node.nof.0rite
  Return brot1

notei: Procedure Expose debug il done.
/**********************************************************************
* append the given node to il
**********************************************************************/
  Parse Arg nd
  If nd<>0 &,
     done.nd=0 Then
    il=il nd
  If debug Then
    Say 'notei' nd
  done.nd=1
  Return

notep: Procedure Expose debug pl done.
/**********************************************************************
* append the given node to pl
**********************************************************************/
  Parse Arg nd
  If nd<>0 &,
     done.nd=0 Then Do
    pl=pl nd
    If debug Then
      Say 'notep' nd
    End
  done.nd=1
  Return

father: Procedure Expose node.
/**********************************************************************
* Return the father of the argument
* or 0 if the root is given as argument
**********************************************************************/
  Parse Arg nd
  Return node.nd.0father

lbot: Procedure Expose node.
/**********************************************************************
* From node z: Walk down on the left side until you reach the bottom
* and return the bottom node
* If z has no left son (at the bottom of the tree) returm itself
**********************************************************************/
  Parse Arg z
  Do i=1 To 100
    If node.z.0left<>0 Then
      z=node.z.0left
    Else
      Leave
    End
  Return z

note:
/**********************************************************************
* add the node to the preorder list unless it's already there
* add the node to the level list
**********************************************************************/
  If z<>0 &,                           /* it's a node                */
     done.z=0 Then Do                  /* not yet done               */
    wl=wl z                            /* add it to the preorder list*/
    ll.lvl=ll.lvl z                    /* add it to the level list   */
    done.z=1                           /* remember it's done         */
    End
  Return

go_next: Procedure Expose node. lvl
/**********************************************************************
* find the next node to visit in the treewalk
**********************************************************************/
  next=0
  Parse arg z
  If node.z.0left<>0 Then Do           /* there is a left son        */
    If node.z.0left.done=0 Then Do     /* we have not visited it     */
      next=node.z.0left                /* so we go there             */
      node.z.0left.done=1              /* note we were here          */
      lvl=lvl+1                        /* increase the level         */
      End
    End
  If next=0 Then Do                    /* not moved yet              */
    If node.z.0rite<>0 Then Do         /* there is a right son       */
      If node.z.0rite.done=0 Then Do   /* we have not visited it     */
        next=node.z.0rite              /* so we go there             */
        node.z.0rite.done=1            /* note we were here          */
        lvl=lvl+1                      /* increase the level         */
        End
      End
    End
  If next=0 Then Do                    /* not moved yet              */
    next=node.z.0father                /* go to the father           */
    lvl=lvl-1                          /* decrease the level         */
    End
  Return next                          /* that's the next node       */
                                       /* or zero if we are done     */

mknode: Procedure Expose node.
/**********************************************************************
* create a new node
**********************************************************************/
  Parse Arg name
  z=node.0+1
  node.z.0name=name
  node.z.0father=0
  node.z.0left  =0
  node.z.0rite  =0
  node.0=z
  Return z                        /* number of the node just created */

attleft: Procedure Expose node.
/**********************************************************************
* make son the left son of father
**********************************************************************/
  Parse Arg son,father
  node.son.0father=father
  z=node.father.0left
  If z<>0 Then Do
    node.z.0father=son
    node.son.0left=z
    End
  node.father.0left=son
  Return

attrite: Procedure Expose node.
/**********************************************************************
* make son the right son of father
**********************************************************************/
  Parse Arg son,father
  node.son.0father=father
  z=node.father.0rite
  If z<>0 Then Do
    node.z.0father=son
    node.son.0rite=z
    End
  node.father.0rite=son
  le=node.father.0left
  If le>0 Then
    node.le.0brother=node.father.0rite
  Return

mktree: Procedure Expose node. root
/**********************************************************************
* build the tree according to the task
**********************************************************************/
  node.=0
  a=mknode('A'); root=a
  b=mknode('B'); Call attleft b,a
  c=mknode('C'); Call attrite c,a
  d=mknode('D'); Call attleft d,b
  e=mknode('E'); Call attrite e,b
  f=mknode('F'); Call attleft f,c
  g=mknode('G'); Call attleft g,d
  h=mknode('H'); Call attleft h,f
  i=mknode('I'); Call attrite i,f
  Call show_tree 1
  Return

show_tree: Procedure Expose node.
/**********************************************************************
* Show the tree
*         f
*     l1   1  r1
*   l   r   l   r
*  l r l r l r l r
* 12345678901234567890
**********************************************************************/
  Parse Arg f
  l.=''
                          l.1=overlay(f   ,l.1, 9)

  l1=node.f.0left        ;l.2=overlay(l1  ,l.2, 5)
/*b1=node.f.0brother     ;l.2=overlay(b1  ,l.2, 9) */
  r1=node.f.0rite        ;l.2=overlay(r1  ,l.2,13)

  l1g=node.l1.0left      ;l.3=overlay(l1g ,l.3, 3)
/*b1g=node.l1.0brother   ;l.3=overlay(b1g ,l.3, 5) */
  r1g=node.l1.0rite      ;l.3=overlay(r1g ,l.3, 7)

  l2g=node.r1.0left      ;l.3=overlay(l2g ,l.3,11)
/*b2g=node.r1.0brother   ;l.3=overlay(b2g ,l.3,13) */
  r2g=node.r1.0rite      ;l.3=overlay(r2g ,l.3,15)

  l1ls=node.l1g.0left    ;l.4=overlay(l1ls,l.4, 2)
/*b1ls=node.l1g.0brother ;l.4=overlay(b1ls,l.4, 3) */
  r1ls=node.l1g.0rite    ;l.4=overlay(r1ls,l.4, 4)

  l1rs=node.r1g.0left    ;l.4=overlay(l1rs,l.4, 6)
/*b1rs=node.r1g.0brother ;l.4=overlay(b1rs,l.4, 7) */
  r1rs=node.r1g.0rite    ;l.4=overlay(r1rs,l.4, 8)

  l2ls=node.l2g.0left    ;l.4=overlay(l2ls,l.4,10)
/*b2ls=node.l2g.0brother ;l.4=overlay(b2ls,l.4,11) */
  r2ls=node.l2g.0rite    ;l.4=overlay(r2ls,l.4,12)

  l2rs=node.r2g.0left    ;l.4=overlay(l2rs,l.4,14)
/*b2rs=node.r2g.0brother ;l.4=overlay(b2rs,l.4,15) */
  r2rs=node.r2g.0rite    ;l.4=overlay(r2rs,l.4,16)
  Do i=1 To 4
    Say translate(l.i,' ','0')
    Say ''
    End
  Return
