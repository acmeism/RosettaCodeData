use std::collections::HashSet;
// use std::fmt; // Removed unused import

// --- Type Aliases ---
type OneLine = Vec<u32>;
type Cycles = Vec<OneLine>;

// --- Permutation Struct ---
struct Permutation {
    letters_count: u32,
}

impl Permutation {
    // Initialise the length of the strings to be permuted.
    fn new(letters_size: u32) -> Self {
        Permutation {
            letters_count: letters_size,
        }
    }

    // Return the permutation in one line form that transforms the string 'source' into the string 'destination'.
    fn create_one_line(&self, source: &str, destination: &str) -> OneLine {
        let mut result = Vec::new();
        for ch in destination.chars() {
            // find() returns 0-based index, add 1 for 1-based indexing
            if let Some(pos) = source.find(ch) {
                result.push((pos + 1) as u32);
            } else {
                // Handle case where character is not found (shouldn't happen if strings are anagrams)
                panic!("Character '{}' not found in source string '{}'", ch, source);
            }
        }

        // Remove trailing fixed points (elements where value equals its 1-based index)
        while !result.is_empty() && *result.last().unwrap() == result.len() as u32 {
            result.pop();
        }
        result
    }

    // Return the cycles of the permutation given in one line form.
    fn one_line_to_cycles(&self, one_line: &OneLine) -> Cycles {
        let mut cycles = Cycles::new();
        // Use HashSet<u32> or let compiler infer from first insert (preferred)
        let mut used = HashSet::new();

        // Iterate only through elements present in one_line
        for &number in one_line.iter() {
            // Process the number only if it hasn't been included in a cycle yet
            // Type annotation inferred here: used.insert(number)
            if !used.contains(&number) {
                // Find the 1-based index of 'number' in the one_line vector
                if let Some(mut index) = one_line.iter().position(|&x| x == number).map(|i| i as u32 + 1) {
                    let mut cycle = OneLine::new();
                    cycle.push(number);

                    // Continue building the cycle until it closes
                    while number != index {
                        cycle.push(index);
                        // Find the next index based on the current value
                        // Default to number if not found (should not happen in valid permutation)
                        index = one_line.iter().position(|&x| x == index).map(|i| i as u32 + 1).unwrap_or(number);
                    }

                    // Only add cycles of length greater than 1
                    if cycle.len() > 1 {
                        cycles.push(cycle.clone()); // Clone to avoid moving cycle
                        used.extend(cycle); // Mark all elements in the cycle as used
                    }
                }
            }
        }
        cycles
    }

    // Return the one line notation of the permutation given in cycle form.
    fn cycles_to_one_line(&self, cycles: &Cycles) -> OneLine {
        // Initialize with identity permutation (1, 2, ..., n)
        let mut one_line: OneLine = (1..=self.letters_count).collect();

        for number in 1..=self.letters_count {
            for cycle in cycles {
                // Find the index of 'number' within the current cycle
                if let Some(index) = cycle.iter().position(|&x| x == number) {
                    // Map 'number' to the preceding element in the cycle (wrapping around)
                    let prev_index = if index > 0 { index - 1 } else { cycle.len() - 1 };
                    // Adjust for 0-based indexing
                    one_line[(number - 1) as usize] = cycle[prev_index];
                    break; // Move to the next number once the cycle is found
                }
            }
        }
        one_line
    }


    // Return the inverse of the given permutation in cycle form.
    fn cycles_inverse(&self, cycles: &Cycles) -> Cycles {
        let mut cycles_inverse = cycles.clone();
        for cycle in &mut cycles_inverse {
            // Rotate the cycle: move the first element to the end
            if !cycle.is_empty() {
                let first_element = cycle.remove(0);
                cycle.push(first_element);
            }
            // Reverse the order of elements in the cycle
            cycle.reverse();
        }
        cycles_inverse
    }

    // Return the inverse of the given permutation in one line notation.
    fn one_line_inverse(&self, one_line: &OneLine) -> OneLine {
        // Initialize with zeros, matching the length of the input one_line
        let mut one_line_inverse = vec![0; one_line.len()];
        for (index_zero_based, &value) in one_line.iter().enumerate() {
            let one_based_index = (index_zero_based + 1) as u32;
            // Place the 1-based index at the position indicated by the value (adjusted for 0-based indexing)
            // Bounds check to prevent potential panics
            if value > 0 && value <= one_line.len() as u32 {
                one_line_inverse[(value - 1) as usize] = one_based_index;
            }
        }
        one_line_inverse
    }

    // Return the element to which the given number is mapped by the permutation given in cycle form.
    fn next_in_cycles(&self, cycles: &Cycles, number: u32) -> u32 {
        for cycle in cycles {
            // Check if the number exists in the current cycle
            if let Some(index) = cycle.iter().position(|&x| x == number) {
                // Return the next element in the cycle (wrapping around using modulo)
                return cycle[(index + 1) % cycle.len()];
            }
        }
        // If the number is not found in any cycle, it's a fixed point, so it maps to itself
        number
    }

    // Return the cycles obtained by composing cycle_one first followed by cycle_two.
    fn combined_cycles(&self, cycles_one: &Cycles, cycles_two: &Cycles) -> Cycles {
        let mut combined_cycles = Cycles::new();
        // Use HashSet<u32> or let compiler infer
        let mut used = HashSet::new();

        // Iterate through all possible numbers up to the total letter count
        for number in 1..=self.letters_count {
            // Process the number only if it hasn't been included in a cycle yet
            // Type annotation inferred here: used.insert(number)
            if !used.contains(&number) {
                // Calculate the result of applying cycles_one followed by cycles_two
                let combined = self.next_in_cycles(cycles_two, self.next_in_cycles(cycles_one, number));

                let mut cycle = OneLine::new();
                cycle.push(number); // Start building the new cycle

                // Continue building the cycle until it closes
                let mut current = combined;
                while number != current {
                    cycle.push(current);
                    // Apply the combined transformation again
                    current = self.next_in_cycles(cycles_two, self.next_in_cycles(cycles_one, current));
                }

                // Add the cycle if it has more than one element
                if cycle.len() > 1 {
                    combined_cycles.push(cycle.clone()); // Clone to avoid moving cycle
                    used.extend(cycle); // Mark all elements in the cycle as used
                }
            }
        }
        combined_cycles
    }

    // Return the given string permuted by the permutation given in one line form.
    fn one_line_permute_string(&self, text: &str, one_line: &OneLine) -> String {
        let mut permuted_chars: Vec<char> = Vec::with_capacity(text.len());

        // Iterate through the indices specified in the one_line notation
        for &index in one_line {
            let zero_based_index = (index - 1) as usize;
            // Get the character from the original text at the specified index
            // Using chars().nth() is less efficient for multiple accesses,
            // but acceptable for this use case or if text is not excessively long.
            // Alternatively, collect text.chars() into a Vec<char> first.
            if let Some(ch) = text.chars().nth(zero_based_index) {
                permuted_chars.push(ch);
            }
        }

        // Append the remaining characters from the original text that were not specified by the one_line
        // (These correspond to fixed points at the end)
        let permuted_len = permuted_chars.len();
        if permuted_len < text.len() {
            permuted_chars.extend(text.chars().skip(permuted_len));
        }

        permuted_chars.into_iter().collect() // Convert the vector of characters back to a String
    }

    // Return the given string permuted by the permutation given in cycle form.
    fn cycles_permute_string(&self, text: &str, cycles: &Cycles) -> String {
        // Start with the original text as a vector of characters for mutability
        let mut permuted_chars: Vec<char> = text.chars().collect();

        // Apply each cycle to the character vector
        for cycle in cycles {
            // For each element in the cycle, move the character from its current position
            // to the position of the next element in the cycle
            for &number in cycle {
                let target_index = (self.next_in_cycles(cycles, number) - 1) as usize; // 0-based target index
                let source_index = (number - 1) as usize; // 0-based source index
                // Ensure indices are within bounds before accessing
                if source_index < text.len() && target_index < text.len() {
                     // Get the character from the original text at source_index
                    if let Some(ch) = text.chars().nth(source_index) {
                         permuted_chars[target_index] = ch;
                    }

                }
            }
        }

        permuted_chars.into_iter().collect() // Convert the vector back to a String
    }

    // Return the signature of the permutation given in one line form.
    fn signature(&self, one_line: &OneLine) -> String {
        let cycles = self.one_line_to_cycles(one_line);
        let mut even_count = 0;

        // Count the number of cycles of even length
        for cycle in &cycles {
            if cycle.len() % 2 == 0 {
                even_count += 1;
            }
        }

        // The signature is -1 if the number of even-length cycles is odd, otherwise +1
        if even_count % 2 == 0 {
            "+1".to_string()
        } else {
            "-1".to_string()
        }
    }

     // Return the order of the permutation given in one line form.
    fn order(&self, one_line: &OneLine) -> u32 {
        let cycles = self.one_line_to_cycles(one_line);
        let mut lcm_result = 1;

        // Calculate the LCM of the lengths of all cycles
        for cycle in &cycles {
            let cycle_size = cycle.len() as u32;
             // Update LCM using the formula: LCM(a, b) = a * b / GCD(a, b)
             // Ensure GCD handles potential zero (though cycle_size > 0 here)
            if cycle_size > 0 {
                lcm_result = lcm_result * cycle_size / gcd(lcm_result, cycle_size);
            }
        }

        lcm_result
    }

}

// Helper function to calculate the Greatest Common Divisor (GCD)
fn gcd(a: u32, b: u32) -> u32 {
    if b == 0 {
        a
    } else {
        gcd(b, a % b)
    }
}

// --- Display Functions ---
fn cycles_to_string(cycles: &Cycles) -> String {
    let mut result = String::new();
    for cycle in cycles {
        result.push_str(&one_line_to_string(cycle));
    }
    result
}

fn one_line_to_string(one_line: &OneLine) -> String {
    if one_line.is_empty() {
        return "()".to_string();
    }
    let mut result = "(".to_string();
    for (i, number) in one_line.iter().enumerate() {
        if i > 0 {
            result.push(' ');
        }
        result.push_str(&number.to_string());
    }
    result.push_str(") ");
    result
}


// --- Main Function ---
fn main() {
    // Define day names and corresponding letter arrangements
    const DAY_NAMES: [&str; 7] = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"];
    const LETTERS: [&str; 7] = [
        "HANDYCOILSERUPT",
        "SPOILUNDERYACHT",
        "DRAINSTYLEPOUCH",
        "DITCHSYRUPALONE",
        "SOAPYTHIRDUNCLE",
        "SHINEPARTYCLOUD",
        "RADIOLUNCHTYPES",
    ];

    // Helper closure to get the previous day's index
    let previous_day = |today: usize| (7 + today - 1) % 7;

    // Create a Permutation instance based on the length of the letter strings
    // Ensure all LETTERS strings have the same length
    let permutation = Permutation::new(LETTERS[0].len() as u32);

    // --- Output Section ---

    println!("On Thursdays Alf and Betty should rearrange their letters using these cycles:");
    let one_line_wed_thu = permutation.create_one_line(LETTERS[2], LETTERS[3]); // WEDNESDAY to THURSDAY
    let cycles_wed_thu = permutation.one_line_to_cycles(&one_line_wed_thu);
    println!("{}", cycles_to_string(&cycles_wed_thu));
    println!("So that {} becomes {}", LETTERS[2], LETTERS[3]);
    println!("\nOr they could use the one line notation:");
    println!("{}", one_line_to_string(&one_line_wed_thu));

    println!("\nTo revert to the Wednesday arrangement they should use these cycles:");
    let cycles_thu_wed = permutation.cycles_inverse(&cycles_wed_thu);
    println!("{}", cycles_to_string(&cycles_thu_wed));

    println!("\nOr with the one line notation:");
    let one_line_thu_wed = permutation.one_line_inverse(&one_line_wed_thu);
    println!("{}", one_line_to_string(&one_line_thu_wed));
    println!("So that {} becomes {}", LETTERS[3],
             permutation.one_line_permute_string(LETTERS[3], &one_line_thu_wed));

    println!("\nStarting with the Sunday arrangement and applying each of the daily");
    println!("arrangements consecutively, the arrangements will be:\n");
    println!("{:>11} {}", "", LETTERS[6]); // SUNDAY

    for (today_index, &day_name) in DAY_NAMES.iter().enumerate() {
        let prev_index = previous_day(today_index);
        let day_one_line = permutation.create_one_line(LETTERS[prev_index], LETTERS[today_index]);
        let permuted_string = permutation.one_line_permute_string(LETTERS[prev_index], &day_one_line);
        println!("{:>11}: {}", day_name, permuted_string);
        if day_name == "SATURDAY" {
            println!(); // Extra newline after Saturday
        }
    }

    println!("To go from Wednesday to Friday in a single step they should use these cycles:");
    let one_line_thu_fri = permutation.create_one_line(LETTERS[3], LETTERS[4]); // THURSDAY to FRIDAY
    let cycles_thu_fri = permutation.one_line_to_cycles(&one_line_thu_fri);
    let cycles_wed_fri = permutation.combined_cycles(&cycles_wed_thu, &cycles_thu_fri);
    println!("{}", cycles_to_string(&cycles_wed_fri));
    println!("So that {} becomes {}", LETTERS[2],
             permutation.cycles_permute_string(LETTERS[2], &cycles_wed_fri));

    println!("\nThese are the signatures of the permutations:\n");
    for (today_index, &day_name) in DAY_NAMES.iter().enumerate() {
        let prev_index = previous_day(today_index);
        let one_line = permutation.create_one_line(LETTERS[prev_index], LETTERS[today_index]);
        let sig = permutation.signature(&one_line);
        println!("{:>11}: {}", day_name, sig);
    }

    println!("\nThese are the orders of the permutations:\n");
    for (today_index, &day_name) in DAY_NAMES.iter().enumerate() {
        let prev_index = previous_day(today_index);
        let one_line = permutation.create_one_line(LETTERS[prev_index], LETTERS[today_index]);
        let ord = permutation.order(&one_line);
        println!("{:>11}: {}", day_name, ord);
    }

    println!("\nApplying the Friday cycle to a string 10 times:");
    let mut previous = "STOREDAILYPUNCH".to_string();
    println!("\n{:>2} {}", 0, previous);

    for i in 1..=10 {
        previous = permutation.cycles_permute_string(&previous, &cycles_thu_fri);
        println!("{:>2} {}", i, previous);
        if i == 9 {
            println!(); // Extra newline after iteration 9
        }
    }
}
