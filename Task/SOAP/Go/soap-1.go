package main

import (
    "fmt"
    "github.com/tiaguinho/gosoap"
    "log"
)

type CheckVatResponse struct {
    CountryCode string `xml:"countryCode"`
    VatNumber   string `xml:"vatNumber"`
    RequestDate string `xml:"requestDate"`
    Valid       string `xml:"valid"`
    Name        string `xml:"name"`
    Address     string `xml:"address"`
}

var (
    rv CheckVatResponse
)

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func main() {
    // create SOAP client
    soap, err := gosoap.SoapClient("http://ec.europa.eu/taxation_customs/vies/checkVatService.wsdl")

    // map parameter names to values
    params := gosoap.Params{
        "vatNumber":   "6388047V",
        "countryCode": "IE",
    }

    // call 'checkVat' function
    err = soap.Call("checkVat", params)
    check(err)

    // unmarshal response to 'rv'
    err = soap.Unmarshal(&rv)
    check(err)

    // print response
    fmt.Println("Country Code  : ", rv.CountryCode)
    fmt.Println("Vat Number    : ", rv.VatNumber)
    fmt.Println("Request Date  : ", rv.RequestDate)
    fmt.Println("Valid         : ", rv.Valid)
    fmt.Println("Name          : ", rv.Name)
    fmt.Println("Address       : ", rv.Address)
}
