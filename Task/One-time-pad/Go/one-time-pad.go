package main

import (
    "bufio"
    "crypto/rand"
    "fmt"
    "io/ioutil"
    "log"
    "math/big"
    "os"
    "strconv"
    "strings"
    "unicode"
)

const (
    charsPerLine = 48
    chunkSize    = 6
    cols         = 8
    demo         = true // would normally be set to false
)

type fileType int

const (
    otp fileType = iota
    enc
    dec
)

var scnr = bufio.NewScanner(os.Stdin)

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func toAlpha(s string) string {
    var filtered []rune
    for _, r := range s {
        if unicode.IsUpper(r) {
            filtered = append(filtered, r)
        }
    }
    return string(filtered)
}

func isOtpRelated(s string) bool {
    return strings.HasSuffix(s, ".1tp") || strings.HasSuffix(s, "1tp_cpy") ||
        strings.HasSuffix(s, ".1tp_enc") || strings.HasSuffix(s, "1tp_dec")
}

func makePad(nLines int) string {
    nChars := nLines * charsPerLine
    bytes := make([]byte, nChars)
    /* generate random upper case letters */
    max := big.NewInt(26)
    for i := 0; i < nChars; i++ {
        n, err := rand.Int(rand.Reader, max)
        check(err)
        bytes[i] = byte(65 + n.Uint64())
    }
    return inChunks(string(bytes), nLines, otp)
}

func vigenere(text, key string, encrypt bool) string {
    bytes := make([]byte, len(text))
    var ci byte
    for i, c := range text {
        if encrypt {
            ci = (byte(c) + key[i] - 130) % 26
        } else {
            ci = (byte(c) + 26 - key[i]) % 26
        }
        bytes[i] = ci + 65
    }
    temp := len(bytes) % charsPerLine
    if temp > 0 { // pad with random characters so each line is a full one
        max := big.NewInt(26)
        for i := temp; i < charsPerLine; i++ {
            n, err := rand.Int(rand.Reader, max)
            check(err)
            bytes = append(bytes, byte(65+n.Uint64()))
        }
    }
    ft := enc
    if !encrypt {
        ft = dec
    }
    return inChunks(string(bytes), len(bytes)/charsPerLine, ft)
}

func inChunks(s string, nLines int, ft fileType) string {
    nChunks := len(s) / chunkSize
    remainder := len(s) % chunkSize
    chunks := make([]string, nChunks)
    for i := 0; i < nChunks; i++ {
        chunks[i] = s[i*chunkSize : (i+1)*chunkSize]
    }
    if remainder > 0 {
        chunks = append(chunks, s[nChunks*chunkSize:])
    }
    var sb strings.Builder
    for i := 0; i < nLines; i++ {
        j := i * cols
        sb.WriteString(" " + strings.Join(chunks[j:j+cols], " ") + "\n")
    }
    ss := " file\n" + sb.String()
    switch ft {
    case otp:
        return "# OTP" + ss
    case enc:
        return "# Encrypted" + ss
    default: // case dec:
        return "# Decrypted" + ss
    }
}

func menu() int {
    fmt.Println(`
1. Create one time pad file.

2. Delete one time pad file.

3. List one time pad files.

4. Encrypt plain text.

5. Decrypt cipher text.

6. Quit program.
`)
    choice := 0
    for choice < 1 || choice > 6 {
        fmt.Print("Your choice (1 to 6) : ")
        scnr.Scan()
        choice, _ = strconv.Atoi(scnr.Text())
        check(scnr.Err())
    }
    return choice
}

func main() {
    for {
        choice := menu()
        fmt.Println()
        switch choice {
        case 1: // Create OTP
            fmt.Println("Note that encrypted lines always contain 48 characters.\n")
            fmt.Print("OTP file name to create (without extension) : ")
            scnr.Scan()
            fileName := scnr.Text() + ".1tp"
            nLines := 0
            for nLines < 1 || nLines > 1000 {
                fmt.Print("Number of lines in OTP (max 1000) : ")
                scnr.Scan()
                nLines, _ = strconv.Atoi(scnr.Text())
            }
            check(scnr.Err())
            key := makePad(nLines)
            file, err := os.Create(fileName)
            check(err)
            _, err = file.WriteString(key)
            check(err)
            file.Close()
            fmt.Printf("\n'%s' has been created in the current directory.\n", fileName)
            if demo {
                // a copy of the OTP file would normally be on a different machine
                fileName2 := fileName + "_cpy" // copy for decryption
                file, err := os.Create(fileName2)
                check(err)
                _, err = file.WriteString(key)
                check(err)
                file.Close()
                fmt.Printf("'%s' has been created in the current directory.\n", fileName2)
                fmt.Println("\nThe contents of these files are :\n")
                fmt.Println(key)
            }
        case 2: // Delete OTP
            fmt.Println("Note that this will also delete ALL associated files.\n")
            fmt.Print("OTP file name to delete (without extension) : ")
            scnr.Scan()
            toDelete1 := scnr.Text() + ".1tp"
            check(scnr.Err())
            toDelete2 := toDelete1 + "_cpy"
            toDelete3 := toDelete1 + "_enc"
            toDelete4 := toDelete1 + "_dec"
            allToDelete := []string{toDelete1, toDelete2, toDelete3, toDelete4}
            deleted := 0
            fmt.Println()
            for _, name := range allToDelete {
                if _, err := os.Stat(name); !os.IsNotExist(err) {
                    err = os.Remove(name)
                    check(err)
                    deleted++
                    fmt.Printf("'%s' has been deleted from the current directory.\n", name)
                }
            }
            if deleted == 0 {
                fmt.Println("There are no files to delete.")
            }
        case 3: // List OTPs
            fmt.Println("The OTP (and related) files in the current directory are:\n")
            files, err := ioutil.ReadDir(".") // already sorted by file name
            check(err)
            for _, fi := range files {
                name := fi.Name()
                if !fi.IsDir() && isOtpRelated(name) {
                    fmt.Println(name)
                }
            }
        case 4: // Encrypt
            fmt.Print("OTP file name to use (without extension) : ")
            scnr.Scan()
            keyFile := scnr.Text() + ".1tp"
            if _, err := os.Stat(keyFile); !os.IsNotExist(err) {
                file, err := os.Open(keyFile)
                check(err)
                bytes, err := ioutil.ReadAll(file)
                check(err)
                file.Close()
                lines := strings.Split(string(bytes), "\n")
                le := len(lines)
                first := le
                for i := 0; i < le; i++ {
                    if strings.HasPrefix(lines[i], " ") {
                        first = i
                        break
                    }
                }
                if first == le {
                    fmt.Println("\nThat file has no unused lines.")
                    continue
                }
                lines2 := lines[first:] // get rid of comments and used lines

                fmt.Println("Text to encrypt :-\n")
                scnr.Scan()
                text := toAlpha(strings.ToUpper(scnr.Text()))
                check(scnr.Err())
                tl := len(text)
                nLines := tl / charsPerLine
                if tl%charsPerLine > 0 {
                    nLines++
                }
                if len(lines2) >= nLines {
                    key := toAlpha(strings.Join(lines2[0:nLines], ""))
                    encrypted := vigenere(text, key, true)
                    encFile := keyFile + "_enc"
                    file2, err := os.Create(encFile)
                    check(err)
                    _, err = file2.WriteString(encrypted)
                    check(err)
                    file2.Close()
                    fmt.Printf("\n'%s' has been created in the current directory.\n", encFile)
                    for i := first; i < first+nLines; i++ {
                        lines[i] = "-" + lines[i][1:]
                    }
                    file3, err := os.Create(keyFile)
                    check(err)
                    _, err = file3.WriteString(strings.Join(lines, "\n"))
                    check(err)
                    file3.Close()
                    if demo {
                        fmt.Println("\nThe contents of the encrypted file are :\n")
                        fmt.Println(encrypted)
                    }
                } else {
                    fmt.Println("Not enough lines left in that file to do encryption.")
                }
            } else {
                fmt.Println("\nThat file does not exist.")
            }
        case 5: // Decrypt
            fmt.Print("OTP file name to use (without extension) : ")
            scnr.Scan()
            keyFile := scnr.Text() + ".1tp_cpy"
            check(scnr.Err())
            if _, err := os.Stat(keyFile); !os.IsNotExist(err) {
                file, err := os.Open(keyFile)
                check(err)
                bytes, err := ioutil.ReadAll(file)
                check(err)
                file.Close()
                keyLines := strings.Split(string(bytes), "\n")
                le := len(keyLines)
                first := le
                for i := 0; i < le; i++ {
                    if strings.HasPrefix(keyLines[i], " ") {
                        first = i
                        break
                    }
                }
                if first == le {
                    fmt.Println("\nThat file has no unused lines.")
                    continue
                }
                keyLines2 := keyLines[first:] // get rid of comments and used lines

                encFile := keyFile[0:len(keyFile)-3] + "enc"
                if _, err := os.Stat(encFile); !os.IsNotExist(err) {
                    file2, err := os.Open(encFile)
                    check(err)
                    bytes, err := ioutil.ReadAll(file2)
                    check(err)
                    file2.Close()
                    encLines := strings.Split(string(bytes), "\n")[1:] // exclude comment line
                    nLines := len(encLines)
                    if len(keyLines2) >= nLines {
                        encrypted := toAlpha(strings.Join(encLines, ""))
                        key := toAlpha(strings.Join(keyLines2[0:nLines], ""))
                        decrypted := vigenere(encrypted, key, false)
                        decFile := keyFile[0:len(keyFile)-3] + "dec"
                        file3, err := os.Create(decFile)
                        check(err)
                        _, err = file3.WriteString(decrypted)
                        check(err)
                        file3.Close()
                        fmt.Printf("\n'%s' has been created in the current directory.\n", decFile)
                        for i := first; i < first+nLines; i++ {
                            keyLines[i] = "-" + keyLines[i][1:]
                        }
                        file4, err := os.Create(keyFile)
                        check(err)
                        _, err = file4.WriteString(strings.Join(keyLines, "\n"))
                        check(err)
                        file4.Close()
                        if demo {
                            fmt.Println("\nThe contents of the decrypted file are :\n")
                            fmt.Println(decrypted)
                        }
                    }
                } else {
                    fmt.Println("Not enough lines left in that file to do decryption.")
                }
            } else {
                fmt.Println("\nThat file does not exist.")
            }
        case 6: // Quit program
            return
        }
    }
}
