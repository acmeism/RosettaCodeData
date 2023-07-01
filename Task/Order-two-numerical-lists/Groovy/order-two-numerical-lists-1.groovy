class CList extends ArrayList implements Comparable {
    CList() { }
    CList(Collection c) { super(c) }
    int compareTo(Object that) {
        assert that instanceof List
        def n = [this.size(), that.size()].min()
        def comp = [this[0..<n], that[0..<n]].transpose().find { it[0] != it[1] }
        comp ? comp[0] <=> comp[1] : this.size() <=> that.size()
    }
}
