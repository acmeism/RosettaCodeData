import com.sun.javafx.application.PlatformImpl;
import java.io.File;
import java.util.Scanner;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;
import javafx.scene.media.Media;
import javafx.scene.media.MediaPlayer;

public class AudioAlarm {

    public static void main(String[] args) throws InterruptedException {
        Scanner input = new Scanner(System.in);

        System.out.print("Enter a number of seconds: ");
        int seconds = Integer.parseInt(input.nextLine());

        System.out.print("Enter a filename (must end with .mp3 or .wav): ");
        String audio = input.nextLine();

        TimeUnit.SECONDS.sleep(seconds);

        Media media = new Media(new File(audio).toURI().toString());
        AtomicBoolean stop = new AtomicBoolean();
        Runnable onEnd = () -> stop.set(true);

        PlatformImpl.startup(() -> {}); // To initialize the MediaPlayer.

        MediaPlayer player = new MediaPlayer(media);
        player.setOnEndOfMedia(onEnd);
        player.setOnError(onEnd);
        player.setOnHalted(onEnd);
        player.play();

        while (!stop.get()) {
            Thread.sleep(100);
        }
        System.exit(0); // To stop the JavaFX thread.
    }
}
