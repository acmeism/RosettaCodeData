fn best_shuffle(s1 string) string {
    mut s2 := s1.clone()
    len_s2 := s2.len
    mut s2_bytes := s2.bytes()
    s1_bytes := s1.bytes()
    for i in 0 .. len_s2 {
        for j in 0 .. len_s2 {
            if i != j && s2_bytes[i] != s1_bytes[j] && s2_bytes[j] != s1_bytes[i] {
                i1 := if j < i { j } else { i }
                j1 := if j < i { i } else { j }
                // swap characters at i1 and j1 in s2_bytes
                s2_bytes[i1], s2_bytes[j1] = s2_bytes[j1], s2_bytes[i1]
            }
        }
    }
    return s2_bytes.bytestr()
}

fn main() {
    lista := ["abracadabra", "seesaw", "pop", "grrrrrr", "up", "a"]
    mut puntos := 0
    for palabra in lista {
        bs := best_shuffle(palabra)
        puntos = 0
        for i := 0; i < palabra.len; i++ {
            if palabra[i] == bs[i] { puntos++ }
        }
        println("$palabra ==> $bs  (puntuación: $puntos)")
    }
}
