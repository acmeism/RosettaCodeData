my $path = "/etc/passwd";
say $path.IO.e ?? "Exists" !! "Does not exist";

given $path.IO {
    when :d { say "$path is a directory"; }
    when :f { say "$path is a regular file"; }
    when :e { say "$path is neither a directory nor a file, but it does exist"; }
    default { say "$path does not exist" }
}
