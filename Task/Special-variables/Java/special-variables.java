import java.util.Arrays;

public class SpecialVariables {

    public static void main(String[] args) {

        //String-Array args contains the command line parameters passed to the program
        //Note that the "Arrays.toString()"-call is just used for pretty-printing
        System.out.println(Arrays.toString(args));

        //<Classname>.class might qualify as a special variable, since it always contains a Class<T>-object that
        //is used in Reflection
        System.out.println(SpecialVariables.class);


        //The following are not really "variables", since they are properly encapsulated:

        //System.getenv() returns a String-String-Map of environment-variables
        System.out.println(System.getenv());

        //System.getProperties() returns a Map of "things somebody might want to know", including OS and architecture
        // the Java VM runs on, various paths like home direcoty of the user that runs the program, class (library) paths,
        System.out.println(System.getProperties());

        //Runtime.getRuntime() returns a Runtime-Object that contains "changing" data about the running Java VM's
        // environment, like available processor cores or available RAM
        System.out.println(Runtime.getRuntime().availableProcessors());

    }
}
