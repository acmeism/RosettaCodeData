// prints the first few members of the Thue-Morse sequence

package main

import (
    "fmt"
    "bytes"
)

// sets tmBuffer to the next member of the Thue-Morse sequence
// tmBuffer must contain a valid Thue-Morse sequence member before the call
func nextTMSequenceMember( tmBuffer * bytes.Buffer ) {
    // "flip" the bytes, adding them to the buffer
    for b, currLength, currBytes := 0, tmBuffer.Len(), tmBuffer.Bytes() ; b < currLength; b ++ {
        if currBytes[ b ] == '1' {
            tmBuffer.WriteByte( '0' )
        } else {
            tmBuffer.WriteByte( '1' )
        }
    }
}

func main() {
    var tmBuffer bytes.Buffer
    // initial sequence member is "0"
    tmBuffer.WriteByte( '0' )
    fmt.Println( tmBuffer.String() )
    for i := 2; i <= 7; i ++ {
        nextTMSequenceMember( & tmBuffer )
        fmt.Println( tmBuffer.String() )
    }
}
