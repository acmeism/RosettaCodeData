open System

let random = Random ()
let rand = random.NextDouble () //Gets a random number in the range (0.0, 1.0)

/// Union of possible choices for a round of rock-paper-scissors
type Choice =
| Rock
| Paper
| Scissors

/// Gets the string representation of a Choice
let getString = function
    | Rock -> "Rock"
    | Paper -> "Paper"
    | Scissors -> "Scissors"

/// Defines rules for winning and losing
let beats (a : Choice, b : Choice) =
    match a, b with
    | Rock, Scissors -> true    // Rock beats Scissors
    | Paper, Rock -> true       // Paper beats Rock
    | Scissors, Paper -> true   // Scissors beat Paper
    | _, _ -> false

/// Generates the next move for the computer based on probability derived from previous player moves.
let genMove r p s =
    let tot = r + p + s
    let n = rand
    if n <= s / tot then Rock
    elif n <= (s + r) / tot then Paper
    else Scissors

/// Gets the move chosen by the player
let rec getMove () =
    printf "[R]ock, [P]aper, or [S]cissors?: "
    let choice = Console.ReadLine ()
    match choice with
    | "r" | "R" -> Rock
    | "p" | "P" -> Paper
    | "s" | "S" -> Scissors
    | _ ->
        printf "Invalid choice.\n\n"
        getMove ()

/// Place where all the game logic takes place.
let rec game (r : float, p : float, s : float) =
    let comp = genMove r p s
    let player = getMove ()
    Console.WriteLine ("Player: {0} vs Computer: {1}", getString player, getString comp)
    Console.WriteLine (
        if beats(player, comp) then "Player Wins!\n"
        elif beats(comp, player) then "Computer Wins!\n"
        else "Draw!\n"
    )
    let nextR = if player = Rock then r + 1.0 else r
    let nextP = if player = Paper then p + 1.0 else p
    let nextS = if player = Scissors then s + 1.0 else s
    game (nextR, nextP, nextS)

game(1.0, 1.0, 1.0)
