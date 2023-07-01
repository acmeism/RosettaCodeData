@c = (join ' ', qw<
Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy
COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find
NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput
Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO
MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT
READ  RECover REFRESH RENum Replace REPeat  CReplace  RESet  RESTore  RGTLEFT
RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up
>) =~ /([A-Z]+)([a-z]*)(?:\s+|$)/g;

my %abr = ('' => '', ' ' => '');
for ($i = 0; $i < @c; $i += 2) {
    $sl = length($s =    $c[$i]  );
    $ll = length($l = uc $c[$i+1]);
    $abr{$s} = $w = $s.$l;
    map { $abr{substr($w, 0, $_)} = $w } $sl .. $ll;
    $abr{$w} = $w; # full command should always work
}

$fmt = "%-10s";
$inp = sprintf $fmt, 'Input:';
$out = sprintf $fmt, 'Output:';
for $str ('', qw<riG rePEAT copies put mo rest types fup. 6 poweRin>) {
    $inp .= sprintf $fmt, $str;
    $out .= sprintf $fmt, $abr{uc $str} // '*error*';
}

print "$inp\n$out\n"
