// This is the main algorithm.
//
// It loops over the current state of the sandpile and updates it on-the-fly.
fn advance(field: &mut Vec<Vec<usize>>, boundary: &mut [usize; 4]) -> bool
{
    // This variable is used to check whether we changed anything in the array. If no, the loop terminates.
    let mut done = false;

    for y in boundary[0]..boundary[2]
    {
        for x in boundary[1]..boundary[3]
        {
            if field[y][x] >= 4
            {
                // This part was heavily inspired by the Pascal version. We subtract 4 as many times as we can
                // and distribute it to the neighbors. Also, in case we have outgrown the current boundary, we
                // update it to once again contain the entire sandpile.

                // The amount that gets added to the neighbors is the amount here divided by four and (implicitly) floored.
                // The remaining sand is just current modulo 4.
                let rem: usize = field[y][x] / 4;
                field[y][x] %= 4;

                // The isize casts are necessary because usize can not go below 0.
                // Also, the reason why x and y are compared to boundary[2]-1 and boundary[3]-1 is because for loops in
                // Rust are upper bound exclusive. This means a loop like 0..5 will only go over 0,1,2,3 and 4.
                if y as isize - 1 >= 0 {field[y-1][x] += rem; if y == boundary[0] {boundary[0]-=1;}}
                if x as isize - 1 >= 0 {field[y][x-1] += rem; if x == boundary[1] {boundary[1]-=1;}}
                if y+1 < field.len() {field[y+1][x] += rem; if x == boundary[2]-1 {boundary[2]+=1;}}
                if x+1 < field.len() {field[y][x+1] += rem; if y == boundary[3]-1 {boundary[3]+=1;}}

                done = true;
            }
        }
    }

    done
}

// This function can be used to display the sandpile in the console window.
//
// Each row is mapped onto chars and those characters are then collected into a string.
// These are then printed to the console.
//
// Eg.: [0,1,1,2,3,0] -> [' ','░','░','▒','▓',' ']-> " ░░▒▓ "
fn display(field: &Vec<Vec<usize>>)
{
    for row in field
    {
        let char_row = {
            row.iter().map(|c| {match c {
                0 => ' ',
                1 => '░',
                2 => '▒',
                3 => '▓',
                _ => '█'
            }}).collect::<String>()
        };
        println!("{}", char_row);
    }
}

// This function writes the end result to a file called "output.ppm".
//
// PPM is a very simple image format, however, it entirely uncompressed which leads to huge image sizes.
// Even so, for demonstrative purposes it's perfectly good to use. For something more robust, look into PNG libraries.
//
// Read more about the format here: http://netpbm.sourceforge.net/doc/ppm.html
fn write_pile(pile: &Vec<Vec<usize>>) {
    use std::fs::File;
    use std::io::Write;

    // We first create the file (or erase its contents if it already existed).
    let mut file = File::create("./output.ppm").unwrap();

    // Then we add the image signature, which is "P3 <newline>[width of image] [height of image]<newline>[maximum value of color]<newline>".
    write!(file, "P3\n{} {}\n255\n", pile.len(), pile.len()).unwrap();

    for row in pile {
        // For each row, we create a new string which has more or less enough capacity to hold the entire row.
        // This is for performance purposes, but shouldn't really matter much.
        let mut line = String::with_capacity(row.len() * 14);

        // We map each value in the field to a color.
        // These are just simple RGB values, 0 being the background, the rest being the "sand" itself.
        for elem in row {
            line.push_str(match elem {
                0 => "100 40 15 ",
                1 => "117 87 30 ",
                2 => "181 134 47 ",
                3 => "245 182 66 ",
                _ => unreachable!(),
            });
        }

        // Finally we write this string into the file.
        write!(file, "{}\n", line).unwrap();
    }
}

fn main() {
    // This is how big the final image will be. Currently the end result would be a 16x16 picture.
    let field_size = 16;
    let mut playfield = vec![vec![0; field_size]; field_size];

    // We put the initial sand in the exact middle of the field.
    // This isn't necessary per se, but it ensures that sand can fully topple.
    //
    // The boundary is initially just the single tile which has the sand in it, however, as the algorithm
    // progresses, this will grow larger too.
    let mut boundary = [field_size/2-1, field_size/2-1, field_size/2, field_size/2];
    playfield[field_size/2 - 1][field_size/2 - 1] = 16;

    // This is the main loop. We update the field until it returns false, signalling that the pile reached its
    // final state.
    while advance(&mut playfield, &mut boundary) {};

    // Once this happens, we simply display the result. Uncomment the line below to write it to a file.
    // Calling display with large field sizes is not recommended as it can easily become too large for the console.
    display(&playfield);
    //write_pile(&playfield);
}
