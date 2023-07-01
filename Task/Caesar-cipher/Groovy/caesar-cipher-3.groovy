def caesarEncode(k, text) {
    (text as int[]).collect { it==' ' ? ' ' : (((it & 0x1f) + k - 1) % 26 + 1 | it & 0xe0) as char }.join()
}
def caesarDecode(k, text) { caesarEncode(26 - k, text) }
