# Give the results as an array so they can
# readily be presented on a single line:
[range(2008; 2122) | select( day_of_week(.;12;25;0) == 1 )]
