# Pick an integer from $lowest through $highest ...
def play($lowest; $highest):
  # Helper function for guessing
  def prompt:
    .guess = (((.lowest + .highest)/2)|floor)
    | .emit += "\nMy guess is \(.guess)." +
               "\nIs this higher/lower than or equal to your chosen number?  h/l/e : " ;

  "Please choose a number from \($lowest) to \($highest) inclusive and then answer the questions.",
  ( {$highest, $lowest}
    | prompt
    | .emit,
      ( label $out
        | foreach inputs as $in (.;
	  .emit = null
          | .hle = ($in|ascii_downcase)
          | if .hle == "l" and .guess == .highest
            then .emit = "It can't be more than \(highest), try again."
            elif .hle == "h" and .guess == .lowest
            then .emit = "It can't be less than \(.lowest), try again."
            elif .hle == "e"
            then .emit = "Good, thanks for playing the game with me!"
	    | .quit = true
            elif .hle == "h"
            then if (.highest > .guess - 1) then .highest = .guess - 1
                 else .
		 end
	    elif .hle == "l"
            then if (.lowest < .guess + 1)  then .lowest = .guess + 1
                 else .
                 end
            else .emit = "Please try again.\n"
	    end
         | if .quit then ., break $out else prompt end ;
      .emit
      ) ) ) ;

def play: play(1;20);

play
