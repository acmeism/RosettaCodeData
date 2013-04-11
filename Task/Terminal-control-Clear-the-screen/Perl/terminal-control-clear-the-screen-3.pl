use Term::Cap;

$terminal = Term::Cap->Tgetent();
$clear = $terminal->Tputs('cl');
print $clear;
