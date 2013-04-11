import std.stdio, std.algorithm;

void main() {
    auto set1 = [1, 2, 3, 4, 5, 6];
    auto set2 = [2, 5, 6, 3, 4, 8].sort; // [2, 3, 4, 5, 6, 8]
    auto set3 = [1, 2, 5];

    assert(equal(setUnion(set1, set2), [1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 8]));
    assert(equal(setIntersection(set1, set2), [2, 3, 4, 5, 6]));
    assert(equal(setDifference(set1, set2), [1]));
    assert(equal(setSymmetricDifference(set1, set2), [1, 8]));
    assert(equal(setDifference(set3, set1), new int[](0)));  // subset
    assert(set1 != set2);

    auto set4 = [ [ 1, 4, 7, 8 ], [ 1, 7 ], [ 1, 7, 8], [ 4 ], [ 7 ], ];
    auto set5 = [ 1, 1, 1, 4, 4, 7, 7, 7, 7, 8, 8 ];
    assert(equal(nWayUnion(set4), set5));
}
