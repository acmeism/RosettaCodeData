/*REXX pgm examines the leaves of 2 binary trees (as shown below), and finds inequities.*/
_=left('', 28);           say _   "        A                                       A     "
                          say _   "       / \    ◄════1st tree                    / \    "
                          say _   "      /   \                                   /   \   "
                          say _   "     /     \                                 /     \  "
                          say _   "    B       C                               B       C "
                          say _   "   / \     /              2nd tree════►    / \     /  "
                          say _   "  D   E   F                               D   E   F   "
                          say _   " /       / \                             /       / \  "
                          say _   "G       H   I                           G       δ   I "
say
#=0;   done.=0;   @.=0                           /*initialize:   #, leaves, DONE., nodes*/
call make_tree  1                                /*define tree number 1  (the 1st tree).*/
call make_tree  2                                /*   "     "     "   2  (the 2nd   " ).*/
z1=root.1;   L1=@.1.z1;   done.1.z1=1            /*L1:    is a leaf on tree number  1.  */
z2=z1;       L2=@.2.z2;   done.2.z2=1            /*L2:     " "   "   "   "     "    2.  */

  do # % 2                                       /*loop for the number of (tree) leaves.*/
  if L1==L2 then do
                 if L1==0  then call sayX   'The trees are equal.'
                 say  '    The '     L1     " leaf is identical in both trees."
                              do until \done.1.z1;   z1=go_next(z1, 1);   L1=@.1.z1;   end
                 done.1.z1=1
                              do until \done.2.z2;   z2=go_next(z2, 2);   L2=@.2.z2;   end
                 done.2.z2=1
                 end
            else select
                 when L1==0  then call sayX L2  'exceeds leaves in 1st tree'
                 when L2==0  then call sayX L1  'exceeds leaves in 2nd tree'
                 otherwise        call sayX     'A difference is: '    L1   '¬='   L2
                 end   /*select*/
  end   /*# % 2*/
exit
/*──────────────────────────────────────────────────────────────────────────────────────*/
go_next: procedure expose @.;   arg q,t;        next=.    /*find next node in the tree. */
         if @.t.q._Lson\==0  &,                           /*there a left branch in tree?*/
            @.t.q._Lson.vis==0  then do                   /*has this node been visited? */
                                     next= @.t.q._Lson    /*point to the  ──► next node.*/
                                     @.t.q._Lson.vis= 1   /*the  leftside is completed. */
                                     end
         if next==. &,
            @.t.q._Rson\==0  &,                           /*there a right tree branch ? */
            @.t.q._Rson.vis==0  then do                   /*has this node been visited? */
                                     next= @.t.q._Rson    /*──► next node. */
                                     @.t.q._Rson.vis= 1   /*the rightside is completed. */
                                     end
         if next==.             then next= @.t.q._dad     /*process the  father  node.  */
         return next                                      /*next node  (or 0,  if done).*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
make_node: parse arg name,t;    #=# +1;       q= @.t.0 +1 /*make new node/branch on tree*/
           @.t.q= name;    @.t.q._Lson= 0;    @.t.0= q
           @.t.q._dad=0;   @.t.q._Rson= 0;    return q    /*number of node just created.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
make_tree: procedure expose @. root. #; parse arg tree    /*construct a couple of trees.*/
           if tree==1  then hhh='H'                       /*    [↓]  must be a wood duck*/
                       else hhh='δ'                       /*the odd duck in the tree.   */
                                     a=make_node('A', tree);                   root.tree=a
                                     b=make_node('B', tree);    call son 'L', b, a, tree
                                     c=make_node('C', tree);    call son 'R', c, a, tree
                                     d=make_node('D', tree);    call son 'L', d, b, tree
                                     e=make_node('E', tree);    call son 'R', e, b, tree
                                     f=make_node('F', tree);    call son 'L', f, c, tree
                                     g=make_node('G', tree);    call son 'L', g, d, tree
           /*quacks like a duck?*/   h=make_node(hhh, tree);    call son 'L', h, f, tree
                                     i=make_node('I', tree);    call son 'R', i, f, tree
           return
/*──────────────────────────────────────────────────────────────────────────────────────*/
sayX: say;      say arg(1);   say;       exit             /*display a message and exit. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
son:  procedure expose @.;    parse arg ?,son,dad,t;    LR= '_'?"SON"
      @.t.son._dad= dad;      q= @.t.dad.LR               /* [↓]  define which son.     */
      if q\==0   then do;     @.t.q._dad= son;          @.t.son.LR= q;       end
      @.t.dad.LR= son;               return
