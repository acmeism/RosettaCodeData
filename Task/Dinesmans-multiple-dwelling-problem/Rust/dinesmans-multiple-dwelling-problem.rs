use itertools::Itertools;


fn main() {
    for p in (1..6).permutations(5) {
        let baker: i32 = p[0];
        let cooper: i32 = p[1];
        let fletcher: i32 = p[2];
        let miller: i32 = p[3];
        let smith: i32 = p[4];
        if baker != 5 && cooper != 1 && fletcher != 1 && fletcher != 5 && cooper < miller &&
           (smith - fletcher).abs() > 1 && (cooper - fletcher).abs() > 1 {
            print!("Baker on {baker}, Cooper on {cooper}, ");
            println!("Fletcher on {fletcher}, Miller on {miller}, Smith on {smith}.");
            break;
        }
    }
}
