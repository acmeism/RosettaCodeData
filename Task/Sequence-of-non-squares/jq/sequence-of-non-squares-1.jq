def A000037: . + (0.5 + sqrt | floor);

def is_square: sqrt | . == floor;

"For n up to and including 22:",
 (range(1;23) | A000037),
"Check for squares for n up to 1e6:",
 (range(1;1e6+1) | A000037 | select( is_square ))
