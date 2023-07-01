MovingAverage(x,len="") {    ; for floating point numbers
  Static
  Static n:=0, m:=10         ; default averaging length = 10
  If (len>"")                ; non-blank 2nd parameter: set length, reset
     n := i := 0, m := len
  n += n < m, sum := 0
  v%i% := x, i := mod(i+1,m) ; remember last m inputs, cycle insertion point
  Loop %n%                   ; recompute sum to avoid error accumulation
     j := A_Index-1, sum += v%j%
  Return sum/n
}
