fn main() {
    let characters = ['|', '/', '-', '\\'];
    let mut current = 0;

    println!("{}[2J", 27 as char); // Clear screen.

    loop {
        println!("{}[;H{}", 27 as char, characters[current]); // Move cursor to 1,1 and output the next character.
        current += 1; // Advance current character.
        if current == 4 {current = 0;} // If we reached the end of the array, start from the beginning.
        std::thread::sleep(std::time::Duration::from_millis(250)); // Sleep 250 ms.
    }
}
