function encode_re(input) {
    var encoding = [];
    input.match(/(.)\1*/g).forEach(function(substr){ encoding.push([substr.length, substr[0]]) });
    return encoding;
}
