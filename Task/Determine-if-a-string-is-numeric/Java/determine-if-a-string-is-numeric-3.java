public static void main(String[] args) {
    String value;
    value = "1234567";
    System.out.printf("%-10s %b%n", value, isInteger(value));
    value = "12345abc";
    System.out.printf("%-10s %b%n", value, isInteger(value));
    value = "-123.456";
    System.out.printf("%-10s %b%n", value, isFloatingPoint(value));
    value = "-.456";
    System.out.printf("%-10s %b%n", value, isFloatingPoint(value));
    value = "123.";
    System.out.printf("%-10s %b%n", value, isFloatingPoint(value));
    value = "123.abc";
    System.out.printf("%-10s %b%n", value, isFloatingPoint(value));
}

static boolean isInteger(String string) {
    String digits = "0123456789";
    for (char character : string.toCharArray()) {
        if (!digits.contains(String.valueOf(character)))
            return false;
    }
    return true;
}

static boolean isFloatingPoint(String string) {
    /* at least one decimal-point */
    int indexOf = string.indexOf('.');
    if (indexOf == -1)
        return false;
    /* assure only 1 decimal-point */
    if (indexOf != string.lastIndexOf('.'))
        return false;
    if (string.charAt(0) == '-' || string.charAt(0) == '+') {
        string = string.substring(1);
        indexOf--;
    }
    String integer = string.substring(0, indexOf);
    if (!integer.isEmpty()) {
        if (!isInteger(integer))
            return false;
    }
    String decimal = string.substring(indexOf + 1);
    if (!decimal.isEmpty())
        return isInteger(decimal);
    return true;
}
