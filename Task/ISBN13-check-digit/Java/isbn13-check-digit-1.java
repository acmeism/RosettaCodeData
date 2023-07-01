public static void main(String[] args) {
    String[] isbn13s = {
        "978-0596528126",
        "978-0596528120",
        "978-1788399081",
        "978-1788399083"
    };
    for (String isbn13 : isbn13s)
        System.out.printf("%s %b%n", isbn13, validateISBN13(isbn13));
}

static boolean validateISBN13(String string) {
    int[] digits = digits(string.strip().replace("-", ""));
    return digits[12] == checksum(digits);
}

static int[] digits(String string) {
    int[] digits = new int[13];
    int index = 0;
    for (char character : string.toCharArray()) {
        if (character < '0' || character > '9')
            throw new IllegalArgumentException("Invalid ISBN-13");
        /* convert ascii to integer */
        digits[index++] = Character.digit(character, 10);
    }
    return digits;
}

static int checksum(int[] digits) {
    int total = 0;
    int index = 0;
    for (int digit : digits) {
        if (index == 12) break;
        if (index++ % 2 == 1) digit *= 3;
        total += digit;
    }
    return 10 - (total % 10);
}
