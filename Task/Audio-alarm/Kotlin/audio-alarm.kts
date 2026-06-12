// version 1.1.51

import javafx.application.Application
import javafx.scene.media.Media
import javafx.scene.media.MediaPlayer
import javafx.stage.Stage
import java.io.File
import java.util.concurrent.TimeUnit

class AudioAlarm : Application() {

    override fun start(primaryStage: Stage) {
        with (primaryStage) {
            title = "Audio Alarm"
            width = 400.0
            height= 400.0
            show()
        }
        TimeUnit.SECONDS.sleep(seconds)
        soundAlarm()
    }

    private fun soundAlarm() {
        val source = File(fileName).toURI().toString()
        val media = Media(source)
        val mediaPlayer = MediaPlayer(media)
        mediaPlayer.play()
    }

    companion object {
        fun create(seconds: Long, fileName: String) {
            AudioAlarm.seconds = seconds
            AudioAlarm.fileName = fileName
            Application.launch(AudioAlarm::class.java)
        }

        private var seconds = 0L
        private var fileName = ""
    }
}

fun main(args: Array<String>) {
    print("Enter number of seconds to wait for alarm to sound : ")
    val seconds = readLine()!!.toLong()
    print("Enter name of MP3 file (without the extension) to sound alarm : ")
    val fileName = readLine()!! + ".mp3"
    AudioAlarm.create(seconds, fileName)
}
