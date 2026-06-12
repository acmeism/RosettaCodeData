// base64 encoding
// A port, with slight variations, of the C version found here:
// http://rosettacode.org/wiki/Base64#C (manual implementation)
//
// go build ; cat favicon.ico | ./base64

package main

import (
  "bytes"
  "fmt"
  "io/ioutil"
  "log"
  "os"
  "strings"
)

const (
  B64_CHUNK_SIZE = 76
)

type UL int64

// Our lookup table.
var alpha string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

// Base64 encode a raw byte stream.
func B64Encode(raw []byte) (string, error) {
  var buffer strings.Builder
  var reader *bytes.Reader
  var u UL // w UL
  var length int
  var chunk []byte
  var err error

  length = 3
  reader = bytes.NewReader(raw)
  chunk = make([]byte, 3)

  for length == 3 {

    chunk[1] = 0
    chunk[2] = 0

    length, err = reader.Read(chunk)
    if err != nil || len(chunk) == 0 {
      break
    }

    u = UL(chunk[0])<<16 | UL(chunk[1])<<8 | UL(chunk[2])

    buffer.WriteString(string(alpha[u>>18]))
    buffer.WriteString(string(alpha[u>>12&63]))
    if length < 2 {
      buffer.WriteString("=")
    } else {
      buffer.WriteString(string(alpha[u>>6&63]))
    }

    if length < 3 {
      buffer.WriteString("=")
    } else {
      buffer.WriteString(string(alpha[u&63]))
    }
  }

  return buffer.String(), nil
}

// Prettifies the base64 result by interspersing \n chars every B64_CHUNK_SIZE bytes.
// Even though there's a performance hit, i'd rather compose these.
func B64EncodePretty(raw []byte) (string, error) {
  var buffer strings.Builder
  encoded, err := B64Encode(raw)
  if err != nil {
    return "", err
  }
  length := len(encoded)
  chunks := int(length/B64_CHUNK_SIZE) + 1
  for i := 0; i < chunks; i++ {
    chunk := i * B64_CHUNK_SIZE
    end := chunk + B64_CHUNK_SIZE
    if end > length {
      end = chunk + (length - chunk)
    }
    buffer.WriteString(encoded[chunk:end] + "\n")
  }
  return buffer.String(), err
}

func main() {
  contents, err := ioutil.ReadAll(os.Stdin)
  if err != nil {
    log.Fatal("Error reading input: ", err)
  }
  encoded, err := B64EncodePretty(contents)
  if err != nil {
    log.Fatal("Error base64 encoding the input: ", err)
  }
  fmt.Printf("%s", encoded)
}
