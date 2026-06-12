package main

import (
	"bufio"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
)

func panicFunc(err error) {
	if err != nil {
		panic(err)
	}
}

func main() {
	dir, err := os.Getwd()

	panicFunc(err)

	entries, err := os.ReadDir(dir)

	panicFunc(err)

	tmp, err := os.CreateTemp("", "dir")

	panicFunc(err)

	origDict := make(map[int]string)

	for i, entry := range entries {
		value := filepath.Join(dir, entry.Name())
		origDict[i] = value
		fmt.Fprintf(tmp, "%05d\t%s\n", i, value)
	}

	tmp.Close()

	name := tmp.Name()

	cmd := exec.Command(os.Getenv("EDITOR"), name)
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	panicFunc(cmd.Run())

	tmp2, err := os.Open(name)
	panicFunc(err)

	defer tmp2.Close()

	scanner := bufio.NewScanner(tmp2)

	newDict := make(map[int]string)

	for scanner.Scan() {
		line := scanner.Text()
		items := strings.SplitN(line, "\t", 2)

		if len(items) < 2 {
			panic("Error")
		}

		key, value := items[0], items[1]
		numericKey, err := strconv.Atoi(key)

		panicFunc(err)

		_, ok := newDict[numericKey]

		if ok {
			panic("Can't have two repeating keys")
		}

		_, ok = origDict[numericKey]

		if !ok {
			panic("Invalid key")
		}

		newDict[numericKey] = value
	}

	for key := range origDict {
		origItem := origDict[key]
		newItem, ok := newDict[key]

		if !ok {
			panicFunc(os.RemoveAll(origItem))
			continue
		}

		if newItem != origItem {
			panicFunc(os.Rename(origItem, newItem))
		}
	}
}
