using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace RosettaTicTacToe
{
  class Program
  {

    /*================================================================
     *Pieces (players and board)
     *================================================================*/
    static string[][] Players = new string[][] {
      new string[] { "COMPUTER", "X" }, // computer player
      new string[] { "HUMAN", "O" }     // human player
    };

    const int Unplayed = -1;
    const int Computer = 0;
    const int Human = 1;

    // GameBoard holds index into Players[] (0 or 1) or Unplayed (-1) if location not yet taken
    static int[] GameBoard = new int[9];

    static int[] corners = new int[] { 0, 2, 6, 8 };

    static int[][] wins = new int[][] {
      new int[] { 0, 1, 2 }, new int[] { 3, 4, 5 }, new int[] { 6, 7, 8 },
      new int[] { 0, 3, 6 }, new int[] { 1, 4, 7 }, new int[] { 2, 5, 8 },
      new int[] { 0, 4, 8 }, new int[] { 2, 4, 6 } };


    /*================================================================
     *Main Game Loop (this is what runs/controls the game)
     *================================================================*/
    static void Main(string[] args)
    {
      while (true)
      {
        Console.Clear();
        Console.WriteLine("Welcome to Rosetta Code Tic-Tac-Toe for C#.");
        initializeGameBoard();
        displayGameBoard();
        int currentPlayer = rnd.Next(0, 2);  // current player represented by Players[] index of 0 or 1
        Console.WriteLine("The first move goes to {0} who is playing {1}s.\n", playerName(currentPlayer), playerToken(currentPlayer));
        while (true)
        {
          int thisMove = getMoveFor(currentPlayer);
          if (thisMove == Unplayed)
          {
            Console.WriteLine("{0}, you've quit the game ... am I that good?", playerName(currentPlayer));
            break;
          }
          playMove(thisMove, currentPlayer);
          displayGameBoard();
          if (isGameWon())
          {
            Console.WriteLine("{0} has won the game!", playerName(currentPlayer));
            break;
          }
          else if (isGameTied())
          {
            Console.WriteLine("Cat game ... we have a tie.");
            break;
          }
          currentPlayer = getNextPlayer(currentPlayer);
        }
        if (!playAgain())
          return;
      }
    }

    /*================================================================
     *Move Logic
     *================================================================*/
    static int getMoveFor(int player)
    {
      if (player == Human)
        return getManualMove(player);
      else
      {
        //int selectedMove = getManualMove(player);
        //int selectedMove = getRandomMove(player);
        int selectedMove = getSemiRandomMove(player);
        //int selectedMove = getBestMove(player);
        Console.WriteLine("{0} selects position {1}.", playerName(player), selectedMove + 1);
        return selectedMove;
      }
    }

    static int getManualMove(int player)
    {
      while (true)
      {
        Console.Write("{0}, enter you move (number): ", playerName(player));
        ConsoleKeyInfo keyInfo = Console.ReadKey();
        Console.WriteLine();  // keep the display pretty
        if (keyInfo.Key == ConsoleKey.Escape)
          return Unplayed;
        if (keyInfo.Key >= ConsoleKey.D1 && keyInfo.Key <= ConsoleKey.D9)
        {
          int move = keyInfo.KeyChar - '1';  // convert to between 0..8, a GameBoard index position.
          if (GameBoard[move] == Unplayed)
            return move;
          else
            Console.WriteLine("Spot {0} is already taken, please select again.", move + 1);
        }
        else
          Console.WriteLine("Illegal move, please select again.\n");
      }
    }

    static int getRandomMove(int player)
    {
      int movesLeft = GameBoard.Count(position => position == Unplayed);
      int x = rnd.Next(0, movesLeft);
      for (int i = 0; i < GameBoard.Length; i++)  // walk board ...
      {
        if (GameBoard[i] == Unplayed && x < 0)    // until we reach the unplayed move.
          return i;
        x--;
      }
      return Unplayed;
    }

    // plays random if no winning move or needed block.
    static int getSemiRandomMove(int player)
    {
      int posToPlay;
      if (checkForWinningMove(player, out posToPlay))
        return posToPlay;
      if (checkForBlockingMove(player, out posToPlay))
        return posToPlay;
      return getRandomMove(player);
    }

    // purposely not implemented (this is the thinking part).
    static int getBestMove(int player)
    {
      return -1;
    }

    static bool checkForWinningMove(int player, out int posToPlay)
    {
      posToPlay = Unplayed;
      foreach (var line in wins)
        if (twoOfThreeMatchPlayer(player, line, out posToPlay))
          return true;
      return false;
    }

    static bool checkForBlockingMove(int player, out int posToPlay)
    {
      posToPlay = Unplayed;
      foreach (var line in wins)
        if (twoOfThreeMatchPlayer(getNextPlayer(player), line, out posToPlay))
          return true;
      return false;
    }

    static bool twoOfThreeMatchPlayer(int player, int[] line, out int posToPlay)
    {
      int cnt = 0;
      posToPlay = int.MinValue;
      foreach (int pos in line)
      {
        if (GameBoard[pos] == player)
          cnt++;
        else if (GameBoard[pos] == Unplayed)
          posToPlay = pos;
      }
      return cnt == 2 && posToPlay >= 0;
    }

    static void playMove(int boardPosition, int player)
    {
      GameBoard[boardPosition] = player;
    }

    static bool isGameWon()
    {
      return wins.Any(line => takenBySamePlayer(line[0], line[1], line[2]));
    }

    static bool takenBySamePlayer(int a, int b, int c)
    {
      return GameBoard[a] != Unplayed && GameBoard[a] == GameBoard[b] && GameBoard[a] == GameBoard[c];
    }

    static bool isGameTied()
    {
      return !GameBoard.Any(spot => spot == Unplayed);
    }

    /*================================================================
     *Misc Methods
     *================================================================*/
    static Random rnd = new Random();

    static void initializeGameBoard()
    {
      for (int i = 0; i < GameBoard.Length; i++)
        GameBoard[i] = Unplayed;
    }

    static string playerName(int player)
    {
      return Players[player][0];
    }

    static string playerToken(int player)
    {
      return Players[player][1];
    }

    static int getNextPlayer(int player)
    {
      return (player + 1) % 2;
    }

    static void displayGameBoard()
    {
      Console.WriteLine(" {0} | {1} | {2}", pieceAt(0), pieceAt(1), pieceAt(2));
      Console.WriteLine("---|---|---");
      Console.WriteLine(" {0} | {1} | {2}", pieceAt(3), pieceAt(4), pieceAt(5));
      Console.WriteLine("---|---|---");
      Console.WriteLine(" {0} | {1} | {2}", pieceAt(6), pieceAt(7), pieceAt(8));
      Console.WriteLine();
    }

    static string pieceAt(int boardPosition)
    {
      if (GameBoard[boardPosition] == Unplayed)
        return (boardPosition + 1).ToString();  // display 1..9 on board rather than 0..8
      return playerToken(GameBoard[boardPosition]);
    }

    private static bool playAgain()
    {
      Console.WriteLine("\nDo you want to play again?");
      return Console.ReadKey(false).Key == ConsoleKey.Y;
    }
  }

}
