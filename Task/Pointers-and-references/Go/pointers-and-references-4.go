b := []byte(“hello world”)
c := b
c[0] = 'H'
fmt.Println(string(b))
