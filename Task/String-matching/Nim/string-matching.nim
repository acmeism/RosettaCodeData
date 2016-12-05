import strutils

var s: string = "The quick brown fox"
if startsWith(s, "The quick"):
   echo("Starts with: The quick")
if endsWith(s, "brown Fox"):
   echo("Ends with: brown fox")
var pos = find(s, " brown ")  # -1 if not found
if contains(s, " brown "):    # showing the contains() proc, but could use if pos!=-1:
   echo('"' & " brown " & '"' & " is located at position: " & $pos)
