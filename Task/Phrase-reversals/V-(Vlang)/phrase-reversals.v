fn main() {
	str := 'rosetta code phrase reversal'
    words := str.fields()
    println('Original:          $str')
    println('Reverse:           ${str.reverse()}')
    println('Char-Word Reverse: ${words.map(it.reverse()).join(' ')}')
    println('Word Reverse:      ${words.reverse().join(' ')}')
}
