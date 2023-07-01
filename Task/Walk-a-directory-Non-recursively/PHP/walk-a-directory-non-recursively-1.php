$pattern = 'php';
$dh = opendir('c:/foo/bar'); // Or '/home/foo/bar' for Linux
while (false !== ($file = readdir($dh)))
{
    if ($file != '.' and $file != '..')
    {
        if (preg_match("/$pattern/", $file))
        {
            echo "$file matches $pattern\n";
        }
    }
}
closedir($dh);
