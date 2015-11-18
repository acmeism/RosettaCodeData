const TEXT: &'static str =
"---------- Ice and Fire ------------

fire, in end will world the say Some
ice. in say Some
desire of tasted I've what From
fire. favor who those with hold I

... elided paragraph last ...

Frost Robert -----------------------";

fn main() {
    println!("{}",
             TEXT.lines() // Returns iterator over lines
             .map(|line|  // Applies closure to each item in iterator (for each line)
                  line.split_whitespace() // Returns iterator of words
                  .rev() // Reverses iterator of words
                  .collect::<Vec<_>>() // Collects words into Vec<&str>
                  .join(" ")) // Convert vector of words back into line
             .collect::<Vec<_>>() // Collect lines into Vec<String>
             .join("\n")); // Concatenate lines into String
}
