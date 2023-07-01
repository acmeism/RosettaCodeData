package main

import (
    "log"
    "github.com/jtblin/go-ldap-client"
)

func main() {
    client := &ldap.LDAPClient{
        Base:        "dc=example,dc=com",
        Host:        "ldap.example.com",
        Port:        389,
        GroupFilter: "(memberUid=%s)",
    }
    defer client.Close()
    err := client.Connect()
    if err != nil {
        log.Fatalf("Failed to connect : %+v", err)
    }
    groups, err := client.GetGroupsOfUser("username")
    if err != nil {
        log.Fatalf("Error getting groups for user %s: %+v", "username", err)
    }
    log.Printf("Groups: %+v", groups)
}
