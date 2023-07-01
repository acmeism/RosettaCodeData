def commands:
 "Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy " +
  "COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find " +
  "NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput " +
  "Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO " +
  "MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT " +
  "READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT " +
  "RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up ";

# produce a "dictionary" in the form of an array of {prefix, word} objects
def dictionary:
  reduce (splits(" +") | select(length>0)) as $w ([];
    . + [$w | {prefix: sub("[a-z]+";""), word: ascii_upcase} ]);

def translate($dict):
  # input: a string; $command: a {prefix, word} object
  def match($command):
     . as $uc
     | startswith($command.prefix) and ($command.word | startswith($uc));

  if length==0 then ""
  else ascii_upcase
  | first($dict[] as $command | select( match($command) ) | $command | .word)
    // "*error*"
  end;

# Emit the translation of an entire "sentence"
def translation:
  (commands|dictionary) as $dict
  | reduce splits(" +") as $w (""; . + ($w|translate($dict)) + " ")
  | sub(" $";"");

# Example:
"riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin"
| translation
