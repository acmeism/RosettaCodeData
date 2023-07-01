package main

import (
    "encoding/base64"
    "io"
    "log"
    "net/http"
    "strings"
)

const userPass = "rosetta:code"
const unauth = http.StatusUnauthorized

func hw(w http.ResponseWriter, req *http.Request) {
    auth := req.Header.Get("Authorization")
    if !strings.HasPrefix(auth, "Basic ") {
        log.Print("Invalid authorization:", auth)
        http.Error(w, http.StatusText(unauth), unauth)
        return
    }
    up, err := base64.StdEncoding.DecodeString(auth[6:])
    if err != nil {
        log.Print("authorization decode error:", err)
        http.Error(w, http.StatusText(unauth), unauth)
        return
    }
    if string(up) != userPass {
        log.Print("invalid username:password:", string(up))
        http.Error(w, http.StatusText(unauth), unauth)
        return
    }
    io.WriteString(w, "Goodbye, World!")
}

func main() {
    http.HandleFunc("/", hw)
    log.Fatal(http.ListenAndServeTLS(":8080", "cert.pem", "key.pem", nil))
}
