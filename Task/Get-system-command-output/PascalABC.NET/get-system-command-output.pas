uses System.Diagnostics;

begin
  var pr := new Process();
  var startInfo := new ProcessStartInfo();
  startInfo.WindowStyle := ProcessWindowStyle.Hidden;
  startInfo.FileName := 'cmd.exe';
  startInfo.Arguments := '/c echo Hello World';
  startInfo.RedirectStandardOutput := true;
  startInfo.UseShellExecute := false;
  pr.StartInfo := startInfo;
  pr.Start;

  var output := pr.StandardOutput.ReadToEnd;
  Print($'Output is {output}');
end.
