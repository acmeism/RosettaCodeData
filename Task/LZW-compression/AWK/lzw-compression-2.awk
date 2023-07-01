# ported from Python
BEGIN {
   is_comp = 0
   is_decomp = 0
}

{
    if ($0 == "") next

    if ($1 == "==comp") {
        is_comp = 1
        is_decomp = 0
        print "\ncompressing..."
        next
    }

    if ($1 == "==decomp") {
        is_comp = 0
        is_decomp = 1
        print "\ndecompressing..."
        next
    }

    if (is_comp) print compress($0)

    if (is_decomp) print decompress($0)
}

function compress(str,     dict_size, i, dictionary, w, result, len, uncompressed, c, wc ) {
    dict_size = 256
    for (i = 0; i <= dict_size; i++) dictionary[chr(i)] = i

    w = ""
    result = ""
    len = split(str, uncompressed, "")
    for (i = 1; i <= len; i++) {
        c = uncompressed[i]
        wc = w c
        if (wc in dictionary) w = wc
        else {
            result = result "," dictionary[w]
            dictionary[wc] = dict_size++
            w = c
        }
    }
    if (length(w)) result = result "," dictionary[w]
    return substr(result,2)
    return "[" substr(result,2) "]"
}

function decompress(str) {
    dict_size = 256
    for (i = 0; i <= dict_size; i++) dictionary[i] = chr(i)

    result = ""
    len = split(str, compressed, ",")
    w = chr(compressed[1])
    result = result w
    for (i = 2; i <= len; i++) {
        k = compressed[i]
        if (k in dictionary) entry = dictionary[k]
        else if (k == dict_size) entry = w substr(w,1,1)
        else { entry = "*" }
        result = result entry
        dictionary[dict_size++] = w substr(entry,1,1)
        w = entry
    }
    return result
}

function chr(c) {
    return sprintf("%c", c + 0)
}
