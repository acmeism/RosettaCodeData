import "os" for Process
import "./ioutil" for Input

var name = Input.text("Enter output file name (without extension) : ", 1, 80)
name = name + ".wav"

var rate = Input.integer("Enter sampling rate in Hz (2000 to 192000) : ", 2000, 192000)
var rateS = rate.toString

var dur = Input.number("Enter duration in seconds (5 to 30)        : ", 5, 30)
var durS = dur.toString

System.print("\nOK, start speaking now...")
// Default arguments: -c 1, -t wav. Note only signed 16 bit format supported.
var args = ["-r", rateS, "-f", "S16_LE", "-d", durS, name]
Process.exec("arecord", args)

System.print("\n'%(name)' created on disk and will now be played back...")
Process.exec("aplay %(name)")
System.print("\nPlay-back completed.")
