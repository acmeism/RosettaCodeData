package main

import (
	"io"
	"os"
	"strconv"
	"strings"
	"text/tabwriter"
)

func readTable(table string) ([]string, []int) {
	fields := strings.Fields(table)
	var commands []string
	var minLens []int

	for i, max := 0, len(fields); i < max; {
		cmd := fields[i]
		cmdLen := len(cmd)
		i++

		if i < max {
			num, err := strconv.Atoi(fields[i])
			if err == nil && 1 <= num && num < cmdLen {
				cmdLen = num
				i++
			}
		}

		commands = append(commands, cmd)
		minLens = append(minLens, cmdLen)
	}

	return commands, minLens
}

func validateCommands(commands []string, minLens []int, words []string) []string {
	var results []string
	for _, word := range words {
		matchFound := false
		wlen := len(word)
		for i, command := range commands {
			if minLens[i] == 0 || wlen < minLens[i] || wlen > len(command) {
				continue
			}
			c := strings.ToUpper(command)
			w := strings.ToUpper(word)
			if strings.HasPrefix(c, w) {
				results = append(results, c)
				matchFound = true
				break
			}
		}
		if !matchFound {
			results = append(results, "*error*")
		}
	}
	return results
}

func printResults(words []string, results []string) {
	wr := tabwriter.NewWriter(os.Stdout, 0, 1, 1, ' ', 0)
	io.WriteString(wr, "user words:")
	for _, word := range words {
		io.WriteString(wr, "\t"+word)
	}
	io.WriteString(wr, "\n")
	io.WriteString(wr, "full words:\t"+strings.Join(results, "\t")+"\n")
	wr.Flush()
}

func main() {
	const table = "" +
		"add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1  Schange  Cinsert 2  Clast 3 " +
		"compress 4 copy 2 count 3 Coverlay 3 cursor 3  delete 3 Cdelete 2  down 1  duplicate " +
		"3 xEdit 1 expand 3 extract 3  find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2 " +
		"forward 2  get  help 1 hexType 4  input 1 powerInput 3  join 1 split 2 spltJOIN load " +
		"locate 1 Clocate 2 lowerCase 3 upperCase 3 Lprefix 2  macro  merge 2 modify 3 move 2 " +
		"msg  next 1 overlay 1 parse preserve 4 purge 3 put putD query 1 quit  read recover 3 " +
		"refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4 rgtLEFT right 2 left " +
		"2  save  set  shift 2  si  sort  sos  stack 3 status 4 top  transfer 3  type 1  up 1 "

	const sentence = "riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin"

	commands, minLens := readTable(table)
	words := strings.Fields(sentence)

	results := validateCommands(commands, minLens, words)

	printResults(words, results)
}
