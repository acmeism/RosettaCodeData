<?

echo preg_replace(
  "/^.*<BR>(.*) UTC.*$/su",
  "\\1",
  file_get_contents('http://tycho.usno.navy.mil/cgi-bin/timer.pl')
);
