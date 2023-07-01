def is_pangram(sentence: String) = sentence.toLowerCase.filter(c => c >= 'a' && c <= 'z').toSet.size == 26
