use ntheory qw/forperm/;
my @tasks = (qw/party sleep study/);
forperm {
  print "@tasks[@_]\n";
} scalar(@tasks);
