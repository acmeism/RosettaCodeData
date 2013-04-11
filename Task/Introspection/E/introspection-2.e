escape fail {
    def &x := meta.getState().fetch("&bloop", fn { fail("no bloop") })
    if (!x.__respondsTo("abs", 0)) { fail("no abs") }
    x.abs()
}
