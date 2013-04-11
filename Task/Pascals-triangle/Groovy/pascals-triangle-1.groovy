def pascal = { n -> (n <= 1) ? [1] : GroovyCollections.transpose([[0] + pascal(n - 1), pascal(n - 1) + [0]]).collect { it.sum() } }
