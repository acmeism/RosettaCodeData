# 20211218 Perl programming solution

use strict;
use warnings;

use DBI;

my $dbh = DBI->connect("dbi:SQLite:dbname=:memory:");

$dbh->do("CREATE TABLE stocks (
   date TEXT, trans TEXT, symbol TEXT, qty REAL, price REAL
)");

my $sth = $dbh->prepare( "INSERT INTO stocks VALUES (?,?,?,?,?)" );

my @DATA = ( '"2006-01-05","BUY", "RHAT",  100, 35.14',
             '"2006-03-28","BUY",  "IBM", 1000, 45.00',
             '"2006-04-05","BUY","MSOFT", 1000, 72.00',
             '"2006-04-06","SELL", "IBM",  500,  53.00' );

for ( @DATA ) { $sth->execute( split /,/ ) or die }

$sth = $dbh->prepare("SELECT * FROM stocks ORDER BY price") or die;

$sth->execute();

my $format = "%-15s %-15s %-15s %-15s %-15s\n";

printf $format, $sth->{NAME}->@* ;

print '=' x 75 , "\n";

while ( my @row = $sth->fetchrow_array ) { printf $format, @row }
