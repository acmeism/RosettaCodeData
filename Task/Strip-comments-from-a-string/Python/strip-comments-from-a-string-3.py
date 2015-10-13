import re

m = re.match(r'^([^#]*)#(.*)$', line)
if m:  # The line contains a hash / comment
    line = m.group(1)
