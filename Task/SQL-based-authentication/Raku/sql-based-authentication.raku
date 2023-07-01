use v6;
use DBIish;

multi connect_db(:$dbname, :$host, :$user, :$pass) {
   my $db = DBIish.connect("mysql",host => $host, database =>$dbname, user =>$user, password =>$pass, :RaiseError)
      or die "ERROR: {DBIish.errstr}.";
   $db;
}

multi create_user(:$db, :$user, :$pass) {
   #https://stackoverflow.com/questions/53365101/converting-pack-to-perl6
   my $salt = Buf.new((^256).roll(16));
   my $sth = $db.prepare(q:to/STATEMENT/);
      INSERT IGNORE INTO users (username, pass_salt, pass_md5)
      VALUES (?, ?, unhex(md5(concat(pass_salt, ?))))
   STATEMENT
   $sth.execute($user,$salt,$pass);
   $sth.insert-id or Any;
}

multi authenticate_user (:$db, :$user, :$pass) {
   my $sth = $db.prepare(q:to/STATEMENT/);
       SELECT userid FROM users WHERE
       username=? AND pass_md5=unhex(md5(concat(pass_salt, ?)))
   STATEMENT
   $sth.execute($user,$pass);
   my $userid =  $sth.fetch;
   $userid[0] or Any;
}
