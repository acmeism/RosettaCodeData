import java.util.Scanner;
import java.util.Random;
import java.util.InputMismatchException;

public class TicTacToe
{
    public static char [] gameBoard = {'1', '2', '3', '4', '5',
                                        '6', '7', '8', '9'};
    public static Scanner keyboard = new Scanner(System.in);
    private static int[][] wins = {
        {0,1,2},
        {3,4,5},
        {6,7,8},
        {0,4,8},
        {2,4,6},
        {0,3,6},
        {1,4,7},
        {2,5,8}
    };

    public static void main (String [] args)
    {
        System.out.println("*****Tic-Tac-Toe*****");
        System.out.println("Directions:\n"
                + "Tic-Tac-Toe game board has 9 possible marking positions "
                + "labeled 1-9.\nTo begin play enter desired position "
                + "number to mark with X.\n");

        outputBoard();
        makeMove();

        int moveCount = 1;

        while(moveCount < gameBoard.length)
        {
            computerMove();
            if(checkBoard()){
                System.out.println("Computer wins!");
                break;
            }
            makeMove();
            if(checkBoard()){
                System.out.println("Player wins!");
                break;
            }

            moveCount = moveCount + 2;
        }
    }

    public static void outputBoard()
    {
        System.out.println("+---+---+---+");
        System.out.println("| " + gameBoard[0] + " | " + gameBoard[1]
                + " | " + gameBoard[2] + " |");
        System.out.println("+---+---+---+");
        System.out.println("| " + gameBoard[3] + " | " + gameBoard[4]
                + " | " + gameBoard[5] + " |");
        System.out.println("+---+---+---+");
        System.out.println("| " + gameBoard[6] + " | " + gameBoard[7]
                + " | " + gameBoard[8] + " |");
        System.out.println("+---+---+---+");
    }

    public static void makeMove()
    {

        System.out.println("\nYour Turn, Enter Position #:");
        int num = getPosition();

        if(gameBoard[num] == 'X' || gameBoard[num] == 'O')
        {
            System.out.println("Board Position Already Taken, Try Again.");
            makeMove();
        }
        else
        {
            gameBoard[num] = 'X';
            outputBoard();
        }

    }

    public static int getPosition()
    {
        int num = 0;
        boolean done = false;

        do
        {
            try
            {
                num = keyboard.nextInt();

                if(num > gameBoard.length || num <= 0)
                {
                    System.out.println("Incorrect Position Try Again");
                }
                else
                    done = true;
            }
            catch(InputMismatchException exception)
            {
                System.out.println("Incorrect Entry Format Try Again");
                keyboard.next();
            }

        }while(!done);

        return num - 1;
    }


    public static void computerMove()
    {
        Random rand = new Random();
        int num = rand.nextInt(9);

        if(gameBoard[num] == ('X') || gameBoard[num] == ('O'))
            computerMove();
        else
        {
            System.out.println("\nComputer's Turn.");
            gameBoard[num] = 'O';
            outputBoard();
        }
    }

    public static boolean checkBoard()
    {
        for(int[] win:wins)
        {
            if(gameBoard[win[0]] != 'O' && gameBoard[win[0]] != 'X')
            {
                continue;
            }

            char winner = gameBoard[win[0]];

            boolean check = true;

            for(int pos:win)
            {
                check = check && (gameBoard[pos] == winner);
            }

            if(check)
                return true;
        }
        return false;
    }
}
