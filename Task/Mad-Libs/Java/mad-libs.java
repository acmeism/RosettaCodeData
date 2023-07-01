import java.util.*;

public class MadLibs {

    public static void main(String[] args){
        Scanner input = new Scanner(System.in);

        String name, gender, noun;

        System.out.print("Enter a name: ");
        name = input.next();

        System.out.print("He or she: ");
        gender = input.next();

        System.out.print("Enter a noun: ");
        noun = input.next();

        System.out.println("\f" + name + " went for a walk in the park. " + gender + "\nfound a " + noun + ". " + name + " decided to take it home.");


    }
}
