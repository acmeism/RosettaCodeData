use rand::prelude::*;

fn main() {
    println!("Beginning game of Pig...");

    let mut players = vec![
        Player::new(String::from("PLAYER (1) ONE")),
        Player::new(String::from("PLAYER (2) TWO")),
    ];

    'game: loop {
        for player in players.iter_mut() {
            if player.cont() {
                println!("\n# {} has {:?} Score", player.name, player.score);
                player.resolve();
            } else {
                println!("\n{} wins!", player.name);
                break 'game;
            }
        }
    }

    println!("Thanks for playing!");
}

type DiceRoll = u32;
type Score = u32;
type Name = String;

enum Action {
    Roll,
    Hold,
}

#[derive(PartialEq)]
enum TurnStatus {
    Continue,
    End,
}

struct Player {
    name: Name,
    score: Score,
    status: TurnStatus,
}

impl Player {
    fn new(name: Name) -> Player {
        Player {
            name,
            score: 0,
            status: TurnStatus::Continue,
        }
    }

    fn roll() -> DiceRoll {
        // Simple 1d6 dice.
        let sides = rand::distributions::Uniform::new(1, 6);
        rand::thread_rng().sample(sides)
    }

    fn action() -> Action {
        // Closure to determine userinput as action.
        let command = || -> Option<char> {
            let mut cmd: String = String::new();
            match std::io::stdin().read_line(&mut cmd) {
                Ok(c) => c.to_string(),
                Err(err) => panic!("Error: {}", err),
            };

            cmd.to_lowercase().trim().chars().next()
        };

        'user_in: loop {
            match command() {
                Some('r') => break 'user_in Action::Roll,
                Some('h') => break 'user_in Action::Hold,
                Some(invalid) => println!("{} is not a valid command!", invalid),
                None => println!("Please input a command!"),
            }
        }
    }

    fn turn(&mut self) -> Score {
        let one = |die: DiceRoll| {
            println!("[DICE] Dice result is: {:3}!", die);
            println!("[DUMP] Dumping Score! Sorry!");
            println!("###### ENDING TURN ######");
        };

        let two_to_six = |die: DiceRoll, score: Score, player_score: Score| {
            println!("[DICE] Dice result is: {:3}!", die);
            println!("[ROLL] Total    Score: {:3}!", (score + die));
            println!("[HOLD] Possible Score: {:3}!", (score + die + player_score));
        };

        let mut score: Score = 0;
        'player: loop {
            println!("# {}'s Turn", self.name);
            println!("######  [R]oll   ######\n######  --OR--   ######\n######  [H]old   ######");

            match Player::action() {
                Action::Roll => match Player::roll() {
                    0 | 7..=u32::MAX => panic!("outside dice bounds!"),
                    die @ 1 => {
                        one(die);
                        self.status = TurnStatus::End;
                        break 'player 0;
                    }
                    die @ 2..=6 => {
                        two_to_six(die, score, self.score);
                        self.status = TurnStatus::Continue;
                        score += die
                    }
                },
                Action::Hold => {
                    self.status = TurnStatus::End;
                    break 'player score;
                }
            }
        }
    }

    fn resolve(&mut self) {
        self.score += self.turn()
    }

    fn cont(&self) -> bool {
        self.score <= 100 || self.status == TurnStatus::Continue
    }
}
