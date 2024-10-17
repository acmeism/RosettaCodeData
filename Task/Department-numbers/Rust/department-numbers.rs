extern crate num_iter;
fn main() {
    println!("Police Sanitation Fire");
    println!("----------------------");

    for police in num_iter::range_step(2, 7, 2) {
        for sanitation in 1..8 {
            for fire in 1..8 {
                if police != sanitation
                    && sanitation != fire
                    && fire != police
                    && police + fire + sanitation == 12
                {
                    println!("{:6}{:11}{:4}", police, sanitation, fire);
                }
            }
        }
    }
}
