#!/usr/bin/php
<?php
echo "\e[?25l"; // Cursor hide escape sequence
sleep(5);
echo "\e[?25h"; // Cursor show escape sequence
sleep(5);
