import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.charset.Charset;
import java.io.IOException;
//...other class code
List<String> lines = null;
try{
    lines = Files.readAllLines(Paths.get(filename), Charset.defaultCharset());
}catch(IOException | SecurityException e){
    //problem with the file
}
