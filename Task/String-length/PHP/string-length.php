<?php
foreach (array('møøse', '𝔘𝔫𝔦𝔠𝔬𝔡𝔢', 'J̲o̲s̲é̲') as $s1) {
   printf('String "%s" measured with strlen: %d mb_strlen: %s grapheme_strlen %s%s',
                  $s1, strlen($s1),mb_strlen($s1), grapheme_strlen($s1), PHP_EOL);
}
