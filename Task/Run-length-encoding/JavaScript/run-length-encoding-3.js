function decode(encoded) {
    var output = "";
    encoded.forEach(function(pair){ output += new Array(1+pair[0]).join(pair[1]) })
    return output;
}
