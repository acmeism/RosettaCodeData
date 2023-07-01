<
Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy
COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find
NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput
Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO
MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT
READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT
RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up
> ~~ m:g/ ((<.:Lu>+) <.:Ll>*) /;

my %abr = '' => '', |$/.map: {
    my $abbrv = .[0].Str.fc;
    |map { $abbrv.substr( 0, $_ ) => $abbrv.uc },
    .[0][0].Str.chars .. $abbrv.chars
};

sub abbr-easy ( $str ) { %abr{$str.trim.fc} // '*error*' }

# Testing
for 'riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin', '' -> $str {
    put ' Input: ', $str;
    put 'Output: ', join ' ', $str.words.map: &abbr-easy;
}
