class DLElem_Str does DLElem[Str] {}
class DLList_Str does DLList[DLElem_Str] {}

my $sdll = DLList_Str.new;
my $b = $sdll.first.post-insert('A').post-insert('B');
$b.pre-insert('C');
say $sdll.list;  # A C B
