function HuffmanEncoding(str) {
    this.str = str;

    var count_chars = {};
    for (var i = 0; i < str.length; i++)
        if (str[i] in count_chars)
            count_chars[str[i]] ++;
        else
            count_chars[str[i]] = 1;

    var pq = new BinaryHeap(function(x){return x[0];});
    for (var ch in count_chars)
        pq.push([count_chars[ch], ch]);

    while (pq.size() > 1) {
        var pair1 = pq.pop();
        var pair2 = pq.pop();
        pq.push([pair1[0]+pair2[0], [pair1[1], pair2[1]]]);
    }

    var tree = pq.pop();
    this.encoding = {};
    this._generate_encoding(tree[1], "");

    this.encoded_string = ""
    for (var i = 0; i < this.str.length; i++) {
        this.encoded_string += this.encoding[str[i]];
    }
}

HuffmanEncoding.prototype._generate_encoding = function(ary, prefix) {
    if (ary instanceof Array) {
        this._generate_encoding(ary[0], prefix + "0");
        this._generate_encoding(ary[1], prefix + "1");
    }
    else {
        this.encoding[ary] = prefix;
    }
}

HuffmanEncoding.prototype.inspect_encoding = function() {
    for (var ch in this.encoding) {
        print("'" + ch + "': " + this.encoding[ch])
    }
}

HuffmanEncoding.prototype.decode = function(encoded) {
    var rev_enc = {};
    for (var ch in this.encoding)
        rev_enc[this.encoding[ch]] = ch;

    var decoded = "";
    var pos = 0;
    while (pos < encoded.length) {
        var key = ""
        while (!(key in rev_enc)) {
            key += encoded[pos];
            pos++;
        }
        decoded += rev_enc[key];
    }
    return decoded;
}
