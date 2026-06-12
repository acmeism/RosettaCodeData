<?php foreach(file("unixdict.txt") as $w) echo (strstr($w, "the") && strlen(trim($w)) > 11) ? $w : "";
