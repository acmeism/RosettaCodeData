void main() {
  DateYear[] years = { 1900, 1994, 1996, 1997, 2000 };
  foreach ( DateYear year in years ) {
    string status = year.is_leap_year() ? "" : "not ";
    print (@"$year is $(status)a leap year.\n");
  }
}
