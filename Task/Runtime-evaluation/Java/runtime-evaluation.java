import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.lang.reflect.InvocationTargetException;
import java.net.URI;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import javax.tools.FileObject;
import javax.tools.ForwardingJavaFileManager;
import javax.tools.JavaCompiler;
import javax.tools.JavaFileObject;
import javax.tools.SimpleJavaFileObject;
import javax.tools.StandardJavaFileManager;
import javax.tools.StandardLocation;
import javax.tools.ToolProvider;

public class Evaluator{
    public static void main(String[] args){
        new Evaluator().eval(
            "SayHello",
            "public class SayHello{public void speak(){System.out.println(\"Hello world\");}}",
            "speak"
        );
    }

    void eval(String className, String classCode, String methodName){
        Map<String, ByteArrayOutputStream> classCache = new HashMap<>();
        JavaCompiler                       compiler   = ToolProvider.getSystemJavaCompiler();

        if ( null == compiler )
            throw new RuntimeException("Could not get a compiler.");

        StandardJavaFileManager                            sfm  = compiler.getStandardFileManager(null, null, null);
        ForwardingJavaFileManager<StandardJavaFileManager> fjfm = new ForwardingJavaFileManager<StandardJavaFileManager>(sfm){
            @Override
            public JavaFileObject getJavaFileForOutput(Location location, String className, JavaFileObject.Kind kind, FileObject sibling)
                    throws IOException{
                if (StandardLocation.CLASS_OUTPUT == location && JavaFileObject.Kind.CLASS == kind)
                    return new SimpleJavaFileObject(URI.create("mem:///" + className + ".class"), JavaFileObject.Kind.CLASS){
                        @Override
                        public OutputStream openOutputStream()
                                throws IOException{
                            ByteArrayOutputStream baos = new ByteArrayOutputStream();
                            classCache.put(className, baos);
                            return baos;
                        }
                    };
                else
                    throw new IllegalArgumentException("Unexpected output file requested: " + location + ", " + className + ", " + kind);
            }
        };
        List<JavaFileObject> files = new LinkedList<JavaFileObject>(){{
            add(
                new SimpleJavaFileObject(URI.create("string:///" + className + ".java"), JavaFileObject.Kind.SOURCE){
                    @Override
                    public CharSequence getCharContent(boolean ignoreEncodingErrors){
                        return classCode;
                    }
                }
            );
        }};

        // Now we can compile!
        compiler.getTask(null, fjfm, null, null, null, files).call();

        try{
            Class<?> clarse = new ClassLoader(){
                @Override
                public Class<?> findClass(String name){
                    if (! name.startsWith(className))
                        throw new IllegalArgumentException("This class loader is for " + className + " - could not handle \"" + name + '"');
                    byte[] bytes = classCache.get(name).toByteArray();
                    return defineClass(name, bytes, 0, bytes.length);
                }
            }.loadClass(className);

            // Invoke a method on the thing we compiled
            clarse.getMethod(methodName).invoke(clarse.newInstance());

        }catch(ClassNotFoundException | InstantiationException | IllegalAccessException | NoSuchMethodException | InvocationTargetException x){
            throw new RuntimeException("Run failed: " + x, x);
        }
    }
}
