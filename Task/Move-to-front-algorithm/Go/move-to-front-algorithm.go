package main

import (
	"bytes"
	"fmt"
)

type symbolTable string

func (symbols symbolTable) encode(s string) []byte {
	seq := make([]byte, len(s))
	pad := []byte(symbols)
	for i, c := range []byte(s) {
		x := bytes.IndexByte(pad, c)
		seq[i] = byte(x)
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
