def grayEncode = { i ->
    i ^ (i >>> 1)
}

def grayDecode;
grayDecode = { int code ->
    if(code <= 0) return 0
    def h = grayDecode(code >>> 1)
    return (h << 1) + ((code ^ h) & 1)
}
