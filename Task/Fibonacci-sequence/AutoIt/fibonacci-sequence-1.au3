#AutoIt Version: 3.2.10.0
$n0 = 0
$n1 = 1
$n = 10
MsgBox (0,"Iterative Fibonacci ", it_febo($n0,$n1,$n))

Func it_febo($n_0,$n_1,$N)
   $first = $n_0
   $second = $n_1
   $next = $first + $second
   $febo = 0
   For $i = 1 To $N-3
      $first = $second
      $second = $next
      $next = $first + $second
   Next
   if $n==0 Then
      $febo = 0
   ElseIf $n==1 Then
      $febo = $n_0
   ElseIf $n==2 Then
      $febo = $n_1
   Else
      $febo = $next
   EndIf
   Return $febo
EndFunc
