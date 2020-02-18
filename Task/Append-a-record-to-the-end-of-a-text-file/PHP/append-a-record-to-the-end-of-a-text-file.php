<?php

$filename = '/tmp/passwd';

$data = array(
    'account:password:UID:GID:fullname,office,extension,homephone,email:directory:shell' . PHP_EOL,
    'jsmith:x:1001:1000:Joe Smith,Room 1007,(234)555-8917,(234)555-0077,jsmith@rosettacode.org:/home/jsmith:/bin/bash' . PHP_EOL,
    'jdoe:x:1002:1000:Jane Doe,Room 1004,(234)555-8914,(234)555-0044,jdoe@rosettacode.org:/home/jdoe:/bin/bash' . PHP_EOL,
);
file_put_contents($filename, $data, LOCK_EX);

echo 'File contents before new record added:', PHP_EOL, file_get_contents($filename), PHP_EOL;

$data = array(
    'xyz:x:1003:1000:X Yz,Room 1003,(234)555-8913,(234)555-0033,xyz@rosettacode.org:/home/xyz:/bin/bash' . PHP_EOL
);
file_put_contents($filename, $data, FILE_APPEND | LOCK_EX);

echo 'File contents after new record added:', PHP_EOL, file_get_contents($filename), PHP_EOL;
