MsgBox % MovingAverage(5,3)  ; 5, averaging length <- 3
MsgBox % MovingAverage(1)    ; 3
MsgBox % MovingAverage(-3)   ; 1
MsgBox % MovingAverage(8)    ; 2
MsgBox % MovingAverage(7)    ; 4

MovingAverage(x,len="") {    ; for integers (faster)
  Static
  Static sum:=0, n:=0, m:=10 ; default averaging length = 10
  If (len>"")                ; non-blank 2nd parameter: set length, reset
     sum := n := i := 0, m := len
  If (n < m)                 ; until the buffer is not full
     sum += x, n++           ;   keep summing data
  Else                       ; when buffer is full
     sum += x-v%i%           ;   add new, subtract oldest
  v%i% := x, i := mod(i+1,m) ; remember last m inputs, cycle insertion point
  Return sum/n
}
