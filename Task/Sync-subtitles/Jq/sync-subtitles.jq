def syncSubtitles($secs):
  def fmt: "%H:%M:%S";
  def adjust: strptime(fmt) | .[5] += $seconds | strftime(fmt);

  if ($secs|type) != "number" then "The number of seconds must be specified as an integer" | error end
  | inputs as $line
  | ($line
     | capture("^(?<start>[^,]*),(?<startms>[0-9]*) *--> *(?<finish>[^,]*),(?<finishms>[0-9]*)")
     | "\(.start|adjust),\(.startms) --> \(.finish|adjust),\(.finishms)" )
  // $line ;

if $seconds > 0 then
  "Fast-forwarding \($seconds) seconds" | debug
  | syncSubtitles($seconds)
elif $seconds == 0 then
  "No resynchronization is needed" | debug
else
  "Rolling-back \(-$seconds) seconds" | debug
  | syncSubtitles($seconds)
end
