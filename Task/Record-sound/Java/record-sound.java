import java.io.IOException;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.io.File;

import javax.sound.sampled.AudioFileFormat.*;

public final class SoundRecorder {

    public static void main(String[] args) {
    	SoundRecorder recorder = new SoundRecorder();

        ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();
        scheduler.schedule( () -> recorder.finish(), 10, TimeUnit.SECONDS);
        scheduler.shutdown();

        recorder.start();
    }

    private void start() {
        try {
            AudioFormat format = createAudioFormat();
            DataLine.Info info = new DataLine.Info(TargetDataLine.class, format);

            if ( ! AudioSystem.isLineSupported(info) ) {
                System.out.println("Data line format is not supported");
                Runtime.getRuntime().exit(0);
            }

            line = (TargetDataLine) AudioSystem.getLine(info);
            line.open(format);
            line.start();

            System.out.println("Starting to capture and record audio");
            AudioInputStream audioInputStream = new AudioInputStream(line);
            AudioSystem.write(audioInputStream, audioFileType, wavFile);

        } catch (LineUnavailableException | IOException exception) {
            exception.printStackTrace(System.err);
        }
    }

    private AudioFormat createAudioFormat() {
        final float sampleRate = 16_000.0F;
        final int sampleSizeInBits = 16;
        final int channels = 1;
        final boolean signed = true;
        final boolean bigEndian = true;
        // Monophonic 16-bit PCM audio format
        return new AudioFormat(sampleRate, sampleSizeInBits, channels, signed, bigEndian);
    }

    private void finish() {
        line.stop();
        line.close();
        System.out.println("Finished capturing and recording audio");
    }

    private TargetDataLine line;

    private final File wavFile = new File("SoundRecorder.wav");
    private final AudioFileFormat.Type audioFileType = AudioFileFormat.Type.WAVE;

}
