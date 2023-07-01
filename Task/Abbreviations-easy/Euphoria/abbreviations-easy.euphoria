include std/text.e  -- for upper conversion
include std/console.e -- for display
include std/sequence.e

sequence ct = """
Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy
COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find
NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput
Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO
MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT
READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT
RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up
"""
ct = upper(split(join(split(ct,"\n")," ")," "))

object input = remove_all("\n",upper(remove_all("",split(gets(0)))))
display(validate(input))

-------------------------------
function validate(object words)
-------------------------------
object results = repeat("*error*",length(words)) -- build an output list;
integer x
for i = 1 to length(words) do
    words[i] = remove_all('\n',words[i]) -- final word in input line (may) have \n, get rid of it;
    for j = 1 to length(ct) do
        x = match(words[i],ct[j])
        if x = 1 then
            results[i] = ct[j] -- replace this slot in the output list with the "found" word;
            exit -- and don't look further into the list;
        end if
    end for
end for
return flatten(join(results," ")) -- convert sequence of strings into one string, words separated by a single space;
end function
