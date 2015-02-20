/*REXX program examines the leaves of two binary trees (as shown below).*/
_=left('',28);  say _ "        A                                   A     "
                say _ "       / \    ◄════1st tree                / \    "
                say _ "      /   \                               /   \   "
                say _ "     /     \                             /     \  "
                say _ "    B       C                           B       C "
                say _ "   / \     /          2nd tree════►    / \     /  "
                say _ "  D   E   F                           D   E   F   "
                say _ " /       / \                         /       / \  "
                say _ "G       H   I                       G       δ   I "
say
#=0;   done.=0;   node.=0              /*initialize # leaves,DONE.,NODE.*/
call make_tree  1                      /*define tree number 1 (1st tree)*/
call make_tree  2                      /*   "     "     "   2 (2nd   " )*/
z1=root.1;  L1=node.1.z1;  done.1.z1=1 /*L1 is a leaf on tree number 1. */
z2=z1;      L2=node.2.z2;  done.2.z2=1 /*L2  " "   "   "   "     "   2. */

  do # % 2                             /*loop for the number of leaves. */
  if L1==L2 then do
                 if L1==0  then call sayX   'The trees are equal.'
                 say  '    The '  L1   " leaf is identical in both trees."
                                do  until  \done.1.z1
                                z1=go_next(z1,1);          L1=node.1.z1
                                end
                 done.1.z1=1
                                do  until  \done.2.z2
                                z2=go_next(z2,2);          L2=node.2.z2
                                end
                 done.2.z2=1
                 end
            else select
                 when L1==0 then call sayX L2 'exceeds leaves in 1st tree'
                 when L2==0 then call sayX L1 'exceeds leaves in 2nd tree'
                 otherwise       call sayX 'A difference is: '  L1 '¬=' L2
                 end   /*select*/
  end   /*# % 2*/
exit
/*──────────────────────────────────GO_NEXT subroutine──────────────────*/
go_next: procedure expose node.;  arg q,t              /*find next node.*/
next=.
if node.t.q._Lson\==0  &,              /*is there a left branch in tree?*/
   node.t.q._Lson.vis==0  then do      /*has this node been visited yet?*/
                               next=node.t.q._Lson     /*──► next node. */
                               node.t.q._Lson.vis=1    /*leftside done. */
                               end
if next==. &,
   node.t.q._Rson\==0  &,              /*is there a right tree branch ? */
   node.t.q._Rson.vis==0  then do      /*has this node been VISited yet?*/
                               next=node.t.q._Rson     /*──► next node. */
                               node.t.q._Rson.vis=1    /*rightside done.*/
                               end
if next==.  then next=node.t.q._dad    /*process the  father  node.     */
return next                            /*the next node  (or 0, if done).*/
/*──────────────────────────────────MAKE_NODE subroutine────────────────*/
make_node: parse arg name,t;  # = #+1  /*make a new node/branch on tree.*/
q = node.t.0 + 1   ;      node.t.q       = name  ;       node.t.q._dad = 0
node.t.q._Lson = 0 ;      node.t.q._Rson = 0     ;       node.t.0      = q
return q                               /*number of the node just created*/
/*──────────────────────────────────MAKE_TREE subroutine────────────────*/
make_tree: procedure expose node. root. #; parse arg tree  /*build trees*/
if tree==1  then hhh='H'               /*        [↓] must be a wood duck*/
            else hhh='δ'               /*the odd duck in the whole tree.*/
                          a=make_node('A', tree);   root.tree=a
                          b=make_node('B', tree);   call son 'L', b,a,tree
                          c=make_node('C', tree);   call son 'R', c,a,tree
                          d=make_node('D', tree);   call son 'L', d,b,tree
                          e=make_node('E', tree);   call son 'R', e,b,tree
                          f=make_node('F', tree);   call son 'L', f,c,tree
                          g=make_node('G', tree);   call son 'L', g,d,tree
/*quacks like a duck?*/   h=make_node(hhh, tree);   call son 'L', h,f,tree
                          i=make_node('I', tree);   call son 'R', i,f,tree
return
/*──────────────────────────────────SAYX subroutine─────────────────────*/
sayX: say;      say arg(1);   say;       exit       /*tell msg and exit.*/
/*──────────────────────────────────SON subroutine──────────────────────*/
son: procedure expose node.;  parse arg ?,son,dad,t;       LR = '_'?"SON"
node.t.son._dad=dad;      q=node.t.dad.LR     /*define which son  [↑]   */
if q\==0  then do;  node.t.q._dad=son;  node.t.son.LR=q;  end
node.t.dad.LR=son
if ?=='R'  &  node.t.dad.LR>0  then node.t.le._brother=node.t.dad.LR
return
