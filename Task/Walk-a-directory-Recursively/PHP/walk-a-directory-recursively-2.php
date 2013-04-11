/*
	This script performs a BFS search with recursion protection
	it is often faster to search using this method across a
	filesystem due to a few reasons:

	* filesystem is accessed in native node order
	* a recursive function is not required allowing infinate depth
	* multiple directory handles are not required
	* the file being searched for is often not that deep in the fs

	This method also leverages PHP array hashing to speed up loop
	detection while minimizing the amount of RAM used to track the
	search history.

	-Geoffrey McRae
	Released as open license for any use.
*/
if ($_SERVER['argc'] < 3) {
	printf(
		"\n" .
		"Usage: %s (path) (search) [stop]\n" .
		"	path	the path to search\n" .
		"	search	the filename to search for\n" .
		"	stop	stop when file found, default 1\n" .
		"\n"
		, $_SERVER['argv'][0]);
	exit(1);
}

$path   = $_SERVER['argv'][1];
$search = $_SERVER['argv'][2];
if ($_SERVER['argc'] > 3)
	$stop = $_SERVER['argv'][3] == 1;
else	$stop = true;

/* get the absolute path and ensure it has a trailing slash */
$path = realpath($path);
if (substr($path, -1) !== DIRECTORY_SEPARATOR)
	$path .= DIRECTORY_SEPARATOR;

$queue = array($path => 1);
$done  = array();
$index = 0;
while(!empty($queue)) {
	/* get one element from the queue */
	foreach($queue as $path => $unused) {
		unset($queue[$path]);
		$done[$path] = null;
		break;
	}
	unset($unused);

	$dh = @opendir($path);
	if (!$dh) continue;
	while(($filename = readdir($dh)) !== false) {
		/* dont recurse back up levels */
		if ($filename == '.' || $filename == '..')
			continue;

		/* check if the filename matches the search term */
		if ($filename == $search) {
			echo "$path$filename\n";
			if ($stop)
				break 2;
		}

		/* get the full path */
		$filename = $path . $filename;

		/* resolve symlinks to their real path */
		if (is_link($filename))
			$filename = realpath($filename);

		/* queue directories for later search */
		if (is_dir($filename)) {
			/* ensure the path has a trailing slash */
			if (substr($filename, -1) !== DIRECTORY_SEPARATOR)
				$filename .= DIRECTORY_SEPARATOR;

			/* check if we have already queued this path, or have done it */
			if (array_key_exists($filename, $queue) || array_key_exists($filename, $done))
				continue;

			/* queue the file */
			$queue[$filename] = null;
		}
	}
	closedir($dh);
}
