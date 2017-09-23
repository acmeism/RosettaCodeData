in='10 -12 1 0 999 8 2 2 4 4'
 Do i=1 To words(in)
   z.i=word(in,i)
   End
 n=i-1
 init=0
 Call minmax

 beads.=0;
 Do i=1 To words(in)
   z=z.i
   beads.z+=1
   End
 j=0
 Do i=lo To hi
   Do While beads.i>0
     j+=1
     s.j=i
     beads.i-=1
     End;
   End;
 Call show ' Input:',z.,n
 Call show 'Sorted:',s.,n
 Exit

 minmax:
 Do i=1 To n
   If init=0 Then Do
     init=1
     lo=z.i
     hi=z.i
     End
   Else Do
     lo=min(lo,z.i)
     hi=max(hi,z.i)
     End
   End
 Return

show: Procedure Expose n
 Use Arg txt,a.
 ol=txtg>
 Do i=1 To n
   ol=ol format(a.i,3)
   End
 Say ol
 Return
