use std::io ;

//string supposed to contain ascii letters only!
fn main() {
    println!("Enter a string!");
    let mut inline : String = String::new( ) ;
    io::stdin( ).read_line( &mut inline ).unwrap( ) ;
    let entered_line : &str = &*inline ;
    let vowels = vec!['a' , 'e' , 'i' , 'o' , 'u' , 'A' , 'E' , 'I' ,
        'O' , 'U'] ;
    let numvowels = entered_line.trim( ).chars( ).filter( | c |
          vowels.contains( c ) ).count( ) ;
    let consonants = entered_line.trim( ).chars( ).filter( | c |
          ! vowels.contains( c ) && c.is_ascii_alphabetic( )).count( ) ;
    println!("String {:?} contains {} vowels and {} consonants!" ,
    entered_line.trim( ) , numvowels , consonants ) ;
}
