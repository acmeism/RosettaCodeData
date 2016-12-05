import AVFoundation

// This example uses AVAudioPlayer for playback.
// AVAudioPlayer is the player Apple recommends for playback, since it suitable for songs
// and offers control over numerous playback parameters.
// It can play any type that is natively supported by OSX or iOS

class PlayerControl: NSObject, AVAudioPlayerDelegate {
    let player1:AVAudioPlayer!
    let player2:AVAudioPlayer!
    var playedBoth = false
    var volume:Float {
        get {
            return player1.volume
        }

        set {
            player1.volume = newValue
            player2.volume = newValue
        }
    }

    init(player1:AVAudioPlayer, player2:AVAudioPlayer) {
        super.init()
        self.player1 = player1
        self.player2 = player2
        self.player1.delegate = self
        self.player2.delegate = self
    }

    func loop() {
        player1.numberOfLoops = 1
        player1.play()

        let time = Int64((Double(player1.duration) + 2.0) * Double(NSEC_PER_SEC))

        dispatch_after(dispatch_time(0, time), dispatch_get_main_queue()) {[weak self] in
            println("Stopping track")
            self?.player1.stop()
            exit(0)
        }
    }

    func playBoth() {
        player1.play()
        player2.play()
    }

    func audioPlayerDidFinishPlaying(player:AVAudioPlayer!, successfully flag:Bool) {
        if player === player2 && !playedBoth {
            playBoth()
            playedBoth = true
        } else if player === player2 && playedBoth {
            loop()
        }
    }
}

let url1 = NSURL(string: "file:///file1.mp3")
let url2 = NSURL(string: "file:///file2.mp3")

var err:NSError?
let player1 = AVAudioPlayer(contentsOfURL: url1, error: &err)
let player2 = AVAudioPlayer(contentsOfURL: url2, error: &err)

let player = PlayerControl(player1: player1, player2: player2)

// Setting the volume
player.volume = 0.5

// Play track 2
// When this track finishes it will play both of them
// by calling the audioPlayerDidFinishPlaying delegate method
// Once both tracks finish playing, it will then loop the first track twice
// stopping the track after 2 seconds of the second play
player.player2.play()

CFRunLoopRun()
