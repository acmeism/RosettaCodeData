import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

public class PPMWriter {

    public void bitmapToPPM(File file, BasicBitmapStorage bitmap) throws IOException {
        file.delete();

        try (var os = new FileOutputStream(file, true);
             var bw = new BufferedOutputStream(os)) {
            var header = String.format("P6\n%d %d\n255\n",
                    bitmap.getWidth(), bitmap.getHeight());

            bw.write(header.getBytes(StandardCharsets.US_ASCII));

            for (var y = 0; y < bitmap.getHeight(); y++) {
                for (var x = 0; x < bitmap.getWidth(); x++) {
                    var pixel = bitmap.getPixel(x, y);
                    bw.write(pixel.getRed());
                    bw.write(pixel.getGreen());
                    bw.write(pixel.getBlue());
                }
            }
        }
    }
}
