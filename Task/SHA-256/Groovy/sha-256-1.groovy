def sha256Hash = { text ->
    java.security.MessageDigest.getInstance("SHA-256").digest(text.bytes)
            .collect { String.format("%02x", it) }.join('')
}
