<?php
fclose(STDOUT);
$STDOUT = fopen('/dev/lp0', 'a');
echo 'Hello world!';
?>
