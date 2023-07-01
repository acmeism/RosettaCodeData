package main

import (
	"fmt"
	"io"
	"log"
	"os"

	"github.com/stacktic/ftp"
)

func main() {
	// Hard-coded demonstration values
	const (
		hostport = "localhost:21"
		username = "anonymous"
		password = "anonymous"
		dir      = "pub"
		file     = "somefile.bin"
	)

	conn, err := ftp.Connect(hostport)
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Quit()
	fmt.Println(conn)

	if err = conn.Login(username, password); err != nil {
		log.Fatal(err)
	}
	if err = conn.ChangeDir(dir); err != nil {
		log.Fatal(err)
	}
	fmt.Println(conn.CurrentDir())
	files, err := conn.List(".")
	if err != nil {
		log.Fatal(err)
	}
	for _, f := range files {
		fmt.Printf("%v %12d %v %v\n", f.Time, f.Size, f.Type, f.Name)
	}

	r, err := conn.Retr(file)
	if err != nil {
		log.Fatal(err)
	}
	defer r.Close()

	f, err := os.Create(file)
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	n, err := io.Copy(f, r)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("Wrote", n, "bytes to", file)
}
