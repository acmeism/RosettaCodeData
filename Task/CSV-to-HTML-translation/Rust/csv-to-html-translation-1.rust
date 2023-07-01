static INPUT : &'static str  =
"Character,Speech
The multitude,The messiah! Show us the messiah!
Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>
The multitude,Who are you?
Brians mother,I'm his mother; that's who!
The multitude,Behold his mother! Behold his mother!";

fn main() {
    print!("<table>\n<tr><td>");
    for c in INPUT.chars() {
        match c {
            '\n' => print!("</td></tr>\n<tr><td>"),
            ','  => print!("</td><td>"),
            '<'  => print!("&lt;"),
            '>'  => print!("&gt;"),
            '&'  => print!("&amp;"),
            _    => print!("{}", c)
        }
    }
    println!("</td></tr>\n</table>");
}
