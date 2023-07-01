void append(String path, byte[] data) throws IOException {
    /* the second argument here is for appending bytes */
    try (FileOutputStream output = new FileOutputStream(path, true)) {
        output.write(data);
    }
}
