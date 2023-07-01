sub find-files ($dir, Mu :$test) {
    gather for dir $dir -> $path {
        if $path.basename ~~ $test { take $path }
        if $path.d                 { .take for find-files $path, :$test };
    }
}

.put for find-files '.', test => /'.txt' $/;
