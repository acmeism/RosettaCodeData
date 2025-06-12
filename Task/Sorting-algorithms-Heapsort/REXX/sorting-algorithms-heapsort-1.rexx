/* REXX ***************************************************************
* Translated from PL/I
* 27.07.2013 Walter Pachl
**********************************************************************/
 list='---letters of the modern Greek Alphabet---|'||,
      '==========================================|'||,
      'alpha|beta|gamma|delta|epsilon|zeta|eta|theta|'||,
      'iota|kappa|lambda|mu|nu|xi|omicron|pi|'||,
      'rho|sigma|tau|upsilon|phi|chi|psi|omega'
 Do i=0 By 1 While list<>''
   Parse Var list a.i '|' list
   End
 n=i-1

 Call showa 'before sort'
 Call heapsort n
 Call showa ' after sort'
 Exit

 heapSort: Procedure Expose a.
 Parse Arg count
 Call heapify count
 end=count-1
 do while end>0
   Call swap end,0
   end=end-1
   Call siftDown 0,end
   End
 Return

 heapify: Procedure Expose a.
 Parse Arg count
 start=(count-2)%2
 Do while start>=0
   Call siftDown start,count-1
   start=start-1
   End
 Return

 siftDown: Procedure Expose a.
 Parse Arg start,end
 root=start
 Do while root*2+1<= end
   child=root*2+1
   sw=root
   if a.sw<a.child Then
     sw=child
   child_1=child+1
   if child+1<=end & a.sw<a.child_1 Then
     sw=child+1
   if sw<>root Then Do
     Call swap root,sw
     root=sw
     End
   else
     return
   End
 Return

 swap: Procedure Expose a.
 Parse arg x,y
 temp=a.x
 a.x=a.y
 a.y=temp
 Return

 showa: Procedure Expose a. n
 Parse Arg txt
 Do j=0 To n-1
   Say 'element' format(j,2) txt a.j
   End
 Return
