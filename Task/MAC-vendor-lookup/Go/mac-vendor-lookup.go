package main

import (
	"net/http"
	"fmt"
	"io/ioutil"
)

func macLookUp(mac string) (res string){
	resp, _ := http.Get("http://api.macvendors.com/" + mac)
	body, _ := ioutil.ReadAll(resp.Body)
	res = string(body)
	return
}

func main()  {
	fmt.Println(macLookUp("FC-A1-3E"))
	fmt.Println(macLookUp("FC:FB:FB:01:FA:21"))
	fmt.Println(macLookUp("BC:5F:F4"))
}
