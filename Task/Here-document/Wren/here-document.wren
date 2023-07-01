var a = 42
var b = """
This is a 'raw' string with the following properties:
  - indention is preserved,
  - an escape sequence such as a quotation mark "\\" is interpreted literally, and
  - interpolation such as %(a) is also interpreted literally.
`Have fun!`
"""
System.print(b)
