use std::io ;
use itertools::Itertools ;

fn main() {
    println!("Enter some real numbers, separated by blanks!");
    let mut inline : String = String::new( ) ;
    io::stdin( ).read_line( &mut inline ).unwrap( ) ;
    let entered_line : &str = &*inline ;
    let numbers : Vec<f32> = entered_line.split_whitespace( ).map( | s |
          s.trim( ). parse::<f32>( ).unwrap( ) ).collect( ) ;
    let mut pairs : Vec<(&f32, &f32)> = numbers.iter( ).tuple_windows( ).collect( ) ;
    let num_slice = &mut pairs[..] ;
    let len = num_slice.len( ) ;
    num_slice.sort_by( | a, b| (a.0 - a.1).abs( ).partial_cmp(&( &*b.0 -&*b.1).abs( ))
          .unwrap( )) ;
    let maximumpair = &num_slice[len - 1 .. len] ;
    let maxi = maximumpair.to_vec( ) ;
    let maximum : f32 = (maxi[0].0- maxi[0].1).abs( ) ;
    let maxima : Vec<&(&f32, &f32)> = num_slice.iter( ).filter( |&p |
          (p.0 - p.1).abs( ) ==  maximum ).collect( ) ;
    maxima.iter( ).for_each( | p | println!("{},{} ==> {}" ,
             p.0 , p.1 , maximum)) ;
}
