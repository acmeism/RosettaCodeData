void create() throws IOException {
    File file = new File("output.txt");
    /* create an empty file */
    file.createNewFile();
    File directory = new File("docs/");
    /* create all parent directories */
    directory.mkdirs();
    File rootDirectory = new File("/docs/");
    rootDirectory.mkdirs();
}
