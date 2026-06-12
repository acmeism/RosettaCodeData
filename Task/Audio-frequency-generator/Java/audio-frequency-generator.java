import java.awt.Color;
import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.GridLayout;
import java.text.NumberFormat;

import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.SourceDataLine;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFormattedTextField;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.border.TitledBorder;

public final class AudioFrequencyGenerator extends JPanel {

    public static void main(String[] aArgs) {
        EventQueue.invokeLater( () -> {
            JFrame.setDefaultLookAndFeelDecorated(true);
            JFrame frame = new JFrame("Audio Frequency Generator");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.add( new AudioFrequencyGenerator() );
            frame.setLocationByPlatform(true);
            frame.pack();
            frame.setResizable(false);
            frame.setVisible(true);
        } );
    }

    private AudioFrequencyGenerator() {
        setLayout( new GridLayout(5, 1) );
        setPreferredSize( new Dimension(300, 200) );
        setBackground(Color.WHITE);
        setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        String[] waveTypes = new String[] { "Sawtooth Wave", "Sine Wave", "Square Wave", "Triangular Wave" };
        JComboBox<String> waveChoice = new JComboBox<String>(waveTypes);
        waveChoice.setSelectedItem("Sine Wave");
        add(waveChoice);

        JTextField volumeField = addJTextField(this, "Volume %: 0 - 100", "20");
        JTextField durationField = addJTextField(this, "Duration in milliseconds: 0 - 2,000", "1000");
        JTextField frequencyField = addJTextField(this, "Frequency in Hertz: 200 - 2,000", "441");

        JButton generateToneButton = new JButton("Generate Tone");
        generateToneButton.setFocusable(false);
        generateToneButton.addActionListener( event -> {
            Tone tone = tone(frequencyField.getText(), durationField.getText(),
                             volumeField.getText(), waveChoice.getSelectedItem());
            if ( tone.isValid ) {
                try {
                    generateTone(tone.hertz, tone.duration(), tone.volume(), tone.wave);
                } catch (LineUnavailableException lue) {
                    lue.printStackTrace();
                }
            }
        } );
        add(generateToneButton);
    }

    private static void generateTone(int hertz, int duration, int volume, String wave)
            throws LineUnavailableException {
        final float sampleRate = 44_100.0F;

        byte[] buffer = new byte[1];
        AudioFormat audioFormat = new AudioFormat(sampleRate, 8, 1, true, false);
        // sample rate, sample size in bits, number of channels, signed, bigendian

        SourceDataLine sourceDataLine = AudioSystem.getSourceDataLine(audioFormat);
        sourceDataLine = AudioSystem.getSourceDataLine(audioFormat);
        sourceDataLine.open(audioFormat);
        sourceDataLine.start();

        for ( int i = 0; i < duration * sampleRate / 1_000; i++ ) {
            final double proportion = ( i / sampleRate ) * hertz;
            switch ( wave ) {
                case "Sawtooth Wave" -> {
                    final double t = i % proportion;
                    buffer[0] = (byte) ( 2 * ( t - Math.floor(0.5 + t) ) * volume );
                }
                case "Sine Wave" -> buffer[0] = (byte) ( Math.sin(proportion * 2.0 * Math.PI) * volume );
                case "Square Wave" -> buffer[0] = (byte) Math.signum(Math.sin(proportion * 2.0 * Math.PI) * volume);
                case "Triangular Wave" -> {
                    final double t = i % proportion;
                    buffer[0] = (byte) ( 2 * Math.abs(2 * ( t - Math.floor(0.5 + t)) - 1 ) * volume );
                }
            }
            sourceDataLine.write(buffer, 0, 1); // byte array, offset, byte array length
        }

        sourceDataLine.drain();
        sourceDataLine.stop();
        sourceDataLine.close();
    }

    private static JFormattedTextField addJTextField(JPanel panel, String title, String initialValue) {
        NumberFormat numberFormat = NumberFormat.getIntegerInstance();
        JFormattedTextField textField = new JFormattedTextField(numberFormat);
        textField.setBorder( new TitledBorder(title) );
        textField.setText(initialValue);
        panel.add(textField);
        return textField;
    }

    private static Tone tone(String frequency, String length, String level, Object oscillation) {
        final int hertz = Integer.valueOf(frequency);
        final int duration = Integer.valueOf(length);
        final int volume = Integer.valueOf(level);
        if ( hertz >= 200 && hertz <= 2_000 && duration >= 0 && duration <= 2_000
            && volume >= 0 && volume <= 100 ) {
            return new Tone(true, hertz, duration, volume, (String) oscillation);
        }
        return new Tone(false, 0, 0, 0, "");
    }

    private static record Tone(boolean isValid, int hertz, int duration, int volume, String wave) {}

}
