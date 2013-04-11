def mode(Iterable col) {
    assert col
    def m = [:]
    col.each {
        m[it] = m[it] == null ? 1 : m[it] + 1
    }
    def keys = m.keySet().sort { -m[it] }
    keys.findAll { m[it] == m[keys[0]] }
}
