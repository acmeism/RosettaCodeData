// in A but not in B
function relative_complement(A, B) {
    return A.filter(function(elem) {return B.indexOf(elem) == -1});
}

// in A or in B but not in both
function symmetric_difference(A,B) {
    return relative_complement(A,B).concat(relative_complement(B,A));
}

var a = ["John", "Serena", "Bob", "Mary", "Serena"].unique();
var b = ["Jim", "Mary", "John", "Jim", "Bob"].unique();

print(a);
print(b);
print(symmetric_difference(a,b));
