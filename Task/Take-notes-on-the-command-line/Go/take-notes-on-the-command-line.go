package main

import (
	"fmt"
	"io"
	"os"
	"strings"
	"time"
)

func addNote(fn string, note string) error {
	f, err := os.OpenFile(fn, os.O_RDWR|os.O_APPEND|os.O_CREATE, 0666)
	if err != nil {
		return err
	}
	_, err = fmt.Fprint(f, time.Now().Format(time.RFC1123), "\n\t", note, "\n")
	// To be extra careful with errors from Close():
	if cErr := f.Close(); err == nil {
		err = cErr
	}
	return err
}

func showNotes(w io.Writer, fn string) error {
	f, err := os.Open(fn)
	if err != nil {
		if os.IsNotExist(err) {
			return nil // don't report "no such file"
		}
		return err
	}
	_, err = io.Copy(w, f)
	f.Close()
	return err
}

func main() {
	const fn = "NOTES.TXT"
	var err error
	if len(os.Args) > 1 {
		err = addNote(fn, strings.Join(os.Args[1:], " "))
	} else {
		err = showNotes(os.Stdout, fn)
	}
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
