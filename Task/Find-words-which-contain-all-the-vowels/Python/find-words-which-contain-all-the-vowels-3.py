import re

pattern = re.compile(
    r"^(?=[^a]*a[^a]*$)(?=[^e]*e[^e]*$)(?=[^i]*i[^i]*$)(?=[^o]*o[^o]*$)(?=[^u]*u[^u]*$).*$",
)

with open("unixdict.txt") as fd:
    for line in fd:
        if len(line) > 11 and pattern.match(line):
            print(line, end="")
