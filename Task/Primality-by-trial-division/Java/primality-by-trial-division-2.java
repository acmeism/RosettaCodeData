public static boolean prime(int n) {
    return !new String(new char[n]).matches(".?|(..+?)\\1+");
}
