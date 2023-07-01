<?php

$conf = file_get_contents('parse-conf-file.txt');

// Add an "=" after entry name
$conf = preg_replace('/^([a-z]+)/mi', '$1 =', $conf);

// Replace multiple parameters separated by commas :
//   name = value1, value2
// by multiple lines :
//   name[] = value1
//   name[] = value2
$conf = preg_replace_callback(
    '/^([a-z]+)\s*=((?=.*\,.*).*)$/mi',
    function ($matches) {
        $r = '';
        foreach (explode(',', $matches[2]) AS $val) {
            $r .= $matches[1] . '[] = ' . trim($val) . PHP_EOL;
        }
        return $r;
    },
    $conf
);

// Replace empty values by "true"
$conf = preg_replace('/^([a-z]+)\s*=$/mi', '$1 = true', $conf);

// Parse configuration file
$ini = parse_ini_string($conf);

echo 'Full name       = ', $ini['FULLNAME'], PHP_EOL;
echo 'Favourite fruit = ', $ini['FAVOURITEFRUIT'], PHP_EOL;
echo 'Need spelling   = ', (empty($ini['NEEDSPEELING']) ? 'false' : 'true'), PHP_EOL;
echo 'Seeds removed   = ', (empty($ini['SEEDSREMOVED']) ? 'false' : 'true'), PHP_EOL;
echo 'Other family    = ', print_r($ini['OTHERFAMILY'], true), PHP_EOL;
