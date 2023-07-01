my @directories = grep { chomp; -d } `ls`;
for (@directories) {
chomp;
...; # Operate on directories
}
