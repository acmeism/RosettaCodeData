use std::env;
use std::fs::File;
use std::io::{self, BufRead, BufReader, BufWriter, Read, Write};
use std::path::Path;
use std::process;

// --- Data Structures ---

// Equivalent to rgb_t
#[derive(Clone, Copy, Debug, Default)]
#[repr(C)] // Ensure memory layout is R, G, B for potential raw I/O
struct Rgb {
    r: u8,
    g: u8,
    b: u8,
}

// Equivalent to image_t, but using Vec for safe memory management
#[derive(Debug)]
struct Image {
    width: usize,
    height: usize,
    pixels: Vec<Rgb>, // Flat pixel buffer
}

impl Image {
    // Creates a new black image
    fn new(width: usize, height: usize) -> Self {
        Image {
            width,
            height,
            pixels: vec![Rgb::default(); width * height],
        }
    }

    // Helper to get a pixel reference (immutable)
    fn get_pixel(&self, row: usize, col: usize) -> Option<&Rgb> {
        if row < self.height && col < self.width {
            self.pixels.get(row * self.width + col)
        } else {
            None
        }
    }

    // Helper to get a pixel reference (mutable)
    fn get_pixel_mut(&mut self, row: usize, col: usize) -> Option<&mut Rgb> {
        if row < self.height && col < self.width {
            self.pixels.get_mut(row * self.width + col)
        } else {
            None
        }
    }

    // Helper for direct index access (use with caution or after bounds check)
    fn index(&self, row: usize, col: usize) -> usize {
        row * self.width + col
    }
}

// Equivalent to color_histo_t
#[derive(Debug)]
struct ColorHisto {
    r: [i32; 256],
    g: [i32; 256],
    b: [i32; 256],
    n: i32, // Total number of pixels counted
}

impl ColorHisto {
    fn new() -> Self {
        ColorHisto {
            r: [0; 256],
            g: [0; 256],
            b: [0; 256],
            n: 0,
        }
    }

    // Add a pixel's color to the histogram
    fn add_pixel(&mut self, pixel: Rgb) {
        self.r[pixel.r as usize] += 1;
        self.g[pixel.g as usize] += 1;
        self.b[pixel.b as usize] += 1;
        self.n += 1;
    }

    // Remove a pixel's color from the histogram
    fn del_pixel(&mut self, pixel: Rgb) {
        self.r[pixel.r as usize] -= 1;
        self.g[pixel.g as usize] -= 1;
        self.b[pixel.b as usize] -= 1;
        self.n -= 1;
    }
}

// --- PPM Reading/Writing ---

// Helper to read ASCII numbers, skipping comments and whitespace
// This is more robust than the C version's reliance on fscanf specifics.
fn read_ascii_int<R: BufRead>(reader: &mut R) -> io::Result<usize> {
    let mut buf = Vec::new();
    let mut digits = Vec::new();

    loop {
        buf.clear();
        // Read until comment or EOF. Limit read size to avoid large allocations on invalid input.
        // reader.read_until(b'#', &mut buf)?; // Reads potentially large chunks

        // Read byte by byte for finer control over comments and whitespace
        let byte_read = reader.read_until(b'#', &mut buf);
        match byte_read {
            Ok(0) => break, // EOF
            Ok(_) => {},
            Err(e) => return Err(e),
        }


        // Process non-comment part
        let mut comment_found = false;
        for &byte in &buf {
             if byte == b'#' {
                 comment_found = true;
                 // Skip the rest of the comment line
                 reader.read_until(b'\n', &mut Vec::new())?;
                 // Reset digits found before comment on the same "line"
                 // only if we haven't added non-whitespace digits yet.
                 // Check if the last character ADDED (if any) was whitespace.
                 // If digits is empty OR the last added char was whitespace, clear.
                 // --- FIX START ---
                 if digits.last().map_or(true, |last_byte_ref| last_byte_ref.is_ascii_whitespace()) {
                 // --- FIX END ---
                     digits.clear();
                 }
                 break; // Process next chunk read after comment
             } else if byte.is_ascii_whitespace() {
                if !digits.is_empty() {
                    // Found whitespace after digits, we have our number
                    let s = String::from_utf8(digits).map_err(|e| io::Error::new(io::ErrorKind::InvalidData, e))?;
                    return s.trim().parse::<usize>().map_err(|e| io::Error::new(io::ErrorKind::InvalidData, e));
                }
                // Skip leading/multiple whitespace by not adding it to `digits`
            } else if byte.is_ascii_digit() {
                digits.push(byte);
            } else {
                 return Err(io::Error::new(
                    io::ErrorKind::InvalidData,
                    "Non-digit, non-whitespace, non-comment character found in numeric header field",
                ));
            }
        }

        // If we broke loop due to '#', continue reading after comment
        if comment_found {
            continue;
        }

        // If we reached EOF after reading the buffer
        if buf.is_empty() { // EOF confirmed by read_until returning 0 earlier
            if digits.is_empty() { // EOF before finding any digits
                return Err(io::Error::new(io::ErrorKind::UnexpectedEof, "EOF while reading number"));
            } else { // Reached EOF after finding digits
                let s = String::from_utf8(digits).map_err(|e| io::Error::new(io::ErrorKind::InvalidData, e))?;
                return s.trim().parse::<usize>().map_err(|e| io::Error::new(io::ErrorKind::InvalidData, e));
            }
        }
         // else: finished processing buffer without finding whitespace after digits, continue loop
    }

    // Handle case where file ends immediately after digits without trailing whitespace/comment
    if !digits.is_empty() {
       let s = String::from_utf8(digits).map_err(|e| io::Error::new(io::ErrorKind::InvalidData, e))?;
       s.trim().parse::<usize>().map_err(|e| io::Error::new(io::ErrorKind::InvalidData, e))
    } else {
       // This state should ideally be unreachable due to EOF checks above, but acts as a safeguard
       Err(io::Error::new(io::ErrorKind::UnexpectedEof, "EOF or invalid state reading number"))
    }
}


fn read_ppm(filename: &str) -> io::Result<Image> {
    let file = File::open(filename)?;
    let mut reader = BufReader::new(file);

    let mut magic = [0u8; 2];
    reader.read_exact(&mut magic)?;
    if &magic != b"P6" {
        return Err(io::Error::new(
            io::ErrorKind::InvalidData,
            "Not a P6 PPM file",
        ));
    }

    // Consume the first whitespace/comment after P6, needed before reading width.
    // read_ascii_int handles subsequent whitespace/comments.
    let mut header_byte = [0u8; 1];
    loop {
        reader.read_exact(&mut header_byte)?;
        if header_byte[0] == b'#' {
            reader.read_until(b'\n', &mut Vec::new())?; // Skip comment line
        } else if header_byte[0].is_ascii_whitespace() {
            break; // Found the required whitespace separator
        } else {
            return Err(io::Error::new(
                io::ErrorKind::InvalidData,
                "Expected whitespace or comment after P6 magic number",
            ));
        }
    }


    let width = read_ascii_int(&mut reader)?;
    let height = read_ascii_int(&mut reader)?;
    let maxval = read_ascii_int(&mut reader)?;

    if width == 0 || height == 0 {
        return Err(io::Error::new(
            io::ErrorKind::InvalidData,
            "Invalid image dimensions (width or height is zero)",
        ));
    }
    if maxval != 255 {
        // Technically PGM/PPM allow other maxvals, but this code assumes 255.
        return Err(io::Error::new(
            io::ErrorKind::InvalidData,
            "Max color value must be 255 for this implementation",
        ));
    }

    // Read the single whitespace character separating header from data
    let mut header_end = [0u8; 1];
     // Consume any remaining whitespace/comments after maxval before the final newline/space
     loop {
         reader.read_exact(&mut header_end)?;
         if header_end[0] == b'#' {
             reader.read_until(b'\n', &mut Vec::new())?;
         } else if header_end[0].is_ascii_whitespace() {
             // Check if it's the required single whitespace char
             if header_end[0] == b'\n' || header_end[0] == b' ' || header_end[0] == b'\t' || header_end[0] == b'\r' {
                 break; // Found it
             } // else keep reading whitespace if needed (though standard expects one)
         } else {
             return Err(io::Error::new(
                 io::ErrorKind::InvalidData,
                 "Expected single whitespace after maxval before pixel data",
             ));
         }
     }


    let mut image = Image::new(width, height);
    let pixel_count = width * height;
    let byte_count = pixel_count * 3;

    // Read pixel data directly into a Vec<u8> first
    let mut byte_buffer = vec![0u8; byte_count];
    reader.read_exact(&mut byte_buffer)?;


    // Convert bytes to Rgb structs - Optimized
    // Safety: We know byte_buffer.len() == image.pixels.len() * 3
    // Using chunks_exact is efficient and safe.
    let mut pixel_iter = image.pixels.iter_mut();
    for chunk in byte_buffer.chunks_exact(3) {
        if let Some(pixel) = pixel_iter.next() {
            pixel.r = chunk[0];
            pixel.g = chunk[1];
            pixel.b = chunk[2];
        } else {
             // Should not happen if counts are correct
             return Err(io::Error::new(io::ErrorKind::InvalidData, "Pixel data size mismatch (internal error)"));
        }
    }

    // Check for extra data after pixel data (optional, can indicate malformed file)
    // let mut extra = [0u8; 1];
    // if reader.read(&mut extra)? > 0 {
    //     eprintln!("Warning: Extra data found after pixel data in PPM file.");
    // }

    Ok(image)
}

fn write_ppm(image: &Image, filename: &str) -> io::Result<()> {
    let file = File::create(filename)?;
    let mut writer = BufWriter::new(file);

    write!(writer, "P6\n{} {}\n255\n", image.width, image.height)?;

    // Write pixel data - Optimized
    // Create a byte buffer directly from the pixel data
    let byte_buffer: Vec<u8> = image.pixels
        .iter()
        .flat_map(|p| [p.r, p.g, p.b])
        .collect();

    writer.write_all(&byte_buffer)?;
    writer.flush()?; // Ensure all data is written

    Ok(())
}

// --- Median Filter Logic ---

// Add pixels in a vertical column segment to the histogram
fn add_pixels(
    im: &Image,
    row: isize, // Use isize for calculations involving size subtraction
    col: usize,
    size: isize,
    h: &mut ColorHisto,
) {
    if col >= im.width {
        return;
    }
    // Calculate row bounds carefully using isize before converting to usize
    let start_row = (row - size).max(0) as usize;
    // Ensure end_row doesn't wrap around if row+size is huge
    let end_row_isize = (row + size).min(im.height as isize - 1);
    if end_row_isize < start_row as isize { // Should not happen if size >= 0
        return;
    }
    let end_row = end_row_isize as usize;


    for i in start_row..=end_row {
         // We already checked col < im.width and i is within [0, im.height)
         if let Some(pixel) = im.get_pixel(i, col) { // Use get_pixel for safety just in case
             h.add_pixel(*pixel);
         }
    }
}

// Delete pixels in a vertical column segment from the histogram
fn del_pixels(
    im: &Image,
    row: isize,
    col: usize, // Column index must be valid if called
    size: isize,
    h: &mut ColorHisto,
) {
    // Assume col is valid (checked by caller usually, like `if remove_col_idx >= 0`)
     if col >= im.width { // Still good practice to check upper bound
        return;
     }

    let start_row = (row - size).max(0) as usize;
    let end_row_isize = (row + size).min(im.height as isize - 1);
     if end_row_isize < start_row as isize {
        return;
    }
    let end_row = end_row_isize as usize;

    for i in start_row..=end_row {
         if let Some(pixel) = im.get_pixel(i, col) {
             h.del_pixel(*pixel);
         }
    }
}

// Initialize histogram for the start of a row
fn init_histo(im: &Image, row: isize, size: isize, h: &mut ColorHisto) {
    *h = ColorHisto::new(); // Reset histogram

    // Calculate the initial window columns (0 to size)
    // Ensure end_col doesn't exceed width-1
    let end_col = (size as usize).min(im.width.saturating_sub(1));

    for j in 0..=end_col {
        add_pixels(im, row, j, size, h);
    }
}

// Find the median value in a single channel histogram array
fn median(x: &[i32; 256], n: i32) -> u8 {
    if n <= 0 {
        return 0; // Handle empty or invalid histogram state
    }
    let mut count = 0;
    // Target count to find the median element
    // For even n, this finds the lower median (e.g., for [1,2,3,4], n=4, n/2=2, stops at 2)
    // For odd n, this finds the exact median (e.g., for [1,2,3], n=3, n/2=1, stops at 2)
    let threshold = n / 2;
    for i in 0..256 {
        count += x[i];
        // Use > threshold because we want the first bin where cumulative count EXCEEDS n/2
        if count > threshold {
            return i as u8;
        }
    }
    // If n > 0, should have returned. If loop finishes, it implies n was 0
    // or data is skewed (e.g., all counts were 0, which shouldn't happen if n > 0).
    // Return 255 as a fallback, though 0 might also be reasonable if n was 0.
    255
}

// Calculate the median color using the histogram
fn median_color(h: &ColorHisto) -> Rgb {
    Rgb {
        r: median(&h.r, h.n),
        g: median(&h.g, h.n),
        b: median(&h.b, h.n),
    }
}

// Apply median filter
fn median_filter(input: &Image, size: usize) -> Image {
    let mut output = Image::new(input.width, input.height);
    let mut h = ColorHisto::new();
    let size_isize = size as isize; // Use isize for calculations

    if input.width == 0 || input.height == 0 {
        return output; // Return empty image if input is empty
    }

    for row in 0..input.height {
        let row_isize = row as isize;
        // Reset histogram at the start of each row
        h = ColorHisto::new();

        for col in 0..input.width {
            if col == 0 {
                // Initialize histogram for the first pixel window of the row
                init_histo(input, row_isize, size_isize, &mut h);
            } else {
                // Slide the window: remove leftmost column, add rightmost column

                // Column index to remove (can be negative if window is near left edge)
                let remove_col_idx = col as isize - size_isize - 1;
                // Column index to add (can be >= width if window is near right edge)
                let add_col_idx = col as isize + size_isize;

                // del_pixels handles bounds check for remove_col_idx < 0 internally (no-op)
                // We only need to check if it's a valid index >= 0 before calling
                if remove_col_idx >= 0 {
                     del_pixels(input, row_isize, remove_col_idx as usize, size_isize, &mut h);
                }
                // add_pixels handles bounds check for add_col_idx >= width internally (no-op)
                // No need for explicit check here, add_pixels takes usize and handles it.
                add_pixels(input, row_isize, add_col_idx as usize, size_isize, &mut h);
            }

            // Calculate median for the center pixel (current row, col) and write to output
            // Ensure the histogram is not empty before calculating median
             if h.n > 0 {
                 if let Some(out_pixel) = output.get_pixel_mut(row, col) {
                     *out_pixel = median_color(&h);
                 }
            } else {
                 // This might happen if the window size is very large relative to image dimensions
                 // or near edges with empty columns added/removed. Output black or default pixel.
                 if let Some(out_pixel) = output.get_pixel_mut(row, col) {
                     *out_pixel = Rgb::default();
                 }
                 // Can add a warning here if needed: eprintln!("Warning: Empty histogram at ({}, {})", row, col);
            }
        }
    }

    output
}

// --- Main Function ---

fn main() -> io::Result<()> {
    let args: Vec<String> = env::args().collect();

    if args.len() <= 3 {
        eprintln!("Usage: {} <size> <ppm_in> <ppm_out>", args[0]);
        process::exit(1);
    }

    let size: usize = match args[1].parse() {
        Ok(s) if s > 0 => s, // Median filter radius usually non-zero
        Ok(_) => { // Allow size 0 (no filtering), though typically size >= 1
             eprintln!("Warning: Filter size is 0. Output will be same as input.");
             0
        }
        Err(_) => {
            eprintln!("Error: Filter size must be a non-negative integer.");
            process::exit(1);
        }
    };

    let input_filename = &args[2];
    let output_filename = &args[3];

    println!(
        "Reading input file: {} with filter size {}",
        input_filename, size
    );
    let input_image = read_ppm(input_filename).map_err(|e| {
        eprintln!("Error reading input file '{}': {}", input_filename, e);
        process::exit(1); // Exit on read error
    })?;

    println!(
        "Applying median filter (window radius {}, diameter {})...",
        size, 2 * size + 1
    );
    let output_image = median_filter(&input_image, size);

    println!("Writing output file: {}", output_filename);
    write_ppm(&output_image, output_filename).map_err(|e| {
        eprintln!("Error writing output file '{}': {}", output_filename, e);
        process::exit(1); // Exit on write error
    })?;

    println!("Done.");
    Ok(())
}
