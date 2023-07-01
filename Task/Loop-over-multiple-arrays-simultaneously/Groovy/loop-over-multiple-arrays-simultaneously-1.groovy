def synchedConcat = { a1, a2, a3 ->
    assert a1 && a2 && a3
    assert a1.size() == a2.size()
    assert a2.size() == a3.size()
    [a1, a2, a3].transpose().collect { "${it[0]}${it[1]}${it[2]}" }
}
