fun time_it (action, arg) = let
  val timer = Timer.startCPUTimer ()
  val _ = action arg
  val times = Timer.checkCPUTimer timer
in
  Time.+ (#usr times, #sys times)
end
