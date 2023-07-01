use rand::Rng;
use std::io;

#[derive(Clone)]
enum PlayerType {
    Human,
    Computer,
}

#[derive(Clone)]
struct Player {
    name: String,
    wins: u32,  // holds wins
    level: u32, // difficulty level of Computer
    player_type: PlayerType,
}

trait Choose {
    fn choose(&self, game: &Game) -> u8;
}

impl Player {
    fn new(name: &str, player_type: PlayerType, level: u32) -> Player {
        Player {
            name: String::from(name),
            wins: 0,
            level,
            player_type,
        }
    }
    fn get_name(&self) -> &str {
        &self.name[..]
    }
    fn get_level(&self) -> u32 {
        self.level
    }
    fn add_win(&mut self) {
        self.wins += 1
    }
    fn level_up(&mut self) {
        self.level += 1
    }
}

impl Choose for Player {
    fn choose(&self, game: &Game) -> u8 {
        match self.player_type {
            PlayerType::Human => loop {
                let max_choice = game.max_choice();
                match max_choice {
                    1 => println!("Enter a number 1 to win (or quit):"),
                    _ => println!("Enter a number between 1 and {} (or quit):", max_choice)
                }
                let mut guess = String::new();
                io::stdin()
                    .read_line(&mut guess)
                    .expect("Failed to read line");
                if guess.trim() == "quit" {
                    return 0
                }
                let guess: u8 = match guess.trim().parse() {
                    Ok(num) if num >= 1 && num <= max_choice => num,
                    Ok(_) => continue,
                    Err(_) => continue,
                };
                return guess;
            },
            PlayerType::Computer => match self.level {
                5 => match game.get_total() {
                    total if total == 20 => 1,
                    total if total == 19 => 2,
                    total if total == 18 => 3,
                    _ => 1,
                },
                4 => match game.get_total() {
                    total if total == 20 => 1,
                    total if total == 19 => 2,
                    total if total == 18 => 3,
                    _ => rand::thread_rng().gen_range(1, 3),
                },
                3 => match game.get_total() {
                    total if total == 20 => 1,
                    total if total == 19 => 2,
                    total if total == 18 => 3,
                    _ => rand::thread_rng().gen_range(1, 4),
                },
                2 => match game.get_total() {
                    total if total == 20 => 1,
                    total if total == 19 => 2,
                    _ => rand::thread_rng().gen_range(1, 3),
                },
                1 => 1,
                _ => match game.get_total() {
                    total if total == 20 => 1,
                    total if total == 19 => 2,
                    total if total == 18 => 3,
                    _ => match game.get_remaining() % 4 {
                        0 => rand::thread_rng().gen_range(1, 4),
                        _ => game.get_remaining() % 4,
                    },
                },
            },
        }
    }
}

struct Game {
    players: Vec<Player>,
    turn: u8,
    total: u8,
    start: u8, // determines which player goes first
}

impl Game {
    fn init(players: &Vec<Player>) -> Game {
        Game {
            players: players.to_vec(),
            turn: 1,
            total: 0,
            start: rand::thread_rng().gen_range(0, 2),
        }
    }
    fn play(&mut self) -> &Player {
        loop {
            println!(
                "Total now {} (remaining: {})",
                self.get_total(),
                self.get_remaining()
            );
            {
                let player = self.whose_turn();
                println!("Turn: {} ({} turn)", self.get_turn(), player.get_name());
                let choice = player.choose(&self);
                if choice == 0 {
                    self.next_turn();
                    break; // quit
                }
                println!("{} choose {}", player.get_name(), choice);
                self.add_total(choice)
            }
            if self.get_total() >= 21 {
                break;
            }
            println!("");
            self.next_turn();
        }
        self.whose_turn()
    }
    fn add_total(&mut self, choice: u8) {
        self.total += choice;
    }
    fn next_turn(&mut self) {
        self.turn += 1;
    }
    fn whose_turn(&self) -> &Player {
        let index: usize = ((self.turn + self.start) % 2).into();
        &self.players[index]
    }
    fn get_total(&self) -> u8 {
        self.total
    }
    fn get_remaining(&self) -> u8 {
        21 - self.total
    }
    fn max_choice(&self) -> u8 {
        match self.get_remaining() {
            1 => 1,
            2 => 2,
            _ => 3
        }
    }
    fn get_turn(&self) -> u8 {
        self.turn
    }
}

fn main() {
    let mut game_count = 0;
    let mut players = vec![
        Player::new("human", PlayerType::Human, 0),
        Player::new("computer", PlayerType::Computer, 1),
    ];
    println!("21 Game");
    println!("Press enter key to start");
    {
        let _ = io::stdin().read_line(&mut String::new());
    }
    loop {
        game_count += 1;
        let mut game = Game::init(&players);
        let winner = game.play();
        {
            let mut index = 0;
            while index < players.len() {
                if players[index].get_name() == winner.get_name() {
                    players[index].add_win();
                }
                index += 1
            }
        }
        println!("\n{} won game {}\n", winner.get_name(), game_count);
        // limit game count
        if game_count >= 10000 {
            break;
        }
        // ask player if they want to keep on playing
        println!("Press enter key to play again (or quit):");
        let mut reply = String::new();
        io::stdin()
            .read_line(&mut reply)
            .expect("Failed to read line");
        if reply.trim() == "quit" {
            break;
        }
        // level up computer
        if winner.get_name() != "computer" {
            println!("Computer leveling up ...");
            players[1].level_up();
            println!("Computer now level {}!", players[1].get_level());
            println!("Beware!\n");
        }
    }
    println!("player: {} win: {}", players[0].get_name(), players[0].wins);
    println!("player: {} win: {}", players[1].get_name(), players[1].wins);
}
