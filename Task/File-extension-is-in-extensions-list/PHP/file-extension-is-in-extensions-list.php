$allowed = ['zip', 'rar', '7z', 'gz', 'archive', 'A##', 'tar.bz2'];
$lc_allowed = array_map('strtolower', $allowed);

$tests = [
    ['MyData.a##',true],
    ['MyData.tar.Gz',true],
    ['MyData.gzip',false],
    ['MyData.7z.backup',false],
    ['MyData...',false],
    ['MyData',false],
    ['archive.tar.gz', true]
];

foreach ($tests as $test) {
    $ext = pathinfo($test[0], PATHINFO_EXTENSION);
    if (in_array(strtolower($ext), $lc_allowed)) {
        $result = 'true';
    } else {
        $result = 'false';
    }
    printf("%20s : %s \n", $test[0],$result);
}
