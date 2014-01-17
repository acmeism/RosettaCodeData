def crc32(byte[] bytes) {
    new java.util.zip.CRC32().with { update bytes; value }
}
