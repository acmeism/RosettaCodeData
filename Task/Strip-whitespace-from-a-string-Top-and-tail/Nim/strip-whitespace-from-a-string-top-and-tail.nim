import strutils

let s = "\t \v \r String with spaces \n \t \f"
echo "“", s, "”"
echo("*** Stripped of leading spaces ***")
echo "“", s.strip(trailing = false), "”"
echo("*** Stripped of trailing spaces ***")
echo "“", s.strip(leading = false), "”"
echo("*** Stripped of leading and trailing spaces ***")
echo "“", s.strip(), "”"
