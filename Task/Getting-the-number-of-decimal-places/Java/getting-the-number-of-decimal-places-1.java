int decimalPlaces(double value) {
    String string = String.valueOf(value);
    return string.length() - (string.indexOf('.') + 1);
}
