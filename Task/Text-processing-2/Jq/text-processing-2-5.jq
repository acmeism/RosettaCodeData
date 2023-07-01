# The following ignores any issues with respect to duplicate dates,
# but does check the validity of the record, including the date format:
def number_of_valid_readings:
  def check:
    . as $in
    | (.[0] | is_date)
      and length == 49
      and all(range(0; 24) | $in[2*. + 1] | is_float)
      and all(range(0; 24) | $in[2*. + 2] | (is_integral and tonumber >= 1) );

   map(select(check)) | length ;
