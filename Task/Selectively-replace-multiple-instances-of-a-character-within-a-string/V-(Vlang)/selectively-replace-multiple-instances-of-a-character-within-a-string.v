fn selectively_replace_chars(s string, char_map map[string]string) string {
    mut bytes := s.bytes()
    mut counts := {
        'a': 0
        'b': 0
        'r': 0
    }
    for i := s.len - 1; i >= 0; i-- {
        c := s[i].ascii_str()
        if c in ['a', 'b', 'r'] {
            bytes[i] = char_map[c][counts[c]]
            counts[c]++
        }
    }
    return bytes.bytestr()
}

fn main() {
    char_map := {
        'a': 'DCaBA'
        'b': 'bE'
        'r': 'Fr'
    }
    for old in ['abracadabra', 'caaarrbabad'] {
        new := selectively_replace_chars(old, char_map)
        println('$old -> $new')
    }
}
