import "audio" for AudioEngine
import "dome" for Process

class Game {
    static init() {
        // load a .wav file and give it a friendly name
        AudioEngine.load("a", "a.wav")
        // play the file at volume v, looping l and pan p
        __v = 2      // twice 'normal' volume
        __l = true   // loop when finished
        __p = 0.5    // division between left and right audio channels (-1 to +1)
        __chan1 = AudioEngine.play("a", __v, __l, __p)
        __fc = 0     // frame counter, updates at 60 fps
    }

    static update() { __fc = __fc + 1 }

    static draw(dt) {
        if (__fc == 600) {
            // after 10 seconds load and play a second .wav file simultaneously, same settings
            AudioEngine.load("b", "b.wav")
            __chan2 = AudioEngine.play("b", __v, __l, __p)
        }
        if (__fc == 1200) {
            __chan1.stop()   // after a further 10 seconds, stop the first file
            AudioEngine.unload("a")  // and unload it
        } else if (__fc == 1800) {
            __chan2.stop() // after another 10 seconds, stop the second file
            AudioEngine.unload("b")  // and unload it
            Process.exit(0)  // exit the application
        }
    }
}
