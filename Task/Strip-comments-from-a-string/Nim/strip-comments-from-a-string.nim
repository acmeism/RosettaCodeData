import strutils

proc removeComments(line: string; sep: char): string =
  line.split(sep)[0].strip(leading = false)

const
  Str1 = "apples, pears # and bananas"
  Str2 = "apples, pears ; and bananas"

echo "Original: “$#”" % Str1
echo "Stripped: “$#”" % Str1.removeComments('#')
echo "Original: “$#”" % Str2
echo "Stripped: “$#”" % Str2.removeComments(';')
