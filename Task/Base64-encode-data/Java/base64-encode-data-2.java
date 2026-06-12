byte[] encodeFile(String path) throws IOException {
    try (FileInputStream stream = new FileInputStream(path)) {
        byte[] bytes = stream.readAllBytes();
        return Base64.getEncoder().encode(bytes);
    }
}
