// constant value 2d array to represent the dodecahedron
// room structure
const static int adjacentRooms[20][3] = {
  {1, 4, 7},   {0, 2, 9},   {1, 3, 11},   {2, 4, 13},    {0, 3, 5},
  {4, 6, 14},  {5, 7, 16},    {0, 6, 8},   {7, 9, 17},   {1, 8, 10},
  {9, 11, 18}, {2, 10, 12}, {11, 13, 19},  {3, 12, 14},  {5, 13, 15},
  {14, 16, 19}, {6, 15, 17},  {8, 16, 18}, {10, 17, 19}, {12, 15, 18}
};

class WumpusGame {

    private:
      // Data Members
      int numRooms;
      int currentRoom, startingPosition; // currentRoom is an integer variable that stores the room the player is currently in (between 0-20)
      int wumpusRoom, batRoom1, batRoom2, pitRoom1, pitRoom2; // Stores the room numbers of the respective
      int wumpusStart, bat1Start, bat2Start;
      bool playerAlive, wumpusAlive; // Are the player and wumpus still alive? True or false.
      int numArrows; //store arrow count

      // private functions
      void PlacePits();
      void PlaceBats();
      void PlaceWumpus();
      void PlacePlayer();
      bool IsValidMove(int);
      bool IsRoomAdjacent(int, int);
      int Move(int);
      void InspectCurrentRoom();
      void PerformAction(int);
      void MoveStartledWumpus(int);
      void PlayGame();
      void PlayAgain();
      void PrintInstructions();

      // Access specifier
      public:
        //public functions
        void StartGame();
        WumpusGame();
};

#include <iostream>
#include <stdlib.h>     /* srand, rand */
#include <time.h>       /* time */
#include <vector>
#include <cstring>
using namespace std;

// default constructor
WumpusGame::WumpusGame() {
  numRooms = 20;
}

// This function prints the instructions for the game
// to the console
void WumpusGame::PrintInstructions() {
    char wait;
    cout << " Welcome to 'Hunt the Wumpus'! " << endl;
    cout << " The wumpus lives in a cave of 20 rooms. Each room has 3 tunnels leading to" << endl;
    cout << " other rooms. (Look at a dodecahedron to see how this works - if you don't know" << endl;
    cout << " what a dodecahedron is, ask someone). \n" << endl;
    cout << " Hazards: \n" << endl;
    cout << " Bottomless pits - two rooms have bottomless pits in them. If you go there, you " << endl;
    cout << " fall into the pit (& lose!) \n" << endl;
    cout << " Super bats - two other rooms have super bats.  If you go there, a bat grabs you" << endl;
    cout << " and takes you to some other room at random. (Which may be troublesome). Once the" << endl;
    cout << " bat has moved you, that bat moves to another random location on the map.\n\n" << endl;

    cout << " Wumpus" << endl;
    cout << " The wumpus is not bothered by hazards (he has sucker feet and is too big for a" << endl;
    cout << " bat to lift).  Usually he is asleep.  Two things wake him up: you shooting an" << endl;
    cout << " arrow or you entering his room. If the wumpus wakes he moves (p=.75) one room or " << endl;
    cout << " stays still (p=.25). After that, if he is where you are, he eats you up and you lose!\n" << endl;

    cout << " You \n" << endl;
    cout << " Each turn you may move, save or shoot an arrow using the commands move, save, & shoot." << endl;
    cout << " Moving: you can move one room (thru one tunnel)." << endl;
    cout << " Arrows: you have 3 arrows. You lose when you run out. You aim by telling the" << endl;
    cout << " computer the rooms you want the arrow to go to.  If the arrow can't go that way" << endl;
    cout << " (if no tunnel), the arrow will not fire." << endl;

    cout << " Warnings" << endl;
    cout << " When you are one room away from a wumpus or hazard, the computer says:" << endl;

    cout << " Wumpus: 'I smell a wumpus'" << endl;
    cout << " Bat: 'Bats nearby'" << endl;
    cout << " Pit: 'I feel a draft'" << endl;

    cout << endl;
    cout << "Press Y to return to the main menu." << endl;
    cin >> wait;

}

// This function will place two bats throughout the map
// this ensures that the bats will not be place in the same
// room as another bat or the wumpus
void WumpusGame::PlaceBats() {
  srand (time(NULL));
  bool validRoom = false;
  while(!validRoom){
      batRoom1 = rand() % 20 + 1;
      if(batRoom1 != wumpusRoom)
          validRoom = true;
  }

  validRoom = false;
  while(!validRoom){
      batRoom2 = rand() % 20 + 1;
      if(batRoom2 != wumpusRoom && batRoom2 != batRoom1)
          validRoom = true;
  }
  bat1Start = batRoom1;
  bat2Start = batRoom2;
}

// this function randomly places the pits
// throughout the map excluding room 0
void WumpusGame::PlacePits() {
    srand (time(NULL));
    pitRoom1 = rand() % 20 + 1;
    pitRoom2 = rand() % 20 + 1;
}

// this function randomly places the wumpus in a room
// without being in room number 0
void WumpusGame::PlaceWumpus() {
    srand (time(NULL));
    int randomRoom = rand() % 20 + 1;
    wumpusRoom = randomRoom;
    wumpusStart = wumpusRoom;
}

// place the player in room 0
void WumpusGame::PlacePlayer() {
    startingPosition = 0;
    currentRoom = Move(0);
}

// This is a  method that checks if the user inputted a valid room to move to or not.
// The room number has to be between 0 and 20, but also must be adjacent to the current room.
bool WumpusGame::IsValidMove(int roomID) {
    if (roomID < 0) return false;
    if (roomID > numRooms) return false;
    if (!IsRoomAdjacent(currentRoom, roomID)) return false;

    return true;
}

// This method returns true if roomB is adjacent to roomA, otherwise returns false.
// It is a helper method that loops through the adjacentRooms array to check.
// It will be used throughout the app to check if we are next to the wumpus, bats, or pits
// as well as check if we can make a valid move.
bool WumpusGame::IsRoomAdjacent(int roomA, int roomB)
{
    for (int j = 0; j < 3; j++)
    {
        if (adjacentRooms[roomA][j] == roomB){
          return true;
        }
    }
    return false;
}

// This method moves the player to a new room and returns the new room. It performs no checks on its own.
int WumpusGame::Move(int newRoom)
{
    return newRoom;
}

// Inspects the current room.
// This method check for Hazards such as being in the same room as the wumpus, bats, or pits
// It also checks if you are adjacent to a hazard and handle those cases
// Finally it will just print out the room description
void WumpusGame::InspectCurrentRoom() {
    srand (time(NULL));
    if (currentRoom == wumpusRoom)
    {
        cout << "The Wumpus ate you!!!" << endl;
        cout << "LOSER!!!" << endl;
        PlayAgain();
    }
    else if (currentRoom == batRoom1 || currentRoom == batRoom2)
    {
        int roomBatsLeft = currentRoom;
        bool validNewBatRoom = false;
        bool isBatRoom = false;
        cout << "Snatched by superbats!!" << endl;
        if(currentRoom == pitRoom1 || currentRoom == pitRoom2)
            cout << "Luckily, the bats saved you from the bottomless pit!!" << endl;
        while(!isBatRoom){
            currentRoom = Move(rand() % 20 + 1);
            if(currentRoom != batRoom1 && currentRoom != batRoom2)
                isBatRoom = true;
        }
        cout << "The bats moved you to room ";
	      cout << currentRoom << endl;
        InspectCurrentRoom();

        if(roomBatsLeft == batRoom1){
            while(!validNewBatRoom){
                batRoom1 = rand() % 19 + 1;
                if(batRoom1 != wumpusRoom && batRoom1 != currentRoom)
                    validNewBatRoom = true;
            }
        } else {
            while(!validNewBatRoom){
                batRoom2 = rand() % 19 + 1;
                if(batRoom2 != wumpusRoom && batRoom2 != currentRoom)
                    validNewBatRoom = true;
            }
        }
    }
    else if(currentRoom == pitRoom1 || currentRoom == pitRoom2)
    {
        cout << "YYYIIIIIEEEEE.... fell in a pit!!!" << endl;
        cout << "GAME OVER LOSER!!!" << endl;
        PlayAgain();
    }
    else
    {
        cout << "You are in room ";
        cout << currentRoom << endl;
        if (IsRoomAdjacent(currentRoom, wumpusRoom)){
            cout << "You smell a horrid stench..." << endl;
        }
        if (IsRoomAdjacent(currentRoom, batRoom1) || IsRoomAdjacent(currentRoom, batRoom2)){
            cout << "Bats nearby..." << endl;
        }
        if (IsRoomAdjacent(currentRoom, pitRoom1) || IsRoomAdjacent(currentRoom, pitRoom2)){
            cout << "You feel a draft..." << endl;
        }
        cout << "Tunnels lead to rooms " << endl;
        for (int j = 0; j < 3; j++)
        {
            cout << adjacentRooms[currentRoom][j];
            cout << " ";
        }
        cout << endl;
    }
}

// Method accepts an int which is the command the user inputted.
// This method performs the action of the command or prints out an error.
void WumpusGame::PerformAction(int cmd) {
    int newRoom;
    switch (cmd)
    {

        case 1:
            cout << "Which room? " << endl;
            try
            {
                cin >> newRoom;
                // Check if the user inputted a valid room id, then simply tell the player to move there.
                if (IsValidMove(newRoom))
                {
                    currentRoom = Move(newRoom);
                    InspectCurrentRoom();
                }
                else
                {
                    cout << "You cannot move there." << endl;
                }
            }
            catch (...) // Try...Catch block will catch if the user inputs text instead of a number.
            {
                cout << "You cannot move there." << endl;
            }
            break;
        case 2:
            if(numArrows > 0){
                cout << "Which room? " << endl;
                try
                {
                    cin >> newRoom;
                    // Check if the user inputted a valid room id, then simply tell the player to move there.
                    if (IsValidMove(newRoom))
                    {
                        numArrows--;
                        if(newRoom == wumpusRoom){
                            cout << "ARGH.. Splat!" << endl;
                            cout << "Congratulations! You killed the Wumpus! You Win." << endl;
                            cout << "Press 'Y' to return to the main menu." << endl;
                            wumpusAlive = false;
                            cin >> newRoom;
                            cin.clear();
                            cin.ignore(10000, '\n');
                        }
                        else
                        {
                            cout << "Miss! But you startled the Wumpus" << endl;
                            MoveStartledWumpus(wumpusRoom);
                            cout << "Arrows Left: ";
                            cout << numArrows << endl;
                            if(wumpusRoom == currentRoom){
                                cout << "The wumpus attacked you! You've been killed." << endl;
                                cout << "Game Over!" << endl;
                                PlayAgain();
                            }

                        }
                    }
                    else
                    {
                        cout << "You cannot shoot there." << endl;
                    }
                }
                catch (...) // Try...Catch block will catch if the user inputs text instead of a number.
                {
                    cout << "You cannot shoot there." << endl;
                }
            } else
            {
                cout << "You do not have any arrows!" << endl;
            }
            break;
        case 3:
            cout << "Quitting the current game." << endl;
            playerAlive = false;
            break;
        default:
            cout << "You cannot do that. You can move, shoot, save or quit." << endl;
            break;
    }
}

// this function moves the wumpus randomly to a room that is adjacent to
// the wumpus's current position
void WumpusGame::MoveStartledWumpus(int roomNum){
    srand (time(NULL));
    int rando = rand() % 3;
    if(rando != 3)
        wumpusRoom = adjacentRooms[roomNum][rando];
}

// This restarts the map from the begiinning
void WumpusGame::PlayAgain(){
    char reply;
    cout << "Would you like to replay the same map? Enter Y to play again." << endl;
    cin >> reply;
    if(reply == 'y' || reply == 'Y'){
        currentRoom = startingPosition;
        wumpusRoom = wumpusStart;
        batRoom1 = bat1Start;
        batRoom2 = bat2Start;
        cout << "Try not to die this time. \n" << endl;
        InspectCurrentRoom();
    } else {
        playerAlive = false;
    }

}

// PlayGame() method starts up the game.
// It houses the main game loop and when PlayGame() quits the game has ended.
void WumpusGame::PlayGame()
{
	int choice;
  bool validChoice = false;

	cout << "Running the game..." << endl;

  // Initialize the game
	PlaceWumpus();
	PlaceBats();
	PlacePits();
	PlacePlayer();

	// game set up
	playerAlive = true;
	wumpusAlive = true;
	numArrows = 3;

    //Inspects the initial room
    InspectCurrentRoom();

    // Main game loop.
    while (playerAlive && wumpusAlive)
    {
        cout << "Enter an action choice." << endl;
        cout << "1) Move" << endl;
        cout << "2) Shoot" << endl;
        cout << "3) Quit" << endl;
        cout << ">>> ";

        do
        {
            validChoice = true;
            cout << "Please make a selection: ";
            try
            {
                cin >> choice;
                switch (choice)
                {
                    case 1:
                        PerformAction(choice);
                        break;
                    case 2:
                        PerformAction(choice);
                        break;
                    case 3:
                        PerformAction(choice);
                        break;
                    default:
                        validChoice = false;
                        cout << "Invalid choice. Please try again." << endl;
                        cin.clear();
		                    cin.ignore(10000, '\n');
                        break;
                }
            }
            catch (...)
            {
                validChoice = false;
                cout << "Invalid choice. Please try again." << endl;
                cin.clear();
                cin.ignore(10000, '\n');
            }

        } while (validChoice == false);
    }
}

// this function begins the game loop
void WumpusGame::StartGame() {

	srand (time(NULL));
	int choice;
  bool validChoice;
  bool keepPlaying;
  wumpusStart = bat1Start = bat2Start = -1;

  do {
      keepPlaying = true;
      cout << "Welcome to Hunt The Wumpus." << endl;
      cout << "1) Play Game" << endl;
      cout << "2) Print Instructions" << endl;
      cout << "3) Quit" << endl;

      do
      {
          validChoice = true;
          cout << "Please make a selection: ";
          try
          {
              cin >> choice;
              switch (choice)
              {
                  case 1:
                      PlayGame();
                      break;
                  case 2:
                      PrintInstructions();
                      break;
                  case 3:
                      cout << "Quitting." << endl;
                      keepPlaying = false;
                      break;
                  default:
                      validChoice = false;
                      cout << "Invalid choice. Please try again." << endl;
                      cin.clear();
                      cin.ignore(10000, '\n');
                      break;
              }
          }
          catch (...)
          {
              validChoice = false;
              cout << "Invalid choice. Please try again." << endl;
              cin.clear();
              cin.ignore(10000, '\n');
          }

      } while (validChoice == false);
  } while (keepPlaying);
}

int main() {
    // create wumpus game object
    WumpusGame game;
    // start the game
    game.StartGame();
}
