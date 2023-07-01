import java.util.Random;
import java.util.Scanner;

public class TwentyOneGame {

    public static void main(String[] args) {
        new TwentyOneGame().run(true, 21, new int[] {1, 2, 3});
    }

    public void run(boolean computerPlay, int max, int[] valid) {
        String comma = "";
        for ( int i = 0 ; i < valid.length ; i++ ) {
            comma += valid[i];
            if ( i < valid.length - 2 && valid.length >= 3 ) {
                comma += ", ";
            }
            if ( i == valid.length - 2 ) {
                comma += " or ";
            }
        }
        System.out.printf("The %d game.%nEach player chooses to add %s to a running total.%n" +
                "The player whose turn it is when the total reaches %d will win the game.%n" +
                "Winner of the game starts the next game.  Enter q to quit.%n%n", max, comma, max);
        int cGames = 0;
        int hGames = 0;
        boolean anotherGame = true;
        try (Scanner scanner = new Scanner(System.in);) {
            while ( anotherGame ) {
                Random r = new Random();
                int round = 0;
                int total = 0;
                System.out.printf("Start game %d%n", hGames + cGames + 1);
                DONE:
                    while ( true ) {
                        round++;
                        System.out.printf("ROUND %d:%n%n", round);
                        for ( int play = 0 ; play < 2 ; play++ ) {
                            if ( computerPlay ) {
                                int guess = 0;
                                //  try find one equal
                                for ( int test : valid ) {
                                    if ( total + test == max ) {
                                        guess = test;
                                        break;
                                    }
                                }
                                //  try find one greater than
                                if ( guess == 0 ) {
                                    for ( int test : valid ) {
                                        if ( total + test >= max ) {
                                            guess = test;
                                            break;
                                        }
                                    }
                                }
                                if ( guess == 0 ) {
                                    guess = valid[r.nextInt(valid.length)];
                                }
                                total += guess;
                                System.out.printf("The computer chooses %d%n", guess);
                                System.out.printf("Running total is now %d%n%n", total);
                                if ( total >= max ) {
                                    break DONE;
                                }
                            }
                            else {
                                while ( true ) {
                                    System.out.printf("Your choice among %s: ", comma);
                                    String line = scanner.nextLine();
                                    if ( line.matches("^[qQ].*") ) {
                                        System.out.printf("Computer wins %d game%s, human wins %d game%s.  One game incomplete.%nQuitting.%n", cGames, cGames == 1 ? "" : "s", hGames, hGames == 1 ? "" : "s");
                                        return;
                                    }
                                    try {
                                        int input = Integer.parseInt(line);
                                        boolean inputOk = false;
                                        for ( int test : valid ) {
                                            if ( input == test ) {
                                                inputOk = true;
                                                break;
                                            }
                                        }
                                        if ( inputOk ) {
                                            total += input;
                                            System.out.printf("Running total is now %d%n%n", total);
                                            if ( total >= max ) {
                                                break DONE;
                                            }
                                            break;
                                        }
                                        else {
                                            System.out.printf("Invalid input - must be a number among %s.  Try again.%n", comma);
                                        }
                                    }
                                    catch (NumberFormatException e) {
                                        System.out.printf("Invalid input - must be a number among %s.  Try again.%n", comma);
                                    }
                                }
                            }
                            computerPlay = !computerPlay;
                        }
                    }
                String win;
                if ( computerPlay ) {
                    win = "Computer wins!!";
                    cGames++;
                }
                else {
                    win = "You win and probably had help from another computer!!";
                    hGames++;
                }
                System.out.printf("%s%n", win);
                System.out.printf("Computer wins %d game%s, human wins %d game%s%n%n", cGames, cGames == 1 ? "" : "s", hGames, hGames == 1 ? "" : "s");
                while ( true ) {
                    System.out.printf("Another game (y/n)? ");
                    String line = scanner.nextLine();
                    if ( line.matches("^[yY]$") ) {
                        //  OK
                        System.out.printf("%n");
                        break;
                    }
                    else if ( line.matches("^[nN]$") ) {
                        anotherGame = false;
                        System.out.printf("Quitting.%n");
                        break;
                    }
                    else {
                        System.out.printf("Invalid input - must be a y or n.  Try again.%n");
                    }
                }
            }
        }
    }

}
