package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"net/url"
	"os"
	"strings"
	"time"
)

var key string

func init() {
	// Read an API key from the specified file.
	// See www.meetup.com/meetup_api/auth for other ways to authenticate.
	const keyFile = "api_key.txt"
	f, err := os.Open(keyFile)
	if err != nil {
		log.Fatal(err)
	}
	keydata, err := ioutil.ReadAll(f)
	if err != nil {
		log.Fatal(err)
	}
	key = strings.TrimSpace(string(keydata))
}

type EventResponse struct {
	Results []Result
	// … other fields …
}

type Result struct {
	ID          string
	Status      string
	Name        string
	EventURL    string `json:"event_url"`
	Description string
	Time        EventTime
	// … other fields …
}

// EventTime is a time.Time that will be marshalled/unmarshalled to/from JSON
// as a UTC time in milliseconds since the epoch as returned by the Meetup API.
type EventTime struct{ time.Time }

func (et *EventTime) UnmarshalJSON(data []byte) error {
	var msec int64
	if err := json.Unmarshal(data, &msec); err != nil {
		return err
	}
	et.Time = time.Unix(0, msec*int64(time.Millisecond))
	return nil
}

func (et EventTime) MarshalJSON() ([]byte, error) {
	msec := et.UnixNano() / int64(time.Millisecond)
	return json.Marshal(msec)
}

// String formats a Result suitable for debugging output.
func (r *Result) String() string {
	var b bytes.Buffer
	fmt.Fprintln(&b, "ID:", r.ID)
	fmt.Fprintln(&b, "URL:", r.EventURL)
	fmt.Fprintln(&b, "Time:", r.Time.Format(time.UnixDate))
	d := r.Description
	const limit = 65
	if len(d) > limit {
		d = d[:limit-1] + "…"
	}
	fmt.Fprintln(&b, "Description:", d)
	return b.String()
}

func main() {
	v := url.Values{
		//"topic": []string{"tech"},
		//"city":  []string{"Barcelona"},
		"topic": []string{"photo"},
		"time":  []string{",1w"},
		"key":   []string{key},
	}
	u := url.URL{
		Scheme:   "http",
		Host:     "api.meetup.com",
		Path:     "2/open_events.json",
		RawQuery: v.Encode(),
	}
	//log.Println("API URL:", u.String())

	resp, err := http.Get(u.String())
	if err != nil {
		log.Fatal(err)
	}
	defer resp.Body.Close()
	log.Println("HTTP Status:", resp.Status)

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatal(err)
	}

	//log.Printf("Body: %q\n", body)
	var buf bytes.Buffer
	if err = json.Indent(&buf, body, "", "  "); err != nil {
		log.Fatal(err)
	}
	//log.Println("Indented:", buf.String())

	var evresp EventResponse
	json.Unmarshal(body, &evresp)
	//log.Printf("%#v\n", evresp)

	fmt.Println("Got", len(evresp.Results), "events")
	if len(evresp.Results) > 0 {
		fmt.Println("First event:\n", &evresp.Results[0])
	}
}
