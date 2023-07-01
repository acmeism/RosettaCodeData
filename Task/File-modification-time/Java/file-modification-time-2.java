public static void main(String[] args) {
    File file = new File("file.txt");
    /* get */
    /* returns '0' if the file does not exist */
    System.out.printf("%tD %1$tT%n", file.lastModified());
    /* set */
    file.setLastModified(System.currentTimeMillis());
}
