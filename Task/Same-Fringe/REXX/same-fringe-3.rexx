/*REXX pgm examines leaves of two binary trees.   Tree used is as above.*/
_=left('',28);  say _ '        A                                   A     '
                say _ '       / \    ◄────1st tree                / \    '
                say _ '      /   \                               /   \   '
                say _ '     /     \                             /     \  '
                say _ '    B       C                           B       C '
                say _ '   / \     /          2nd tree────►    / \     /  '
                say _ '  D   E   F                           D   E   F   '
                say _ ' /       / \                         /       / \  '
                say _ 'G       H   I                       G       δ   I '
say;  #=0                              /*#: # of leaves.                */
parse var #  done.  1  node.           /*set all these variables to zero*/
call make_tree  '1st'
call make_tree  '2nd'
z1=root.1st;  L1=node.1st.z1;  done.1st.z1=1  /*L1 is a leaf on 1st tree*/
z2=z1;        L2=node.2nd.z2;  done.2nd.z2=1  /*L2  " "   "   " 2nd   " */

  do #%2                               /*loop for the number of leaves. */
  if L1==L2 then do
                 if L1==0  then call sayX  'The trees are equal.'
                 say  '    The '  L1  " leaf is identical in both trees."
                    do  until  \done.1st.z1
                    z1=go_next(z1,'1st');   L1=node.1st.z1
                    end
                 done.1st.z1=1
                    do  until  \done.2nd.z2
                    z2=go_next(z2,'2nd');   L2=node.2nd.z2
                    end
                 done.2nd.z2=1
                 end
            else select
                 when L1==0 then call sayX L2 'exceeds leaves in 1st tree'
                 when L2==0 then call sayX L1 'exceeds leaves in 2nd tree'
                 otherwise       call sayX 'A difference is: ' L1 '¬=' L2
                 end   /*select*/
  end   /*#%2*/
exit
/*──────────────────────────────────GO_NEXT subroutine──────────────────*/
go_next: procedure expose node.;   arg q,t             /*find next node.*/
next=0
if node.t.q._Lson\==0 then             /*is there a left branch in tree?*/
  if node.t.q._Lson.done==0 then do    /*has this node been visited yet?*/
                                 next=node.t.q._Lson   /*──► next node. */
                                 node.t.q._Lson.done=1 /*mark Lson done.*/
                                 end
if next==0 then
  if node.t.q._Rson\==0 then           /*is there a right tree branch ? */
    if node.t.q._Rson.done==0 then do  /*has this node been visited yet?*/
                                   next=node.t.q._Rson   /*──► next node*/
                                   node.t.q._Rson.done=1 /*mark Rson don*/
                                   end
if next==0 then next=node.t.q._dad     /*process the  father  node.     */
return next                            /*the next node  (or 0, if done).*/
/*──────────────────────────────────MAKE_NODE subroutine────────────────*/
make_node: parse arg name,t;   # = #+1 /*make a new node/branch on tree.*/
q = node.t.0 + 1;         node.t.q = name;          node.t.q._dad = 0
node.t.q._Lson = 0;       node.t.q._Rson = 0;       node.t.0 = q
return q                               /*number of the node just created*/
/*──────────────────────────────────MAKE_TREE subroutine────────────────*/
make_tree: procedure expose node. root. #;  arg tree     /*build a tree.*/
                     hhh='δ'           /*the odd duck in the whole tree.*/
if tree=='1ST'  then hhh='H'
                             a=make_node('A',tree);            root.tree=a
                             b=make_node('B',tree);   call sonL b,a,tree
                             c=make_node('C',tree);   call sonR c,a,tree
                             d=make_node('D',tree);   call sonL d,b,tree
                             e=make_node('E',tree);   call sonR e,b,tree
                             f=make_node('F',tree);   call sonL f,c,tree
                             g=make_node('G',tree);   call sonL g,d,tree
                /*quack?*/   h=make_node(hhh,tree);   call sonL h,f,tree
                             i=make_node('I',tree);   call sonR i,f,tree
return
/*──────────────────────────────────SAYX subroutine─────────────────────*/
sayX: say;      say arg(1);  say;        exit         /*tell msg & exit.*/
/*──────────────────────────────────SONL subroutine─────────────────────*/
sonL: procedure expose node.; parse arg son,dad,t     /*build left son. */
                    node.t.son._dad=dad;      q=node.t.dad._Lson
if q\==0  then do;  node.t.q._dad=son;        node.t.son._Lson=q;   end
node.t.dad._Lson=son
return
/*──────────────────────────────────SONR subroutine─────────────────────*/
sonR: procedure expose node.; parse arg son,dad,t     /*build right son.*/
                    node.t.son._dad=dad;       q=node.t.dad._Rson
if q\==0  then do;  node.t.q._dad=son;         node.t.son._Rson=q;     end
node.t.dad._Rson=son
if node.t.dad._Lson>0  then node.t.le._brother=node.t.dad._Rson
return
