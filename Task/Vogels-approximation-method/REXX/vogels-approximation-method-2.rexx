/* REXX ***************************************************************
* Solve the Transportation Problem using the Least Cost Method
Default Input
2 3        # of sources / # of demands
25 35      sources
20 30 10   demands
3 5 7      cost matrix
3 2 5
* 20201228 corresponds to NWC above
*          Note: correctness of input is not checked
* 20210102 add optimization
* 20210103 remove debug code
**********************************************************************/
Signal On Halt
Signal On Novalue
Signal On Syntax

Parse Arg fid
If fid='' Then
  fid='input1.txt'
Call init
Do r=1 To rr
  Do c=1 To cc
    matrix.r.c=r c cost.r.c 0
    End
  End
Do Until source_sum=0
  mincost=1e10
  Do r=1 To rr
    If source.r>0 Then Do
      Do c=1 To cc
        If demand.c>0 Then Do
          cost=word(matrix.r.c,3)
          If cost>0 & cost<mincost |,
            source_sum=source.r |,
            demand_sum=demand.c Then Do
            tgt=r c cost
            mincost=cost
            End
          End
        End
      End
    End
  Parse Var tgt tr tc .
  a=min(source.tr,demand.tc)
  matrix.tr.tc=subword(matrix.tr.tc,1,3) word(matrix.tr.tc,4)+a
  source.tr=source.tr-a
  demand.tc=demand.tc-a
  source_sum=source_sum-a
  demand_sum=demand_sum-a

  End
Call show_alloc 'Low Cost Algorithm'
Call steppingstone
Exit

/**********************************************************************
* Subroutines for Low Cost Algorithm
**********************************************************************/

init:
If lines(fid)=0 Then Do
  Say 'Input file not specified or not found. Using default input instead.'
  fid='Default input'
  in.1=sourceline(4)
  Parse Var in.1 numSources .
  Do i=2 To numSources+3
    in.i=sourceline(i+3)
    End
  End
Else Do
  Do i=1 By 1 while lines(fid)>0
    in.i=linein(fid)
    End
  End
Parse Var in.1 numSources numDestinations . 1 rr cc .
source_sum=0
Do i=1 To numSources
  Parse Var in.2 source.i in.2
  ss.i=source.i
  source_sum=source_sum+source.i
  source_in.i=source.i
  End
demand_sum=0
Do i=1 To numDestinations
  Parse Var in.3 demand.i in.3
  dd.i=demand.i
  demand_in.i=demand.i
  demand_sum=demand_sum+demand.i
  End
Do i=1 To numSources
  j=i+3
  l=in.j
  Do j=1 To numDestinations
    Parse Var l cost.i.j l
    End
  End
Do i=1 To numSources
  ol=format(source.i,3)
  Do j=1 To numDestinations
    ol=ol format(cost.i.j,4)
    End
  End
Select
  When source_sum=demand_sum Then Nop  /* balanced */
  When source_sum>demand_sum Then Do   /* unbalanced - add dummy demand */
    Say 'This is an unbalanced case (sources exceed demands). We add a dummy consumer.'
    cc=cc+1
    demand.cc=source_sum-demand_sum
    demand_in.cc=demand.cc
    dd.cc=demand.cc
    Do r=1 To rr
      cost.r.cc=0
      End
    End
  Otherwise /* demand_sum>source_sum */ Do /* unbalanced - add dummy source */
    Say 'This is an unbalanced case (demands exceed sources). We add a dummy source.'
    rr=rr+1
    source.rr=demand_sum-source_sum
    ss.rr=source.rr
    source_in.rr=source.rr
    Do c=1 To cc
      cost.rr.c=0
      End
    End
  End

Say 'Sources / Demands / Cost'
ol='    '
Do c=1 To cc
  ol=ol format(demand.c,3)
  End
Say ol
Do r=1 To rr
  ol=format(source.r,4)
  Do c=1 To cc
    ol=ol format(cost.r.c,3)
    End
  Say ol
  End
Return

show_alloc: Procedure Expose matrix. rr cc demand_in. source_in.
Parse Arg header
If header='' Then
  Return
Say ''
Say header
total=0
ol='    '
Do c=1 to cc
  ol=ol format(demand_in.c,3)
  End
Say ol
as=''
Do r=1 to rr
  ol=format(source_in.r,4)
  a=word(matrix.r.1,4)
  If a=0.0000000001 Then a=0
  If a>0 Then
    ol=ol format(a,3)
  Else
    ol=ol ' - '
  total=total+word(matrix.r.1,4)*word(matrix.r.1,3)
  Do c=2 To cc
    a=word(matrix.r.c,4)
    If a=0.0000000001 Then a=0
    If a>0 Then
      ol=ol format(a,3)
    Else
      ol=ol ' - '
    total=total+word(matrix.r.c,4)*word(matrix.r.c,3)
    as=as a
    End
  Say ol
  End
Say 'Total costs:' format(total,4,1)
Return


/**********************************************************************
* Subroutines for Optimization
**********************************************************************/

steppingstone: Procedure Expose matrix. cost. rr cc matrix. demand_in.,
                                              source_in. fid move cnt.
maxReduction=0
move=''
Call fixDegenerateCase
Do r=1 To rr
  Do c=1 To cc
    Parse Var matrix.r.c r c cost qrc
    If qrc=0 Then Do
      path=getclosedpath(r,c)
      If pelems(path)<4 then
        Iterate
      reduction = 0
      lowestQuantity = 1e10
      leavingCandidate = ''
      plus=1
      pathx=path
      Do While pathx<>''
        Parse Var pathx s '|' pathx
        If plus Then
          reduction=reduction+word(s,3)
        Else Do
          reduction=reduction-word(s,3)
          If word(s,4)<lowestQuantity Then Do
            leavingCandidate = s
            lowestQuantity = word(s,4)
            End
          End
        plus=\plus
        End
      If reduction < maxreduction Then Do
        move=path
        leaving=leavingCandidate
        maxReduction = reduction
        End
      End
    End
  End
if move<>'' Then Do
  quant=word(leaving,4)
  If quant=0 Then Do
    Call show_alloc 'Optimum'
    Exit
    End
  plus=1
  Do While move<>''
    Parse Var move m '|' move
    Parse Var m r c cpu qrc
    Parse Var matrix.r.c vr vc vcost vquant
    If plus Then
      nquant=vquant+quant
    Else
      nquant=vquant-quant
    matrix.r.c = vr vc vcost nquant
    plus=\plus
    End
  move=''
  Call steppingStone
  End
Else
  Call show_alloc 'Optimal Solution' fid
Return

getclosedpath: Procedure Expose matrix. cost. rr cc
Parse Arg rd,cd
path=rd cd cost.rd.cd word(matrix.rd.cd,4)
do r=1 To rr
  Do c=1 To cc
    If word(matrix.r.c,4)>0 Then Do
      path=path'|'r c cost.r.c word(matrix.r.c,4)
      End
    End
  End
path=magic(path)
Return stones(path)

magic: Procedure
Parse Arg list
Do Forever
  list_1=remove_1(list)
  If list_1=list Then Leave
  list=list_1
  End
Return list_1

remove_1: Procedure
Parse Arg list
cntr.=0
cntc.=0
Do i=1 By 1 While list<>''
  parse Var list e.i '|' list
  Parse Var e.i r c .
  cntr.r=cntr.r+1
  cntc.c=cntc.c+1
  End
n=i-1
keep.=1
Do i=1 To n
  Parse Var e.i r c .
  If cntr.r<2 |,
     cntc.c<2 Then Do
    keep.i=0
    End
  End
list=e.1
Do i=2 To n
  If keep.i Then
    list=list'|'e.i
  End
Return list

stones: Procedure
Parse Arg lst
stones=lst
tstc=lst
Do i=1 By 1 While tstc<>''
  Parse Var tstc o.i '|' tstc
  End
o.0=i-1
prev=o.1
Do i=1 To o.0
  st.i=prev
  k=i//2
  nbrs=getNeighbors(prev, lst)
  Parse Var nbrs n.1 '|' n.2
  If k=0 Then
    prev=n.2
  Else
    prev=n.1
  End
stones=st.1
Do i=2 To o.0
  stones=stones'|'st.i
  End
Return stones

getNeighbors: Procedure
parse Arg s, lst
Do i=1 By 1 While lst<>''
  Parse Var lst o.i '|' lst
  End
o.0=i-1
nbrs.=''
sr=word(s,1)
sc=word(s,2)
Do i=1 To o.0
  If o.i<>s Then Do
    or=word(o.i,1)
    oc=word(o.i,2)
    If or=sr & nbrs.0='' Then
      nbrs.0 = o.i
    else if oc=sc & nbrs.1='' Then
      nbrs.1 = o.i
    If nbrs.0<>'' & nbrs.1<>'' Then
      Leave
    End
  End
return nbrs.0'|'nbrs.1

m1: Procedure
Parse Arg z
Return z-1

pelems: Procedure
Call Trace 'O'
Parse Arg p
n=0
Do While p<>''
  Parse Var p x '|' p
  If x<>'' Then n=n+1
  End
Return n

fixDegenerateCase: Procedure Expose matrix. rr cc ms ms demand_in. source_in. move cnt.
Call matrixtolist
If (rr+cc-1)<>ms Then Do
  Do r=1 To rr
    Do c=1 To cc
      If word(matrix.r.c,4)=0 Then Do
        matrix.r.c=subword(matrix.r.c,1,3) 1.e-10
        Return
        End
      End
    End
  End
Return

matrixtolist: Procedure Expose matrix. rr cc ms
ms=0
list=''
Do r=1 To rr
  Do c=1 To cc
    If word(matrix.r.c,4)>0 Then Do
      list=list'|'matrix.r.c
      ms=ms+1
      End
    End
  End
Return strip(list,,'|')

Novalue:
  Say 'Novalue raised in line' sigl
  Say sourceline(sigl)
  Say 'Variable' condition('D')
  Signal lookaround

Syntax:
  Say 'Syntax raised in line' sigl
  Say sourceline(sigl)
  Say 'rc='rc '('errortext(rc)')'

halt:
lookaround:
  If fore() Then Do
    Say 'You can look around now.'
    Trace ?R
    Nop
    End
  Exit 12
