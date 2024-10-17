// 202100315 Rust programming solution

use roots::find_roots_cubic;

fn main() {

   let roots = find_roots_cubic(1f32, -3f32, 2f32, 0f32);

   println!("Result : {:?}", roots);
}
