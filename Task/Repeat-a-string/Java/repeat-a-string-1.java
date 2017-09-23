public static String repeat(String str, int times) {
    StringBuilder sb = new StringBuilder(str.length() * times);
    for (int i = 0; i < times; i++)
        sb.append(str);
    return sb.toString();
}

public static void main(String[] args) {
    System.out.println(repeat("ha", 5));
}
