const INPUT: &str = "http://foo bar/";
const MAX_CHAR_VAL: u32 = std::char::MAX as u32;

fn main() {
    let mut buff = [0; 4];
    println!("{}", INPUT.chars()
        .map(|ch| {
            match ch as u32 {
                0 ..= 47 | 58 ..= 64 | 91 ..= 96 | 123 ..= MAX_CHAR_VAL => {
                    ch.encode_utf8(&mut buff);
                    buff[0..ch.len_utf8()].iter().map(|&byte| format!("%{:X}", byte)).collect::<String>()
                },
                _ => ch.to_string(),
            }
        })
        .collect::<String>()
    );
}
