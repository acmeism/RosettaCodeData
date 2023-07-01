# Assertions:
def assert($x; $y):
    if ($x == $y) then empty
    else "WARNING @ \($__loc__.line): \($x) != \($y)" | stderr, false
    end;

def assertions:
    assert(""     | ibase; null),
    assert("--1"  | ibase;  1),
    assert("11"   | ibase(2);  3),
    assert(11     | ibase(3);  4),
    assert(11     | ibase(14); 15),
    assert(" 0xF" | ibase; 15),
    assert(" F"   | ibase; 15),
    assert("17"   | ibase(8); 15),
    assert("0o17" | ibase; 15),
    assert(021    | ibase(7); 15),
    assert("015"  | ibase(10); 15),
    assert(" 0bF "| ibase; 15),
    assert("0b1111" | ibase; 15)
;

assertions
