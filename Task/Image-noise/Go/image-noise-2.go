package main

/* Note, the x-go-binding/ui/x11 lib is under development and has as a temp solution
   set the x window to a static height and with, you have to manualy set these
   to 240 x 320 in code.google.com/p/x-go-binding/ui/x11/conn.go */

import "code.google.com/p/x-go-binding/ui"
import "code.google.com/p/x-go-binding/ui/x11"
import "fmt"
import "image"
import "image/draw"
import "log"
import "math/rand"
import "runtime"
import "time"

var bw[65536][64]byte
var frameCount = make(chan uint)

func main() {
   tc := runtime.NumCPU()
   runtime.GOMAXPROCS(tc)

   // Initiate a new x11 screen to print images onto
   win, err := x11.NewWindow()
   if err != nil {
      log.Fatalln(err)
   }
   defer win.Close()
   screen := win.Screen()
   _, ok := screen.(*image.RGBA)
   if !ok {
      log.Fatalln("screen isn't an RGBA image.")
   }

   //Create lookup table for every combination of 16 black/white pixels
   var i, j uint
   for i = 0; i< 65536; i++ {
      for j = 0; j < 16; j++ {
      if i & (1 << j) > 0 {
            bw[i][j*4 + 0] = 0xFF
            bw[i][j*4 + 1] = 0xFF
            bw[i][j*4 + 2] = 0xFF
         }
      }
   }
   // Start fps counter in a new goroutin
   go fps()
   // Start goroutines
   for i := 0; i < tc; i++ {
       go createNoise(win, screen)
   }
   createNoise(win, screen)
}

func createNoise(win ui.Window, screen draw.Image) {
   var rnd, rnd2 uint64
   var rnd16a, rnd16b, rnd16c, rnd16d uint16
   var img [240 * 320 * 4]byte
   // Populate the image with pixel data
   for {
      for i := 0; i < len(img); i += 256 {
         rnd = uint64(rand.Int63())
         if (i % 63) == 0 {
            rnd2 = uint64(rand.Int63())
         }
         rnd |= rnd2 & 1 << 63 // we have to set the 64'th bit from the rand.Int63() manualy
         rnd16a = uint16( rnd        & 0x000000000000FFFF)
         rnd16b = uint16((rnd >> 16) & 0x000000000000FFFF)
         rnd16c = uint16((rnd >> 32) & 0x000000000000FFFF)
         rnd16d = uint16((rnd >> 48) & 0x000000000000FFFF)
         copy(img[i    :i+ 64], bw[rnd16a][:])
         copy(img[i+ 64:i+128], bw[rnd16b][:])
         copy(img[i+128:i+192], bw[rnd16c][:])
         copy(img[i+192:i+256], bw[rnd16d][:])
         rnd2 = rnd2 >> 1 // rotate to next random bit
      }
      // Copy pixel data to the screen
      copy(screen.(*image.RGBA).Pix, img[:])
      frameCount <- 1
      win.FlushImage()
   }
}

func fps() {
   last := time.Now()
   var fps uint
   for {
      // wait for a frameCount update
      <-frameCount
      fps++
      if time.Since(last) >= time.Second {
         fmt.Println("fps:", fps)
         fps = 0
         last = time.Now()
      }
   }
}
