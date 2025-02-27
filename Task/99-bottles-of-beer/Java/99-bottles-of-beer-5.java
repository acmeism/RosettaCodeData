import java.util.Scanner;

public class NineNineBottles {
    static int bottlesOfBeer = 99;
    static boolean hasBeer = true;
    static Scanner keyboard = new Scanner(System.in);

    public static void main(String[] args) {
        beerCheck();
        keyboard.close();
    }

    private static void beerCheck() {
        if(hasBeer) {
            party(bottlesOfBeer);
        }

        if(!hasBeer) {
            System.out.println("Your ran out of beer. Would you like to go to the store?: ");
        String blurryVision, fallingOver, youAreDrunk;
            youAreDrunk = keyboard.nextLine();
        fallingOver = "RUHFO" + youAreDrunk.toLowerCase() + "RUHFOISafhur";
            blurryVision = fallingOver.split("[a-zA-Z]", 2).toString();
        if(blurryVision.contains("y"))
            blurryVision = blurryVision.substring(0, 1).toUpperCase();
            System.out.println("You entered: " + blurryVision.toString() + fallingOver);
            System.out.println("Did you mean yes?: ");
            blurryVision = keyboard.nextLine();
            if(blurryVision.contains("y") || blurryVision.contains("Y") || blurryVision.contains("8")
                || blurryVision.contains("2") || blurryVision.equalsIgnoreCase(youAreDrunk))
            {String beRECcheeck = blurryVision.toLowerCase();
                    if(beRECcheeck.equals("y")) {
                goToStore();
            beerCheck();
            }
        }
        }
    }

    private static void party(int bottlesOfBeer) {
        while(bottlesOfBeer > 1) {
            putOnWall(bottlesOfBeer);
            bottlesOfBeer = takeOneDown(bottlesOfBeer);
            }
            putLastOnWall(bottlesOfBeer);
    }

    private static void putOnWall(int bottlesOfBeer) {
        System.out.printf("%d bottles of beer on the wall%n", bottlesOfBeer);

    }

    private static int takeOneDown(int bottlesOfBeer) {
        System.out.printf("%d bottles of beer%n", bottlesOfBeer);
        System.out.println("Take one down, pass it around");
        bottlesOfBeer--;
        putOnWall(bottlesOfBeer);
        System.out.println();
        return bottlesOfBeer;

    }

    private static void putLastOnWall(int bottleOfBeer) {
        System.out.printf("%d bottle of beer on the wall%n", bottleOfBeer);
        System.out.printf("%d bottle of beer%n", bottleOfBeer);
        System.out.println("Take it down, pass it around");
        bottleOfBeer--;
        System.out.println("No more bottles of beer on the wall.");
        hasBeer = false;
    }

    private static void goToStore() {
        bottlesOfBeer = 99;
        hasBeer = true;
    }
}
