def assertConformable = { a, b ->
    assert a instanceof List
    assert b instanceof List
    assert a.every { it instanceof List && it.size() == b.size() }
    assert b.every { it instanceof List && it.size() == b[0].size() }
}

def matmulWOIL = { a, b ->
    assertConformable(a, b)

    def bt = b.transpose()
    a.collect { ai ->
        bt.collect { btj ->
            [ai, btj].transpose().collect { it[0] * it[1] }.sum()
        }
    }
}
