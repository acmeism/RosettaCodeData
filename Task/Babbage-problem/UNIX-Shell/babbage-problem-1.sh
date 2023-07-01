# Program to determine the smallest positive integer whose square
# has a decimal representation ending in the digits 269,696.

# Start with the smallest positive integer of them all
let trial_value=1

# Compute the remainder when the square of the current trial value is divided
# by 1,000,000.␣
while (( trial_value * trial_value % 1000000 != 269696 )); do
  # As long as this value is not yet 269,696, increment
  # our trial integer and try again.
  let trial_value=trial_value+1
done

# To get here we must have found an integer whose square meets the
# condition; display that final result
echo $trial_value
