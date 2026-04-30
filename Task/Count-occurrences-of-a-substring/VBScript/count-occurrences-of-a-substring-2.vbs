function CountSubstring(str,substr)
  with new regexp
     .pattern=substr
     .global=true
     set m=.execute(str)
  end with
  CountSubstring =m.count
end function
WScript.StdOut.Writeline CountSubstring("the three truths","th")
WScript.StdOut.Writeline CountSubstring("ababababab","abab")
