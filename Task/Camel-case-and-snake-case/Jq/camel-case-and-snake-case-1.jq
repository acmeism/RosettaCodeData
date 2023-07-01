def isUpper: explode[0] | 65 <= . and . <= 90;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# "White space is not permitted as part of camel case or snake case variable names."
def trim: sub("^\\s+";"") | sub("\\s+$";"");
