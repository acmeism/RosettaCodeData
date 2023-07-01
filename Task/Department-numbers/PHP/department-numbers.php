<?php

$valid = 0;
for ($police = 2 ; $police <= 6 ; $police += 2) {
    for ($sanitation = 1 ; $sanitation <= 7 ; $sanitation++) {
        $fire = 12 - $police - $sanitation;
        if ((1 <= $fire) and ($fire <= 7) and ($police != $sanitation) and ($sanitation != $fire)) {
            echo 'Police: ', $police, ', Sanitation: ', $sanitation, ', Fire: ', $fire, PHP_EOL;
            $valid++;
        }
    }
}
echo $valid, ' valid combinations found.', PHP_EOL;
