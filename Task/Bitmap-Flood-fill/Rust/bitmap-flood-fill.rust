/* Naive Rust implementation of RosettaCode's Bitmap/Flood fill excercise.
 *
 * For the sake of simplicity this code reads PPM files (format specification can be found here: http://netpbm.sourceforge.net/doc/ppm.html ).
 * The program assumes that the image has been created by GIMP in PPM ASCII mode and panics at any error.
 *
 * Also this program expects the input file to be in the same directory as the executable and named
 * "input.ppm" and outputs a file in the same directory under the name "output.ppm".
 *
 */

use std::fs::File; // Used for creating/opening files.
use std::io::{BufReader, BufRead, Write}; // Used for reading/writing files.

fn read_image(filename: String) -> Vec<Vec<(u8,u8,u8)>> {
    let file = File::open(filename).unwrap();
    let reader = BufReader::new(file);
    let mut lines = reader.lines();

    let _ = lines.next().unwrap(); // Skip P3 signature.
    let _ = lines.next().unwrap(); // Skip GIMP comment.

    let dimensions: (usize, usize) = {
        let line = lines.next().unwrap().unwrap();
        let values = line.split_whitespace().collect::<Vec<&str>>();

        // We turn the &str vector that holds the width & height of the image into an usize tuplet.
        (values[0].parse::<usize>().unwrap(),values[1].parse::<usize>().unwrap())
    };

    let _ = lines.next().unwrap(); // Skip maximum color value (we assume 255).

    let mut image_data = Vec::with_capacity(dimensions.1);

    for y in 0..dimensions.1 {
        image_data.push(Vec::new());
        for _ in 0..dimensions.0 {
            // We read the R, G and B components and put them in the image_data vector.
            image_data[y].push((lines.next().unwrap().unwrap().parse::<u8>().unwrap(),
                                lines.next().unwrap().unwrap().parse::<u8>().unwrap(),
                                lines.next().unwrap().unwrap().parse::<u8>().unwrap()));
        }
    }

    image_data
}

fn write_image(image_data: Vec<Vec<(u8,u8,u8)>>) {
    let mut file = File::create(format!("./output.ppm")).unwrap();

    // Signature, then width and height, then 255 as max color value.
    write!(file, "P3\n{} {}\n255\n", image_data.len(), image_data[0].len()).unwrap();

    for row in &image_data {
        // For performance reasons, we reserve a String with the necessary length for a line and
        // fill that up before writing it to the file.

        let mut line = String::with_capacity(row.len()*6); // 6 = r(space)g(space)b(space)
        for (r,g,b) in row {

            // &* is used to turn a String into a &str as needed by push_str.
            line.push_str(&*format!("{} {} {} ", r,g,b));
        }

        write!(file, "{}", line).unwrap();
    }

}

fn flood_fill(x: usize, y: usize, target: &(u8,u8,u8), replacement: &(u8,u8,u8), image_data: &mut Vec<Vec<(u8,u8,u8)>>) {
    if &image_data[y][x] == target {
        image_data[y][x] = *replacement;

        if y > 0 {flood_fill(x,y-1, &target, &replacement, image_data);}
        if x > 0 {flood_fill(x-1,y, &target, &replacement, image_data);}
        if y < image_data.len()-1 {flood_fill(x,y+1, &target, &replacement, image_data);}
        if x < image_data[0].len()-1 {flood_fill(x+1,y, &target, &replacement, image_data);}
    }
}

fn main() {
    let mut data = read_image(String::from("./input.ppm"));

    flood_fill(1,50, &(255,255,255), &(0,255,0), &mut data); // Fill the big white circle with green.
    flood_fill(40,35, &(0,0,0), &(255,0,0), &mut data); // Fill the small black circle with red.

    write_image(data);

}
