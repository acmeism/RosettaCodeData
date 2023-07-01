$nanoseconds = 42000000000;
echo "Sleeping...\n";
time_nanosleep($seconds, $nanoseconds); # first arg in seconds plus second arg in nanoseconds
echo "Awake!\n";
