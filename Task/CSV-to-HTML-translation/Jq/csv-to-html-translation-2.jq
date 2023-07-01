def headerrow2html:
  ["  <thead> <tr>"]
  + (split(",") | map("    <th>\(@html)</th>"))
  + [ "  </tr> </thead>" ]
;

def row2html:
  ["  <tr>"]
  + (split(",") | map("    <td>\(@html)</td>"))
  + [ "  </tr>" ]
;

def csv2html:
  def rows: reduce .[] as $row
    ([]; . + ($row | row2html));
  ["<table>"]
  + (.[0]  | headerrow2html)
  + (.[1:] | rows)
  + [ "</table>"]
;

csv2html | .[]
