import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.Scanner;

//uses https://github.com/dwyl/english-words

public class textCompletionConcept {
    public static int correct = 0;
    public static ArrayList<String> listed = new ArrayList<>();
    public static void main(String[]args) throws IOException, URISyntaxException {
        Scanner input = new Scanner(System.in);
        System.out.println("Input word: ");
        String errorRode = input.next();
        File file = new File(new
        File(textCompletionConcept.class.getProtectionDomain().getCodeSource().getLocation().toURI()).getPath() + File.separator + "words.txt");
        Scanner reader = new Scanner(file);
        while(reader.hasNext()){
            double percent;
            String compareToThis = reader.nextLine();
                    char[] s1 = errorRode.toCharArray();
                    char[] s2 = compareToThis.toCharArray();
                    int maxlen = Math.min(s1.length, s2.length);
                    for (int index = 0; index < maxlen; index++) {
                        String x = String.valueOf(s1[index]);
                        String y = String.valueOf(s2[index]);
                        if (x.equals(y)) {
                            correct++;
                        }
                    }
                    double length = Math.max(s1.length, s2.length);
                    percent = correct / length;
                    percent *= 100;
                    boolean perfect = false;
                    if (percent >= 80 && compareToThis.charAt(0) == errorRode.charAt(0)) {
                        if(String.valueOf(percent).equals("100.00")){
                            perfect = true;
                        }
                        String addtoit = compareToThis + " : " + String.format("%.2f", percent) + "% similar.";
                        listed.add(addtoit);
                    }
                    if(compareToThis.contains(errorRode) && !perfect && errorRode.length() * 2 > compareToThis.length()){
                        String addtoit = compareToThis + " : 80.00% similar.";
                        listed.add(addtoit);
                    }
            correct = 0;
        }

        for(String x : listed){
            if(x.contains("100.00% similar.")){
                System.out.println(x);
                listed.clear();
                break;
            }
        }

        for(String x : listed){
            System.out.println(x);
        }
    }
}
