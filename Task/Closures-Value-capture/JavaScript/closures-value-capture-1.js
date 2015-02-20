var funcs = [];
for (var i = 0; i < 10; i++) {
    funcs.push( (function(i) {
                     return function() { return i * i; }
                })(i) );
}
window.alert(funcs[3]()); // alerts "9"
