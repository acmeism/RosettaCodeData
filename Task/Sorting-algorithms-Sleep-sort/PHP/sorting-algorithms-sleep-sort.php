<?php

$buffer = 1;
$pids = [];

for ($i = 1; $i < $argc; $i++) {
    $pid = pcntl_fork();
    if ($pid < 0) {
        die("failed to start child process");
    }

    if ($pid === 0) {
        sleep($argv[$i] + $buffer);
        echo $argv[$i] . "\n";
        exit();
    }

    $pids[] = $pid;
}

foreach ($pids as $pid) {
    pcntl_waitpid($pid, $status);
}
