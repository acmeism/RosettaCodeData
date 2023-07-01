class ABCSolver {
    def blocks

    ABCSolver(blocks = []) { this.blocks = blocks }

    boolean canMakeWord(rawWord) {
        if (rawWord == '' || rawWord == null) { return true; }
        def word = rawWord.toUpperCase()
        def blocksLeft = [] + blocks
        word.every { letter -> blocksLeft.remove(blocksLeft.find { block -> block.contains(letter) }) }
    }
}
