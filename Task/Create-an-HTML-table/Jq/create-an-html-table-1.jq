def html_row:
  "<tr>",
  "  \(.[] | "<td>\(.)</td>")",
  "</tr>";

def html_header:
  "<thead align = 'right'>",
  "  \(html_row)",
  "</thead>";

 def html_table(header):
  "<table>",
  "  \(header | html_header)",
  "  <tbody align = 'right'>",
  "    \(.[] | html_row)",
  "  </tbody",
  "</table>";

# Prepend the sequence number
def html_table_with_sequence(header):
  length as $length
  | . as $in
  | [range(0;length) | [.+1] + $in[.]] |  html_table(header);
