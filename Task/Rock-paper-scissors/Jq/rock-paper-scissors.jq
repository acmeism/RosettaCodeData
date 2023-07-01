# To quit, enter a blank line or type "q" or "quit"
def choices: ["r", "p", "s", "q"];

# The main source of entropy for this pseudo pseudo random number generator is the player :-)
# PRN in range(0;3)
def rand: now * 100 | floor | tostring[-2:] | tonumber % 3;

def tallies:
  {pWins: 0,          # player wins
   cWins: 0,          # computer wins
   draws: 0,          # neither wins
   games: 0,          # games played
   pFreqs: [0, 0, 0]  # player frequencies for each choice (rps)
};

# Update the tallies and populate .emit
def update($pChoice; $cChoice):
  if $pChoice == "r" and $cChoice == "s"
  then .emit += "Rock breaks scissors - You win!"
  | .pWins += 1
  elif $pChoice == "p" and $cChoice == "r"
  then .emit += "Paper covers rock - You win!"
  | .pWins += 1
  elif $pChoice == "s" and $cChoice == "p"
  then .emit += "Scissors cut paper - You win!"
  | .pWins +=  1
  elif $pChoice == "s" and $cChoice == "r"
  then .emit += "Rock breaks scissors - Computer wins!"
  | .cWins += 1
  elif $pChoice == "r" and $cChoice == "p"
  then .emit += "Paper covers rock - Computer wins!"
  | .cWins +=  1
  elif $pChoice == "p" and $cChoice == "s"
  then .emit += "Scissors cut paper - Computer wins!"
  | .cWins +=  1
  else .emit += "It's a draw!"
  | .draws += 1
  end
  | .pFreqs[choices|index($pChoice)] += 1
  | .games += 1 ;

def printScore:
    "Wins: You \(.pWins), Computer \(.cWins), Neither \(.draws)\n";


def getComputerChoice:
    # make a completely random choice until 3 games have been played
    if .games < 3 then choices[rand]
    else .games as $games
    | (.pFreqs | map(3 * . / $games)) as $pFreqs
    | rand as $num
    | if $num < $pFreqs[0] then "p"
      elif $num < $pFreqs[0] + $pFreqs[1] then "s"
      else "r"
      end
    end ;

# Get player's choice (empty line or q or quit to quit).
# Return false if the choice is not recognized.
def pChoice:
  (first(inputs) // null) as $in
  | if $in == null or $in == "q" or $in == "quit" then null
    else ($in|ascii_downcase) as $in
    | if any(choices[]; . == $in) then $in
      else false
      end
    end;

# Solicit input
def prompt:
  if .games == 0
  then "Enter: (r)ock, (p)aper, (s)cissors or (q)uit"
  else  printScore + "---\n\nYour choice r/p/s/q : "
  end;

def play:
  label $out
  | foreach range(1; infinite) as $i (tallies ;
      # if .prompt then it is time to get input:
      if .prompt
      then pChoice as $pChoice
      | if $pChoice == null
        then .prompt = false
	| .emit = "OK, quitting", break $out
        elif $pChoice == false
	then .emit = "Valid responses are one of r p s q\nPlease try again."
        else getComputerChoice as $cChoice
	| .prompt = false
        | .emit = "Computer's choice   : \($cChoice)\n"
        | update($pChoice; $cChoice)
        end
      else .prompt = prompt
      | .emit = null
    end )

  | select(.emit).emit,
    select(.prompt).prompt ;

play
