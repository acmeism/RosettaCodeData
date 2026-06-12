#!/bin/bash
sed -n -e '12,$p' < "$0" > ttmmpp.go
go build ttmmpp.go
rm ttmmpp.go
binfile="${0%.*}"
mv ttmmpp $binfile
$binfile "$@"
STATUS=$?
rm $binfile
exit $STATUS
######## Go Code start on line 12
package main
import (
  "fmt"
  "os"
)

func main() {
  for i, x := range os.Args {
    if i == 0 {
      fmt.Printf("This program is named %s.\n", x)
    } else {
      fmt.Printf("the argument #%d is %s\n", i, x)
    }
  }
}
