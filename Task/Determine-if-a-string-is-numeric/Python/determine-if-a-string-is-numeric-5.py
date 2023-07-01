import re
numeric = re.compile('[-+]?(\d+(\.\d*)?|\.\d+)([eE][-+]?\d+)?')
is_numeric = lambda x: numeric.fullmatch(x) != None

is_numeric('123.0')
