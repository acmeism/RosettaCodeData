$pattern = 'php';
foreach (scandir('/home/foo/bar') as $file)
{
    if ($file != '.' and $file != '..')
    {
        if (preg_match("/$pattern/", $file))
        {
            echo "$file matches $pattern\n";
        }
    }
}
