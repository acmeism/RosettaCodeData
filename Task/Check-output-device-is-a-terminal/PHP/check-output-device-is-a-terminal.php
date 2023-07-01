if(posix_isatty(STDOUT)) {
    echo "The output device is a terminal".PHP_EOL;
} else {
    echo "The output device is NOT a terminal".PHP_EOL;
}
