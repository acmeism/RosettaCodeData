void decodeToFile(String path, byte[] bytes) throws IOException {
    try (FileOutputStream stream = new FileOutputStream(path)) {
        byte[] decoded = Base64.getDecoder().decode(bytes);
        stream.write(decoded, 0, decoded.length);
    }
}
