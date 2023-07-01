fn day_of_week(year: u32, month: u32, day: u32) -> u32 {
    const LEAPYEAR_FIRSTDOOMSDAYS: [u32; 12] = [4, 1, 7, 4, 2, 6, 4, 1, 5, 3, 7, 5];
    const NONLEAPYEAR_FIRSTDOOMSDAYS: [u32; 12] = [3, 7, 7, 4, 2, 6, 4, 1, 5, 3, 7, 5];
    assert!(year > 1581 && year < 10000);
    assert!(month >= 1 && month <= 12);
    assert!(day >= 1 && day <= 31);
    let doomsday = (2 + 5 * (year % 4) + 4 * (year % 100) + 6 * (year % 400)) % 7;
    let anchorday = if year % 4 != 0 || (year % 100 == 0 && year % 400 != 0) {
        NONLEAPYEAR_FIRSTDOOMSDAYS[month as usize - 1]
    } else {
        LEAPYEAR_FIRSTDOOMSDAYS[month as usize - 1]
    };
    (doomsday + day + 7 - anchorday) % 7
}

fn print_day_of_week(year: u32, month: u32, day: u32) {
    const DAY_NAMES: [&str; 7] = [
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
    ];
    println!(
        "{:04}-{:02}-{:02}: {}",
        year,
        month,
        day,
        DAY_NAMES[day_of_week(year, month, day) as usize]
    );
}

fn main() {
    print_day_of_week(1800, 1, 6);
    print_day_of_week(1875, 3, 29);
    print_day_of_week(1915, 12, 7);
    print_day_of_week(1970, 12, 23);
    print_day_of_week(2043, 5, 14);
    print_day_of_week(2077, 2, 12);
    print_day_of_week(2101, 4, 2);
}
