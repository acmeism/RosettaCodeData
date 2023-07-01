use std::collections::HashMap;

// The plan here is to build a hashmap of all the commands keyed on the minimum number of
// letters than can be provided in the input to match. For each known command it will appear
// in a list of possible commands for a given string lengths. A command can therefore appear a
// number of times. For example, the command 'recover' has a minimum abbreviation length of 3.
// In the hashmap 'recover' will be stored behind keys for 3, 4, 5, 6 & 7 as any abbreviation of
// 'recover' from 3 until 7 letters inclusive can match. This way, once the length of the input
// string is known a subset of possible matches can be retrieved immediately and then checked.
//
fn main() {
    let command_table_string =
        "add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1  Schange  Cinsert 2  Clast 3
   compress 4 copy 2 count 3 Coverlay 3 cursor 3  delete 3 Cdelete 2  down 1  duplicate
   3 xEdit 1 expand 3 extract 3  find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2
   forward 2  get  help 1 hexType 4  input_command 1 powerInput 3  join 1 split 2 spltJOIN load
   locate 1 Clocate 2 lowerCase 3 upperCase 3 Lprefix 2  macro  merge 2 modify 3 move 2
   msg  next 1 overlay 1 parse preserve 4 purge 3 put putD query 1 quit  read recover 3
   refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4 rgtLEFT right 2 left
   2  save  set  shift 2  si  sort  sos  stack 3 status 4 top  transfer 3  type 1  up 1";

    // Split up the command table string using the whitespace and set up an iterator
    // to run through it. We need the iterator to be peekable so that we can look ahead at
    // the next item.
    let mut iter = command_table_string.split_whitespace().peekable();

    let mut command_table = HashMap::new();

    // Attempt to take two items at a time from the command table string. These two items will be
    // the command string and the minimum length of the abbreviation. If there is no abbreviation length
    // then there is no number provided. As the second item might not be a number, so we need to peek at
    // it first. If it is a number we can use it as a key for the hashmap. If it is not a number then
    // we use the length of the first item instead because no abbreviations are available for the
    // word i.e. the whole word must be used. A while loop is used because we need to control iteration
    // and look ahead.
    //
    while let Some(command_string) = iter.next() {
        let command_string_length = command_string.len() as i32;

        let min_letter_match = match iter.peek() {
            Some(potential_number) => match potential_number.parse::<i32>() {
                Ok(number) => {
                    iter.next();
                    number
                }
                Err(_) => command_string_length,
            },
            None => break,
        };

        // The word must be stored for every valid abbreviation length.
        //
        for i in min_letter_match..=command_string_length {
            let cmd_list = command_table.entry(i).or_insert_with(Vec::new);
            cmd_list.push(command_string.to_uppercase());
        }
    }

    const ERROR_TEXT: &str = "*error*";

    let test_input_text = "riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin";

    let mut output_text = String::new();

    let mut iter = test_input_text.split_whitespace().peekable();

    // Run through each item in the input string, find the length of it
    // and then use this to fetch a list of possible matches.
    // A while loop is used because we need to look ahead in order to indentify
    // the last item and avoid adding an unnecessary space.
    //
    while let Some(input_command) = iter.next() {
        let input_command_length = input_command.len() as i32;

        let command_list = match command_table.get(&input_command_length) {
            Some(list) => list,
            None => {
                output_text.push_str(ERROR_TEXT);
                continue;
            }
        };

        let input_command_caps = input_command.to_uppercase();
        let matched_commands: Vec<&String> = command_list
            .iter()
            .filter(|command| command.starts_with(&input_command_caps))
            .collect();

        // Should either be 0 or 1 command found
        assert!(
            matched_commands.len() < 2,
            "Strange.. {:?}",
            matched_commands
        );

        match matched_commands.first() {
            Some(cmd) => output_text.push_str(cmd),
            None => output_text.push_str(ERROR_TEXT),
        }

        if iter.peek().is_some() {
            output_text.push(' ');
        }
    }

    println!("Input was: {}", test_input_text);
    println!("Output is: {}", output_text);

    let correct_output = "RIGHT REPEAT *error* PUT MOVE RESTORE *error* *error* *error* POWERINPUT";
    assert_eq!(output_text, correct_output)
}
