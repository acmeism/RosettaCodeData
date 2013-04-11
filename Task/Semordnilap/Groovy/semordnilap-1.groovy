def semordnilapWords(source) {
    def words = [] as Set
    def semordnilaps = []
    source.eachLine { word ->
        if (words.contains(word.reverse())) semordnilaps << word
        words << word
    }
    semordnilaps
}
