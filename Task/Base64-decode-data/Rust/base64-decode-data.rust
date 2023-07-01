use std::str;

const INPUT: &str = "VG8gZXJyIGlzIGh1bWFuLCBidXQgdG8gcmVhbGx5IGZvdWwgdGhpbmdzIHVwIHlvdSBuZWVkIGEgY29tcHV0ZXIuCiAgICAtLVBhdWwgUi5FaHJsaWNo";
const UPPERCASE_OFFSET: i8 = -65;
const LOWERCASE_OFFSET: i8 = 26 - 97;
const NUM_OFFSET: i8 = 52 - 48;

fn main() {
    println!("Input: {}", INPUT);

    let result = INPUT.chars()
        .filter(|&ch| ch != '=')                                //Filter '=' chars
        .map(|ch| {                                             //Map char values using Base64 Characters Table
            let ascii = ch as i8;
            let convert = match ch {
                '0' ... '9' => ascii + NUM_OFFSET,
                'a' ... 'z' => ascii + LOWERCASE_OFFSET,
                'A' ... 'Z' => ascii + UPPERCASE_OFFSET,
                '+' => 62,
                '/' => 63,
                _ => panic!("Not a valid base64 encoded string")
            };
            format!("{:#08b}", convert)[2..].to_string()        //convert indices to binary format and remove the two first digits
        })
        .collect::<String>()                                    //concatenate the resulting binary values
        .chars()
        .collect::<Vec<char>>()
        .chunks(8)                                              //split into 8 character chunks
        .map(|chunk| {
            let num_str = chunk.iter().collect::<String>();
            usize::from_str_radix(&num_str, 2).unwrap() as u8   //convert the binary string into its u8 value
        })
        .collect::<Vec<_>>();

    let result = str::from_utf8(&result).unwrap();              //convert into UTF-8 string

    println!("Output: {}", result);
}
