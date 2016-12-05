package main

import (
	"bytes"
	"fmt"
)

type symbolTable string

func (symbols symbolTable) encode(s string) []byte {
	seq := make([]byte, len(s))
	pad := []byte(symbols)
	c1 := []byte{0}
	for i := 0; i < len(s); i++ {
		c := s[i]
		c1[0] = c
		x := byte(bytes.Index(pad, c1))
		seq[i] = x
		copy(pad[1:], pad[:x])
		pad[0] = c
	}
	return seq
}

func (symbols symbolTable) decode(seq []byte) string {
	chars := make([]byte, len(seq))
	pad := []byte(symbols)
	for i, x := range seq {
		c := pad[x]
		chars[i] = c
		copy(pad[1:], pad[:x])
		pad[0] = c
	}
	return string(chars)
}

func main() {
	m := symbolTable("abcdefghijklmnopqrstuvwxyz")
	for _, s := range []string{"broood", "bananaaa", "hiphophiphop"} {
		enc := m.encode(s)
		dec := m.decode(enc)
		fmt.Println(s, enc, dec)
		if dec != s {
			panic("Whoops!")
		}
	}
}
