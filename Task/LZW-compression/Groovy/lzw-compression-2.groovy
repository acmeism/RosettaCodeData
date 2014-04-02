def plaintext = 'TOBEORNOTTOBEORTOBEORNOT'
def compressed = compress(plaintext)
def result = decompress(compressed)

println """\
    Plaintext:    '$plaintext'
    Compressed:   $compressed
    Uncompressed: '$result'""".stripIndent()
