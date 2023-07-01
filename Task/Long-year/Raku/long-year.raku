sub is-long ($year) { Date.new("$year-12-28").week[1] == 53 }

# Testing
say   "Long years in the 20th century:\n", (1900..^2000).grep: &is-long;
say "\nLong years in the 21st century:\n", (2000..^2100).grep: &is-long;
say "\nLong years in the 22nd century:\n", (2100..^2200).grep: &is-long;
