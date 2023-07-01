const list =
('
Hello world!
你好世界！
Salamu, Dunia!
こんにちは世界！
¡Hola Mundo!
Chào thế giới!
Hallo Welt!
')

fn main() {
    for line in list.split('\n') {if line !='' {println(reverse_string(line))}}
}

fn reverse_string(word string) string {
    return word.runes().reverse().string()
}
