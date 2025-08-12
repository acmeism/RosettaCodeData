use std::collections::HashMap;

fn trim(s: &str) -> &str {
    s.trim()
}

// Helper function to create the left digits map
fn create_left_digits() -> HashMap<&'static str, i32> {
    let mut map = HashMap::new();
    map.insert("   ## #", 0);
    map.insert("  ##  #", 1);
    map.insert("  #  ##", 2);
    map.insert(" #### #", 3);
    map.insert(" #   ##", 4);
    map.insert(" ##   #", 5);
    map.insert(" # ####", 6);
    map.insert(" ### ##", 7);
    map.insert(" ## ###", 8);
    map.insert("   # ##", 9);
    map
}

// Helper function to create the right digits map
fn create_right_digits() -> HashMap<&'static str, i32> {
    let mut map = HashMap::new();
    map.insert("###  # ", 0);
    map.insert("##  ## ", 1);
    map.insert("## ##  ", 2);
    map.insert("#    # ", 3);
    map.insert("# ###  ", 4);
    map.insert("#  ### ", 5);
    map.insert("# #    ", 6);
    map.insert("#   #  ", 7);
    map.insert("#  #   ", 8);
    map.insert("### #  ", 9);
    map
}

const END_SENTINEL: &str = "# #";
const MID_SENTINEL: &str = " # # ";

fn decode_upc(input: &str) {
    let left_digits = create_left_digits();
    let right_digits = create_right_digits();

    let decode = |candidate: &str| -> (bool, Vec<i32>) {
        let mut output = Vec::new();
        let mut pos = 0;

        // Check start sentinel
        if candidate.len() < pos + END_SENTINEL.len() {
            return (false, output);
        }
        let part = &candidate[pos..pos + END_SENTINEL.len()];
        if part == END_SENTINEL {
            pos += END_SENTINEL.len();
        } else {
            return (false, output);
        }

        // Decode left 6 digits
        for _ in 0..6 {
            if candidate.len() < pos + 7 {
                return (false, output);
            }
            let part = &candidate[pos..pos + 7];
            pos += 7;

            if let Some(&digit) = left_digits.get(part) {
                output.push(digit);
            } else {
                return (false, output);
            }
        }

        // Check middle sentinel
        if candidate.len() < pos + MID_SENTINEL.len() {
            return (false, output);
        }
        let part = &candidate[pos..pos + MID_SENTINEL.len()];
        if part == MID_SENTINEL {
            pos += MID_SENTINEL.len();
        } else {
            return (false, output);
        }

        // Decode right 6 digits
        for _ in 0..6 {
            if candidate.len() < pos + 7 {
                return (false, output);
            }
            let part = &candidate[pos..pos + 7];
            pos += 7;

            if let Some(&digit) = right_digits.get(part) {
                output.push(digit);
            } else {
                return (false, output);
            }
        }

        // Check end sentinel
        if candidate.len() < pos + END_SENTINEL.len() {
            return (false, output);
        }
        let part = &candidate[pos..pos + END_SENTINEL.len()];
        if part == END_SENTINEL {
            pos += END_SENTINEL.len();
        } else {
            return (false, output);
        }

        // Calculate checksum
        let sum: i32 = output.iter().enumerate().map(|(i, &digit)| {
            if i % 2 == 0 {
                3 * digit
            } else {
                digit
            }
        }).sum();

        (sum % 10 == 0, output)
    };

    let candidate = trim(input);

    let (valid, digits) = decode(candidate);
    if valid {
        println!("{:?}", digits);
    } else {
        // Try upside down
        let reversed: String = candidate.chars().rev().collect();
        let (valid_reversed, digits_reversed) = decode(&reversed);
        if valid_reversed {
            println!("{:?} Upside down", digits_reversed);
        } else if !digits.is_empty() {
            println!("Invalid checksum");
        } else {
            println!("Invalid digit(s)");
        }
    }
}

fn main() {
    let barcodes = vec![
        "         # #   # ##  #  ## #   ## ### ## ### ## #### # # # ## ##  #   #  ##  ## ###  # ##  ## ### #  # #       ",
        "        # # #   ##   ## # #### #   # ## #   ## #   ## # # # ###  # ###  ##  ## ###  # #  ### ###  # # #         ",
        "         # #    # # #  ###  #   #    # #  #   #    # # # # ## #   ## #   ## #   ##   # # #### ### ## # #         ",
        "       # # ##  ## ##  ##   #  #   #  # ###  # ##  ## # # #   ## ##  #  ### ## ## #   # #### ## #   # #        ",
        "         # # ### ## #   ## ## ###  ##  # ##   #   # ## # # ### #  ## ##  #    # ### #  ## ##  #      # #          ",
        "          # #  #   # ##  ##  #   #   #  # ##  ##  #   # # # # #### #  ##  # #### #### # #  ##  # #### # #         ",
        "         # #  #  ##  ##  # #   ## ##   # ### ## ##   # # # #  #   #   #  #  ### # #    ###  # #  #   # #        ",
        "        # # #    # ##  ##   #  # ##  ##  ### #   #  # # # ### ## ## ### ## ### ### ## #  ##  ### ## # #         ",
        "         # # ### ##   ## # # #### #   ## # #### # #### # # #   #  # ###  #    # ###  # #    # ###  # # #       ",
        "        # # # #### ##   # #### # #   ## ## ### #### # # # #  ### # ###  ###  # # ###  #    # #  ### # #         ",
    ];

    for barcode in &barcodes {
        decode_upc(barcode);
    }
}
