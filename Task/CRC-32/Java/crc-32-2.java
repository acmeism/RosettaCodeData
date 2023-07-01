public static void main(String[] args) throws IOException {
    String string = "The quick brown fox jumps over the lazy dog";
    CRC32 crc = new CRC32();
    crc.update(string.getBytes());
    System.out.printf("%x", crc.getValue());
}
