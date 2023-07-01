MsgBox % time("fx")
Return

fx()
{
  Sleep, 1000
}

time(function, parameter=0)
{
  SetBatchLines -1  ; don't sleep for other green threads
  StartTime := A_TickCount
  %function%(parameter)
  Return ElapsedTime := A_TickCount - StartTime . " milliseconds"
}
