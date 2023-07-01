def symDiff = { Set s1, Set s2 ->
    assert s1 != null
    assert s2 != null
    (s1 + s2) - (s1.intersect(s2))
}
