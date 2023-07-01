def markovInterpreterFor = { rules ->
    def ruleMap = [:]
    rules.eachLine { line ->
        (line =~ /\s*(.+)\s->\s([.]?)(.+)\s*/).each { text, key, terminating, value ->
            if (key.startsWith('#')) { return }
            ruleMap[key] = [text: value, terminating: terminating]
        }
    }
    [interpret: { text ->
        def originalText = ''
        while (originalText != text) {
            originalText = text
            for (Map.Entry e : ruleMap.entrySet()) {
                if (text.indexOf(e.key) >= 0) {
                    text = text.replace(e.key, e.value.text)
                    if (e.value.terminating) {
                        return text
                    }
                    break
                }
            }
        }
        text
    }]
}
