// note this is php 7.x
$commands = 'Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy
   COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find
   NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput
   Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO
   MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT
   READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT
   RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up';

$input = 'riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin';
$expect = 'RIGHT REPEAT *error* PUT MOVE RESTORE *error* *error* *error* POWERINPUT';
$table = makeCommandTable($commands);
$table_keys = array_keys($table);

$inputTable = processInput($input);

foreach ($inputTable as $word) {
    $rs = searchCommandTable($word, $table);
    if ($rs) {
        $output[] = $rs;
    } else {
        $output[] = '*error*';
    }

}
echo 'Input: '. $input. PHP_EOL;
echo 'Output: '. implode(' ', $output). PHP_EOL;

function searchCommandTable($search, $table) {
    foreach ($table as $key => $value) {
        if ((strtoupper(substr($value['word'], 0, strlen($search))) === strtoupper($search)) && (strlen($search) >= $value['min_length'])) {
            return $key;
        }
    }
    return false;
}

function processInput($input) {
    $input = preg_replace('!\s+!', ' ', $input);
    $pieces = explode(' ', trim($input));
    return $pieces;
}

function makeCommandTable($commands) {
    $commands = preg_replace('!\s+!', ' ', $commands);
    $pieces = explode(' ', trim($commands));
    foreach ($pieces as $word) {
        $rs[strtoupper($word)] = ['word'=>$word, 'min_length' => preg_match_all("/[A-Z]/", $word)];
    }
    return $rs;
}
