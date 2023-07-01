# Built-in
GcdInt(35, 42);
# 7

# Euclidean algorithm
GcdInteger := function(a, b)
    local c;
    a := AbsInt(a);
    b := AbsInt(b);
    while b > 0 do
        c := a;
        a := b;
        b := RemInt(c, b);
    od;
    return a;
end;

GcdInteger(35, 42);
# 7
