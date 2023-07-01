String generateHTMLTable() {
    StringBuilder string = new StringBuilder();
    string.append("<table border=\"1\">");
    string.append(System.lineSeparator());
    string.append("<tr>".indent(2));
    string.append("<th width=\"40\"></th>".indent(4));
    string.append("<th width=\"50\">X</th>".indent(4));
    string.append("<th width=\"50\">Y</th>".indent(4));
    string.append("<th width=\"50\">Z</th>".indent(4));
    string.append("</tr>".indent(2));
    Random random = new Random();
    int number;
    for (int countA = 0; countA < 10; countA++) {
        string.append("<tr>".indent(2));
        string.append("<td>%d</td>".formatted(countA).indent(4));
        for (int countB = 0; countB < 3; countB++) {
            number = random.nextInt(1, 9999);
            string.append("<td>%,d</td>".formatted(number).indent(4));
        }
        string.append("</tr>".indent(2));
    }
    string.append("</table>");
    return string.toString();
}
