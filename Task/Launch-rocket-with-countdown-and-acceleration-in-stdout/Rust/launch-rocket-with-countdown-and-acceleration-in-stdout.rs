use std::{thread, time};

fn print_rocket(above: u32) {
	print!(
"  oo
 oooo
 oooo
 oooo
");
for _num in 1..above+1 {
 println!("  ||");
}
}

fn main() {

    // counting
    for number in (1..6).rev() {
        print!("\x1B[2J");
      	println!("{} =>", number);
        print_rocket(0);
	let dur = time::Duration::from_millis(1000);
        thread::sleep(dur);
    }

    // ignition
    print!("\x1B[2J");
    println!("Liftoff !");
    print_rocket(1);
    let dur = time::Duration::from_millis(1000);
    thread::sleep(dur);

    // liftoff
    let mut dur_time : u64 = 1000;
    for number in 2..100 {
    	print!("\x1B[2J");
        print_rocket(number);	
	let dur = time::Duration::from_millis(dur_time);
        thread::sleep(dur);
	dur_time -= if dur_time >= 30 {30} else {dur_time};
    }
}

