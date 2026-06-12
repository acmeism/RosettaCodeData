import re
def extractExt(url):
  m = re.search(r'\.[A-Za-z0-9]+$', url)
  return m.group(0) if m else ""
