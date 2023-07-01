function rot13(c) {
    return c.replace(/([a-m])|([n-z])/ig, function($0,$1,$2) {
        return String.fromCharCode($1 ? $1.charCodeAt(0) + 13 : $2 ? $2.charCodeAt(0) - 13 : 0) || $0;
    });
}
rot13("ABJURER nowhere") // NOWHERE abjurer
