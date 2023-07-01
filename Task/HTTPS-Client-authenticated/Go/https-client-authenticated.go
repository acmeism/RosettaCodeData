package main

import (
	"crypto/tls"
	"io/ioutil"
	"log"
	"net/http"
)

func main() {

	// load key pair
	cert, err := tls.LoadX509KeyPair(
		"./client.local.tld/client.local.tld.crt",
		"./client.local.tld/client.local.tld.key",
	)

	if err != nil {
		log.Fatal("Error while loading x509 key pair", err)
	}

	// Create TLS Config in order to had client certificate
	tlsConfig := &tls.Config{Certificates: []tls.Certificate{cert}}

	tlsConfig.BuildNameToCertificate()
	transport := &http.Transport{TLSClientConfig: tlsConfig}

	// create http client with our custom transport with TLS config
	client := &http.Client{Transport: transport}

	res, err := client.Get("https://www.example.com/")
	if err != nil {
		log.Fatal(err)
	}
	contents, err := ioutil.ReadAll(res.Body)
	log.Print(string(contents))

}
