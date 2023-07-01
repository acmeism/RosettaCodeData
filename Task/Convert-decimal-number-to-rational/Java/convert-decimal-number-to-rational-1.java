double fractionToDecimal(String string) {
    int indexOf = string.indexOf(' ');
    int integer = 0;
    int numerator, denominator;
    if (indexOf != -1) {
        integer = Integer.parseInt(string.substring(0, indexOf));
        string = string.substring(indexOf + 1);
    }
    indexOf = string.indexOf('/');
    numerator = Integer.parseInt(string.substring(0, indexOf));
    denominator = Integer.parseInt(string.substring(indexOf + 1));
    return integer + ((double) numerator / denominator);
}

String decimalToFraction(double value) {
    String string = String.valueOf(value);
    string = string.substring(string.indexOf('.') + 1);
    int numerator = Integer.parseInt(string);
    int denominator = (int) Math.pow(10, string.length());
    int gcf = gcf(numerator, denominator);
    if (gcf != 0) {
        numerator /= gcf;
        denominator /= gcf;
    }
    int integer = (int) value;
    if (integer != 0)
        return "%d %d/%d".formatted(integer, numerator, denominator);
    return "%d/%d".formatted(numerator, denominator);
}

int gcf(int valueA, int valueB) {
    if (valueB == 0) return valueA;
    else return gcf(valueB, valueA % valueB);
}
