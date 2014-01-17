use DBIish;

my $db = DBIish.connect('DBI:mysql:mydatabase:host','login','password');

my $update = $db.prepare("UPDATE players SET name = ?, score = ?, active = ? WHERE jerseyNum = ?");

my $rows-affected = $update.execute("Smith, Steve",42,'true',99);
