function evalWithX(expr, a, b) {
    var x = a;
    var atA = eval(expr);
    x = b;
    var atB = eval(expr);
    return atB - atA;
}
