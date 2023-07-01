Array.prototype.unique = function() {
    var u = this.concat().sort();
    for (var i = 1; i < u.length; ) {
        if (u[i-1] === u[i])
            u.splice(i,1);
        else
            i++;
    }
    return u;
}
var uniq = [1, 2, 3, "a", "b", "c", 2, 3, 4, "b", "c", "d"].unique();
