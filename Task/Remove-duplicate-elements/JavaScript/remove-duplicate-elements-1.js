function unique(ary) {
    // concat() with no args is a way to clone an array
    var u = ary.concat().sort();
    for (var i = 1; i < u.length; ) {
        if (u[i-1] === u[i])
            u.splice(i,1);
        else
            i++;
    }
    return u;
}

var ary = [1, 2, 3, "a", "b", "c", 2, 3, 4, "b", "c", "d", "4"];
var uniq = unique(ary);
for (var i = 0; i < uniq.length; i++)
    print(uniq[i] + "\t" + typeof(uniq[i]));
