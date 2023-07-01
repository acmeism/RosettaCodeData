package main

import (
    "crypto/tls"
    "crypto/x509"
    "fmt"
    "io/ioutil"
    "log"
    "net/http"
)

const (
    userid   = "rosetta"
    password = "code"
)

func main() {
    // Use custom certificate for testing.  Not exactly required by task.
    b, err := ioutil.ReadFile("cert.pem")
    if err != nil {
        log.Fatal(err)
    }
    pool := x509.NewCertPool()
    if ok := pool.AppendCertsFromPEM(b); !ok {
        log.Fatal("Failed to append cert")
    }
    tc := &tls.Config{RootCAs: pool}
    tr := &http.Transport{TLSClientConfig: tc}
    client := &http.Client{Transport: tr}
    req, err := http.NewRequest("GET", "https://127.0.0.1:8080", nil)
    if err != nil {
        log.Fatal(err)
    }

    // This one line implements the authentication required for the task.
    req.SetBasicAuth(userid, password)

    // Make request and show output.
    resp, err := client.Do(req)
    if err != nil {
        log.Fatal(err)
    }
    b, err = ioutil.ReadAll(resp.Body)
    resp.Body.Close()
    if err != nil {
        log.Fatal(err)
    }
    fmt.Println(string(b))
}
