String printASCIITable() {
    StringBuilder string = new StringBuilder();
    String newline = System.lineSeparator();
    string.append("dec hex binary oct char").append(newline);
    for (int decimal = 32; decimal <= 127; decimal++) {
        string.append(format(decimal));
        switch (decimal) {
            case 32 -> string.append("[SPACE]");
            case 127 -> string.append("[DELETE]");
            default -> string.append((char) decimal);
        }
        string.append(newline);
    }
    return string.toString();
}

String format(int value) {
    return "%-3d %01$-2x %7s %01$-3o ".formatted(value, Integer.toBinaryString(value));
}
