/*REXX pgm examines the leaves of 2 binary trees (as shown below), and finds inequities.*/
_= left('', 28);    say _   "        A                                       A     "
                    say _   "       / \    ◄════1st tree                    / \    "
                    say _   "      /   \                                   /   \   "
                    say _   "     /     \                                 /     \  "
                    say _   "    B       C                               B       C "
                    say _   "   / \     /              2nd tree════►    / \     /  "
                    say _   "  D   E   F                               D   E   F   "
                    say _   " /       / \                             /       / \  "
                    say _   "G       H   I                           G       δ   I " ; say
#= 0;     done.= 0;   @.= 0                      /*initialize:  # (leaves), DONE., nodes*/
    do t#=1  for 2;   call make_tree  t#;   end  /*define tree numbers  1  and  2.      */
z1= root.1;      L1= @.1.z1;    done.1.z1= 1     /*L1:    is a leaf on tree number  1.  */
z2= z1;          L2= @.2.z2;    done.2.z2= 1     /*L2:     " "   "   "   "     "    2.  */
   do #%2                                        /*loop for the number of (tree) leaves.*/
   if L1==L2  then do; if L1==0  then do; say  'The trees are equal.';    leave;  end
                       say 'The '     L1      " leaf is identical in both trees."
                         do until \done.1.z1;  z1=nxt(z1,1);  L1=@.1.z1; end;  done.1.z1=1
                         do until \done.2.z2;  z2=nxt(z2,2);  L2=@.2.z2; end;  done.2.z2=1
                       iterate
                   end
   if L1==0   then say L2  'exceeds leaves in 1st tree'
   if L2==0   then say L1  'exceeds leaves in 2nd tree'
                   say     'A difference is: '    L1    "¬="    L2;        leave
   end   /*#%2*/
exit 0
/*──────────────────────────────────────────────────────────────────────────────────────*/
nxt: procedure expose @.;   arg q,t;        next= .          /*find next node in tree.  */
     if @.t.q._Lson\==0  &  @.t.q._Lson.vis==0          then /*L branch & not visited ? */
        do;  next=@.t.q._Lson;  @.t.q._Lson.vis=1;  end      /* ──►next node; Lside done*/
     if next==. & @.t.q._Rson\==0 & @.t.q._Rson.vis==0  then /*R branch & not visited ? */
        do;  next=@.t.q._Rson;  @.t.q._Rson.vis=1;  end      /* ──►next node; Rside done*/
     if next==.  then next= @.t.q._dad;     return next      /*father node; zero if done*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
make_node: parse arg name,t;    #= # + 1;    q= @.t.0 + 1 /*make new node/branch on tree*/
           @.t.q= name;    @.t.q._Lson= 0;   @.t.0= q
           @.t.q._dad= 0;  @.t.q._Rson= 0;     return q   /*number of node just created.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
make_tree: procedure expose @. root. #; parse arg tree    /*construct a couple of trees.*/
           a= make_node('A', tree);     root.tree= a;           hhh= substr('Hδ', tree, 1)
           b= make_node('B', tree);     call son 'L', b, a, tree
           c= make_node('C', tree);     call son 'R', c, a, tree
           d= make_node('D', tree);     call son 'L', d, b, tree
           e= make_node('E', tree);     call son 'R', e, b, tree
           f= make_node('F', tree);     call son 'L', f, c, tree
           g= make_node('G', tree);     call son 'L', g, d, tree
           h= make_node(hhh, tree);     call son 'L', h, f, tree  /*quacks like a duck? */
           i= make_node('I', tree);     call son 'R', i, f, tree;          return
/*──────────────────────────────────────────────────────────────────────────────────────*/
son: procedure expose @.;  parse arg ?,son,dad,t;   LR= '_'?"SON";   @.t.son._dad= dad
     q= @.t.dad.LR;          if q\==0  then do;   @.t.q._dad= son;   @.t.son.LR= q;    end
     @.t.dad.LR= son;      return
