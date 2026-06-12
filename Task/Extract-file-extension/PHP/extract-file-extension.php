$tests = [
    ['input'=>'http://example.com/download.tar.gz', 'expect'=>'.gz'],
    ['input'=>'CharacterModel.3DS', 'expect'=>'.3DS'],
    ['input'=>'.desktop', 'expect'=>'.desktop'],
    ['input'=>'document', 'expect'=>''],
    ['input'=>'document.txt_backup', 'expect'=>''],
    ['input'=>'/etc/pam.d/login', 'expect'=>'']
];

foreach ($tests as $key=>$test) {
    $ext = pathinfo($test['input'], PATHINFO_EXTENSION);
    // in php, pathinfo allows for an underscore in the file extension
    // the following if statement only allows for A-z0-9 in the extension
    if (ctype_alnum($ext)) {
        // pathinfo returns the extension without the preceeding '.' so adding it back on
        $tests[$key]['actual'] = '.'.$ext;
    } else {
        $tests[$key]['actual'] = '';
    }
}
foreach ($tests as $test) {
    printf("%35s -> %s \n", $test['input'],$test['actual']);
}
