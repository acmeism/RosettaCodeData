<?php

for (
    $i = 1 ;                                    // Initial positive integer to check
    ($i * $i) % 1000000 !== 269696 ;            // While i*i does not end with the digits 269,696
    $i++                                        // ... go to next integer
);

echo $i, ' * ', $i, ' = ', ($i * $i), PHP_EOL;  // Print the result
