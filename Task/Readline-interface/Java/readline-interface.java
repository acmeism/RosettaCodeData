import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;

public class ReadlineInterface {
    private static LinkedList<String> histArr = new LinkedList<>();

    private static void hist() {
        if (histArr.isEmpty()) {
            System.out.println("No history");
        } else {
            histArr.forEach(cmd -> System.out.printf(" - %s\n", cmd));
        }

        class Crutch {}
        histArr.add(Crutch.class.getEnclosingMethod().getName());
    }

    private static void hello() {
        System.out.println("Hello World!");

        class Crutch {}
        histArr.add(Crutch.class.getEnclosingMethod().getName());
    }

    private static void help() {
        System.out.println("Available commands:");
        System.out.println("  hello");
        System.out.println("  hist");
        System.out.println("  exit");
        System.out.println("  help");

        class Crutch {}
        histArr.add(Crutch.class.getEnclosingMethod().getName());
    }

    public static void main(String[] args) throws IOException {
        Map<String, Runnable> cmdMap = new HashMap<>();
        cmdMap.put("help", ReadlineInterface::help);
        cmdMap.put("hist", ReadlineInterface::hist);
        cmdMap.put("hello", ReadlineInterface::hello);

        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));

        System.out.println("Enter a command, type help for a listing.");
        while (true) {
            System.out.print(">");
            String line = in.readLine();
            if ("exit".equals(line)) {
                break;
            }

            cmdMap.getOrDefault(line, ReadlineInterface::help).run();
        }
    }
}
