import strutils

let s = "The quick brown fox"
if s.startsWith("The quick"):
  echo "Starts with “The quick”."
if s.endsWith("brown Fox"):
  echo "Ends with “brown fox”."
if s.contains(" brown "):
  echo "Contains “ brown ”."
if "quick" in s:
  echo "Contains “quick”."      # Alternate form for "contains".

let pos = find(s, " brown ")    # -1 if not found.
if pos >= 0:
  echo "“ brown ” is located at position: " & $pos
