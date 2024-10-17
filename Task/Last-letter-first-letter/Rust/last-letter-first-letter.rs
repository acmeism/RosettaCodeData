/// # Panics
///
/// If string is empty.
fn first_char(string: &str) -> char {
    string.chars().next().unwrap()
}

/// # Panics
///
/// If string is empty.
fn first_and_last_char(string: &str) -> (char, char) {
    (
        first_char(string),
        first_char(string.rmatches(|_: char| true).next().unwrap()),
    )
}

struct Pokemon {
    name: &'static str,
    first: char,
    last: char,
}

impl Pokemon {
    fn new(name: &'static str) -> Pokemon {
        let (first, last) = first_and_last_char(name);
        Pokemon { name, first, last }
    }
}

#[derive(Default)]
struct App {
    max_path_length: usize,
    max_path_length_count: usize,
    max_path_example: Vec<&'static str>,
    pokemon: Vec<Pokemon>,
}

impl App {
    fn search(&mut self, offset: usize) {
        if offset > self.max_path_length {
            self.max_path_length = offset;
            self.max_path_length_count = 1;
        } else if offset == self.max_path_length {
            self.max_path_length_count += 1;
            self.max_path_example.clear();
            self.max_path_example.extend(
                self.pokemon[0..offset]
                    .iter()
                    .map(|Pokemon { name, .. }| *name),
            );
        }

        let last_char = self.pokemon[offset - 1].last;
        for i in offset..self.pokemon.len() {
            if self.pokemon[i].first == last_char {
                self.pokemon.swap(offset, i);
                self.search(offset + 1);
                self.pokemon.swap(offset, i);
            }
        }
    }
}

fn main() {
    let pokemon_names = [
        "audino",
        "bagon",
        "baltoy",
        "banette",
        "bidoof",
        "braviary",
        "bronzor",
        "carracosta",
        "charmeleon",
        "cresselia",
        "croagunk",
        "darmanitan",
        "deino",
        "emboar",
        "emolga",
        "exeggcute",
        "gabite",
        "girafarig",
        "gulpin",
        "haxorus",
        "heatmor",
        "heatran",
        "ivysaur",
        "jellicent",
        "jumpluff",
        "kangaskhan",
        "kricketune",
        "landorus",
        "ledyba",
        "loudred",
        "lumineon",
        "lunatone",
        "machamp",
        "magnezone",
        "mamoswine",
        "nosepass",
        "petilil",
        "pidgeotto",
        "pikachu",
        "pinsir",
        "poliwrath",
        "poochyena",
        "porygon2",
        "porygonz",
        "registeel",
        "relicanth",
        "remoraid",
        "rufflet",
        "sableye",
        "scolipede",
        "scrafty",
        "seaking",
        "sealeo",
        "silcoon",
        "simisear",
        "snivy",
        "snorlax",
        "spoink",
        "starly",
        "tirtouga",
        "trapinch",
        "treecko",
        "tyrogue",
        "vigoroth",
        "vulpix",
        "wailord",
        "wartortle",
        "whismur",
        "wingull",
        "yamask",
    ];

    let mut app = App {
        pokemon: pokemon_names
            .iter()
            .map(|name| Pokemon::new(name))
            .collect(),
        ..App::default()
    };

    for i in 0..app.pokemon.len() {
        app.pokemon.swap(0, i);
        app.search(1);
        app.pokemon.swap(0, i);
    }

    println!("Maximum path length: {}", app.max_path_length);
    println!("Paths of that length: {}", app.max_path_length_count);
    println!(
        "Example path of that length: {}",
        app.max_path_example.join(" "),
    );
}
