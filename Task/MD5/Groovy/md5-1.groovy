import java.security.MessageDigest

String.metaClass.md5Checksum = {
    MessageDigest.getInstance('md5').digest(delegate.bytes).collect { String.format("%02x", it) }.join('')
}
