package main
// first run" go get github.com/zserge/webview"
// simple GUI "window"
import "github.com/zserge/webview"

func main() {
	// Open wikipedia in a 320*240 resizable window
	webview.Open("Minimal webview example",
		"https://en.m.wikipedia.org/wiki/Main_Page", 320, 240, true)
}
