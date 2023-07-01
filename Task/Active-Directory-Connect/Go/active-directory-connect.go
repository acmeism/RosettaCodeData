package main

import (
    "log"
    "github.com/jtblin/go-ldap-client"
)

func main() {
    client := &ldap.LDAPClient{
        Base:         "dc=example,dc=com",
        Host:         "ldap.example.com",
        Port:         389,
        UseSSL:       false,
        BindDN:       "uid=readonlyuser,ou=People,dc=example,dc=com",
        BindPassword: "readonlypassword",
        UserFilter:   "(uid=%s)",
        GroupFilter:  "(memberUid=%s)",
        Attributes:   []string{"givenName", "sn", "mail", "uid"},
    }
    defer client.Close()
    err := client.Connect()
    if err != nil {
        log.Fatalf("Failed to connect : %+v", err)
    }
    // Do something
}
