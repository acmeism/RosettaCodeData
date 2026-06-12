import re
import textwrap

RE = re.compile(r"^([^bc\r\n]*a[^c\r\n]*b.*c.*)$", re.M)

with open("unixdict.txt") as fd:
    abc_words = RE.findall(fd.read())

print(f"found {len(abc_words)} ABC words")
print(textwrap.fill(" ".join(abc_words)))
