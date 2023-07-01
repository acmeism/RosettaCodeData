String csv = "...";
// Use Collectors.joining(...) for streaming, otherwise StringJoiner
StringBuilder html = new StringBuilder("<table>\n");
Collector collector = Collectors.joining("</td><td>", "  <tr><td>", "</td></tr>\n");
for (String row : csv.split("\n") ) {
    html.append(Arrays.stream(row.split(",")).collect(collector));
}
html.append("</table>\n");
