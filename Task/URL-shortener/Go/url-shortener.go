// shortener.go
package main

import (
    "encoding/json"
    "fmt"
    "io/ioutil"
    "log"
    "math/rand"
    "net/http"
    "time"
)

const (
    chars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    host  = "localhost:8000"
)

type database map[string]string

type shortener struct {
    Long string `json:"long"`
}

func (db database) ServeHTTP(w http.ResponseWriter, req *http.Request) {
    switch req.Method {
    case http.MethodPost: // "POST"
        body, err := ioutil.ReadAll(req.Body)
        if err != nil {
            w.WriteHeader(http.StatusBadRequest) // 400
            return
        }
        var sh shortener
        err = json.Unmarshal(body, &sh)
        if err != nil {
            w.WriteHeader(http.StatusUnprocessableEntity) // 422
            return
        }
        short := generateKey(8)
        db[short] = sh.Long
        fmt.Fprintf(w, "The shortened URL: http://%s/%s\n", host, short)
    case http.MethodGet: // "GET"
        path := req.URL.Path[1:]
        if v, ok := db[path]; ok {
            http.Redirect(w, req, v, http.StatusFound) // 302
        } else {
            w.WriteHeader(http.StatusNotFound) // 404
            fmt.Fprintf(w, "No such shortened url: http://%s/%s\n", host, path)
        }
    default:
        w.WriteHeader(http.StatusNotFound) // 404
        fmt.Fprintf(w, "Unsupprted method: %s\n", req.Method)
    }
}

func generateKey(size int) string {
    key := make([]byte, size)
    le := len(chars)
    for i := 0; i < size; i++ {
        key[i] = chars[rand.Intn(le)]
    }
    return string(key)
}

func main() {
    rand.Seed(time.Now().UnixNano())
    db := make(database)
    log.Fatal(http.ListenAndServe(host, db))
}
