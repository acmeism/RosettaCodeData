import strutils

proc removeComments(line, sep): string =
  line.split(sep)[0].strip(leading = false)

echo removeComments("apples, pears # and bananas", '#')
echo removeComments("apples, pears ; and bananas", ';')
