import java.nio.channels.FileChannel.MapMode;
import java.nio.MappedByteBuffer;
import java.io.RandomAccessFile;
import java.io.IOException;
import java.io.File;

public class MMapReadFile {
	public static void main(String[] args) throws IOException {
		MappedByteBuffer buff = getBufferFor(new File(args[0]));
                String results = new String(buff.asCharBuffer());
	}
	
	public static MappedByteBuffer getBufferFor(File f) throws IOException {
		RandomAccessFile file = new RandomAccessFile(f, "r");
	
		MappedByteBuffer buffer = file.getChannel().map(MapMode.READ_ONLY, 0, f.length());
		file.close();
		return buffer;
	}
}
