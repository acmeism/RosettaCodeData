import "dome" for Window, Process, Platform
import "graphics" for Canvas, Color
import "audio" for AudioEngine

var StartTime = Platform.time

class AudioAlarm {
    construct new() {
        Window.title = "Audio alarm"
    }

    init() {
        var args = Process.args
        if (args.count != 4) {
            System.print("Two arguments should be passed at the command line, viz:")
            System.print("  dome audio_alarm.wren <seconds to wait> <wav filename without extension>")
            System.print("Exiting DOME")
            Process.exit()
        }
        _secs = Num.fromString(args[2])
        _wav = args[3] + ".wav"
        Canvas.print("Alarm will sound in %(_secs) seconds...", 10, 10, Color.white)
        AudioEngine.load("alarm", _wav)
        _alarmed = true
    }

    update() {
        var currTime = Platform.time
        if (_alarmed && (currTime >= StartTime + _secs)) {
            AudioEngine.play("alarm")
            _alarmed = false
            Canvas.cls()
            Canvas.print("Alarm has sounded", 10, 10, Color.white)
        }
    }

    draw(alpha) {}
}

var Game = AudioAlarm.new()
