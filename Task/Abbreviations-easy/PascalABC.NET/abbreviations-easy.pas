begin
  var commands :=
    '''
    Add ALTer BAckup Bottom CAppend Change SCHANGE CInsert CLAst COMPress COpy
    COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find
    NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput
    Join SPlit SPLTJOIN LOAD Locate CLocate LOWercase UPPercase LPrefix MACRO
    MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD Query QUIT
    READ RECover REFRESH RENum REPeat Replace CReplace RESet RESTore RGTLEFT
    RIght LEft SAVE SET SHift SI SORT SOS STAck STATus TOP TRAnsfer Type Up
    '''.ToWords(AllDelimiters);

  var countDict := commands.Each(word -> word.TakeWhile(c -> c.IsUpper).Count);

  var correctedLine := 'riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin'
    .ToWords
    .Select(word ->
      commands.FirstOrDefault(
        cmd -> cmd.ToLower.StartsWith(word.ToLower) and
               (word.Length >= countDict[cmd])
      )?.ToUpper ?? '*error*'
    )
    .JoinToString;

  Print(correctedLine);
end.
