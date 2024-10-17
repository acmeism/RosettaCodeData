fn pascal_triangle(n: u64)
{

  for i in 0..n {
    let mut c = 1;
    for _j in 1..2*(n-1-i)+1 {
      print!(" ");
    }
    for k in 0..i+1 {
      print!("{:2} ", c);
      c = c * (i-k)/(k+1);
    }
    println!();
  }
}
