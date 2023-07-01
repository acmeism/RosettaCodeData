sub find-files ($dir, :$pattern) {
    run('find', $dir, '-iname', $pattern, '-print0', :out, :nl«\0»).out.lines;
}

.say for find-files '.', pattern => '*.txt';
