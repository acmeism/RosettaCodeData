fn main() {
    let colors: (int, int, int)[7] = [
        (255,   0,   0), // red
        (255, 128,   0), // orange
        (255, 255,   0), // yellow
        (  0, 255,   0), // green
        (  0,   0, 255), // blue
        ( 75,   0, 130), // indigo
        (128,   0, 255)  // violet
    ];
    let s = "RAINBOW";
    for i in 0..7 {
        let fore = "\e[38;2;{colors[i].0};{colors[i].1};{colors[i].2}m";
        print "{fore}{s[i]:c}";
    }
    println "";
}
