/* REXX ***************************************************************
* 10.05.2014 Walter Pachl using the tree and the output format of C
**********************************************************************/
Call mktree
Say node.1.0name
Call tt 1,''
Exit

tt: Procedure Expose node.
/**********************************************************************
* show a subtree (recursively)
**********************************************************************/
 Parse Arg k,st
 Do i=1 To node.k.0
   If i=node.k.0 Then
     s='`--'
   Else
     s='|--'
   c=node.k.i
   If st<>'' Then
     st=left(st,length(st)-2)'  '
   st=repl(st,'  ','` ')
   Say st||s||node.c.0name
   Call tt c,st||s
   End
 Return
Exit

mktree: Procedure Expose node. root
/**********************************************************************
* build the tree according to the task
**********************************************************************/
  node.=0
  r=mknode('R');
  a=mknode('A'); Call attchild a,r
  b=mknode('B'); Call attchild b,a
  c=mknode('C'); Call attchild c,a
  d=mknode('D'); Call attchild d,b
  e=mknode('E'); Call attchild e,b
  f=mknode('F'); Call attchild f,b
  g=mknode('G'); Call attchild g,b
  h=mknode('H'); Call attchild h,d
  i=mknode('I'); Call attchild i,h
  j=mknode('J'); Call attchild j,i
  k=mknode('K'); Call attchild k,j
  l=mknode('L'); Call attchild l,j
  m=mknode('M'); Call attchild m,e
  n=mknode('N'); Call attchild n,e
  Return

mknode: Procedure Expose node.
/**********************************************************************
* create a new node
**********************************************************************/
  Parse Arg name
  z=node.0+1
  node.z.0name=name
  node.0=z
  Return z                        /* number of the node just created */

attchild: Procedure Expose node.
/**********************************************************************
* make a the next child of father
**********************************************************************/
  Parse Arg a,father
  node.a.0father=father
  z=node.father.0+1
  node.father.z=a
  node.father.0=z
  node.a.0level=node.father.0level+1
  Return
