use rand::seq::SliceRandom;
use rand::rng;

fn generate_chess960() -> String {
    let mut rng = rng();

    loop {
        let mut pieces = vec!['♛', '♜', '♜', '♜', '♝', '♝', '♞', '♞'];
        pieces.shuffle(&mut rng);

        let bishops: Vec<usize> = pieces.iter()
            .enumerate()
            .filter(|&(_, p)| *p == '♝')
            .map(|(i, _)| i)
            .collect();

        if bishops.len() == 2 && bishops[0] % 2 != bishops[1] % 2 {
            let mut rooks: Vec<usize> = pieces.iter()
                .enumerate()
                .filter(|&(_, p)| *p == '♜')
                .map(|(i, _)| i)
                .collect();

            rooks.sort();  // Sort to locate the middle rook
            let middle_rook = rooks[1];  // Promote the second rook to King
            pieces[middle_rook] = '♚';  // Replace middle rook with King

            return pieces.iter().collect();
        }
    }
}

fn main() {
    let position = generate_chess960();
    println!("Chess960 Position: {position}");
}
