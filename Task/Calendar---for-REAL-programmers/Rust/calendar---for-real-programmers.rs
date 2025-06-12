struct Months {
  pub name: String,
  pub days: i16,
  pub start_wday: i16,
  pub at: i16,
}
impl Months {
  fn new_month(name: &str, days: i16) -> Self {
    Months {
      name: String::from(name),
      days,
      start_wday: 0,
      at: 0,
    }
  }
}
struct Calendar {
  year: i16,
  width: i16,
  cols: i16,
  lead: i16,
  gap: i16,
  months: [Months; 12],
  wdays: [&'static str; 7],
}
impl Calendar {
  fn new_calendar(year: i16, width: i16) -> Self {
    let mut calendar = Calendar {
      year,
      width,
      cols: 0,
      lead: 0,
      gap: 0,
      months: [
        Months::new_month("JANUARY", 31),
        Months::new_month("FEBRUARY", 28),
        Months::new_month("MARCH", 31),
        Months::new_month("APRIL", 30),
        Months::new_month("MAY", 31),
        Months::new_month("JUNE", 30),
        Months::new_month("JULY", 31),
        Months::new_month("AUGUST", 31),
        Months::new_month("SEPTEMBER", 30),
        Months::new_month("OCTOBER", 31),
        Months::new_month("NOVEMBER", 30),
        Months::new_month("DECEMBER", 31),
      ],
      wdays: ["SU", "MO", "TU", "WE", "TH", "FR", "SA"],
    };
    calendar.init_months();
    calendar
  }
  fn init_months(&mut self) {
    // Check for leap year and adjust February
    if (self.year % 4 == 0 && self.year % 100 != 0) || self.year % 400 == 0 {
      self.months[1].days = 29;
    }
    // Calculate starting weekday for January
    let y = self.year - 1;
    let year_days = (y % 7) * (365 % 7) % 7;  // (y * 365) % 7
    let leap_days = ((y >> 2) - y / 100 + y / 400) % 7;
    self.months[0].start_wday = (year_days + leap_days + 1) % 7;
    // Calculate starting weekdays for remaining months
    for i in 1..12 {
      self.months[i].start_wday =
      ((self.months[i-1].start_wday as i16 + self.months[i-1].days as i16) % 7) as i16;
    }
    // Layout calculations
    self.cols = (self.width + 2) / 22;
    while 12 % self.cols != 0 {
      self.cols -= 1;
    }
    self.gap = if self.cols > 1 {
      let gap = (self.width - 20 * self.cols) / (self.cols - 1);
      if gap > 4 { 4 } else { gap }
    }
    else {
      0
    };
    // Calculate left margin to center the calendar
    self.lead = (self.width - (20 + self.gap) * self.cols + self.gap + 1) >> 1;
  }
  // Helper method to print N spaces
  fn print_spaces(&self, n: i16) {
    print!("{}", " ".repeat(n as usize));
  }
  // Print a horizontal row of month grids
  fn print_row(&mut self, row: i16) {
    let from = row * self.cols;
    let to = from + self.cols;
    // Print month names centered
    self.print_spaces(self.lead);
    for c in from..to {
      let name_len = self.months[c as usize].name.len() as i16;
      self.print_spaces((20 - name_len) >> 1);
      print!("{}", self.months[c as usize].name);
      let extra_spaces = 20 - name_len - ((20 - name_len) >> 1);
      let gap_spaces = if c == to - 1 { 0 } else { self.gap };
      self.print_spaces(extra_spaces + gap_spaces);
    }
    println!();
    // Print weekday headers for each month
    self.print_spaces(self.lead);
    for c in from..to {
      for i in 0..7 {
        print!("{}", self.wdays[i as usize]);
        if i < 6 {
          print!(" ");
        }
      }
      if c < to - 1 {
        self.print_spaces(self.gap);
      } else {
        println!();
      }
    }
    // Print the calendar days for all months in this row
    loop {
      // Check if we've printed all days for all months in this row
      let mut all_done = true;
      for c in from..to {
        if self.months[c as usize].at < self.months[c as usize].days {
          all_done = false;
          break;
        }
      }
      if all_done {
        break;
      }
      self.print_spaces(self.lead);
      for c in from..to {
        let c_usize = c as usize;
        let mut i = 0;
        // Print spaces for days before the 1st of the month
        while i < self.months[c_usize].start_wday {
          self.print_spaces(3);
          i += 1;
        }
        // Print the days of the month
        while i < 7 && self.months[c_usize].at < self.months[c_usize].days {
          self.months[c_usize].at += 1;
          let day = self.months[c_usize].at;
          // Print day with padding
          if day < 10 {
              print!(" {}", day);
          } else {
              print!("{}", day);
          }
          if i < 6 || c < to - 1 {
              print!(" ");
          }
          i += 1;
        }
        // Fill remaining spaces in week if needed
        while i < 7 && c < to - 1 {
          self.print_spaces(3);
          i += 1;
        }
        if c < to - 1 {
          self.print_spaces(self.gap - 1);
        }
        self.months[c_usize].start_wday = 0; // Reset for next week
      }
      println!();
    }
    println!(); // Extra line between rows of months
  }
  // Print the entire year's calendar
  fn print_year(&mut self) {
    // Print centered year heading
    let year_str = self.year.to_string();
    let spaces = (self.width - year_str.len() as i16) >> 1;
    self.print_spaces(spaces);
    println!("{}", year_str);
    println!();
    // Print each row of months
    let rows = 12 / self.cols;
    for row in 0..rows {
      self.print_row(row);
    }
  }
}
fn main() -> Result<(), String> {
  let args: Vec<String> = env::args().collect();
  let mut year: i16 = 1969; // Default year
  let mut width: i16 = 80;  // Default width
  let mut year_set = false;
  // Process command line arguments
  let mut i = 1;
  while i < args.len() {
      if args[i] == "-W" {
          i += 1;
          if i < args.len() {
              width = args[i].parse::<i16>().map_err(|_| "Invalid width")?;
              if width < 20 {
                  return Err("Width must be at least 20".to_string());
              }
          } else {
              return Err("Missing width value after -W".to_string());
          }
      } else if !year_set {
          year = match args[i].parse::<i16>() {
              Ok(y) if y > 0 => y,
              _ => 1969, // Default to 1969 if year is invalid
          };
          year_set = true;
      } else {
          return Err(format!("Too many arguments. Usage: {} YEAR [-W WIDTH (>= 20)]", args[0]));
      }
      i += 1;
  }
  // Generate and print the calendar
  let mut calendar = Calendar::new_calendar(year, width);
  calendar.print_year();
  Ok(())
}
