package main

import (
	"golang.org/x/net/websocket"
	"flag"
	"fmt"
	"html/template"
	"io"
	"math"
	"net/http"
	"time"
)

var (
	Portnum  string
	Hostsite string
)

type PageSettings struct {
	Host string
	Port string
}

const (
	Canvaswidth  = 512
	Canvasheight = 512
	//color constants
	HourColor   = "#ff7373" // pinkish
	MinuteColor = "#00b7e4" //light blue
	SecondColor = "#b58900" //gold
)

func main() {
	flag.StringVar(&Portnum, "Port", "1234", "Port to host server.")
	flag.StringVar(&Hostsite, "Site", "localhost", "Site hosting server")
	flag.Parse()
	http.HandleFunc("/", webhandler)
	http.Handle("/ws", websocket.Handler(wshandle))
	err := http.ListenAndServe(Hostsite+":"+Portnum, nil)
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println("server running")
}

func webhandler(w http.ResponseWriter, r *http.Request) {
	wsurl := PageSettings{Host: Hostsite, Port: Portnum}
	template, _ := template.ParseFiles("clock.html")
	template.Execute(w, wsurl)
}

//Given a websocket connection,
//serves updating time function
func wshandle(ws *websocket.Conn) {
	for {
		hour, min, sec := time.Now().Clock()
		hourx, houry := HourCords(hour, Canvasheight/2)
		minx, miny := MinSecCords(min, Canvasheight/2)
		secx, secy := MinSecCords(sec, Canvasheight/2)
		msg := "CLEAR\n"
		msg += fmt.Sprintf("HOUR %d %d %s\n", hourx, houry, HourColor)
		msg += fmt.Sprintf("MIN %d %d %s\n", minx, miny, MinuteColor)
		msg += fmt.Sprintf("SEC %d %d %s", secx, secy, SecondColor)
		io.WriteString(ws, msg)
		time.Sleep(time.Second / 60.0)
	}
}

//Given current minute or second time(i.e 30 min, 60 minutes)
//and the radius, returns pair of cords to draw line to
func MinSecCords(ctime int, radius int) (int, int) {
	//converts min/sec to angle and then to radians

	theta := ((float64(ctime)*6 - 90) * (math.Pi / 180))
	x := float64(radius) * math.Cos(theta)
	y := float64(radius) * math.Sin(theta)
	return int(x) + 256, int(y) + 256
}

//Given current hour time(i.e. 12, 8) and the radius,
//returns pair of cords to draw line to
func HourCords(ctime int, radius int) (int, int) {
	//converts hours to angle and then to radians
	theta := ((float64(ctime)*30 - 90) * (math.Pi / 180))
	x := float64(radius) * math.Cos(theta)
	y := float64(radius) * math.Sin(theta)
	return int(x) + 256, int(y) + 256
}
