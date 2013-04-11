def life1D = { self ->
    def right = self[1..-1] + [false]
    def left = [false] + self[0..-2]
    [left, self, right].transpose().collect { hood -> hood.count { it } == 2 }
}
