var abr=`Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy
   COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find
   NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput
   Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO
   MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT
   READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT
   RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up`
   .split(/\W+/).map(_=>_.trim())
function escapeRegex(string) {
    return string.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&');
}
var input = prompt();
console.log(input.length==0?null:input.trim().split(/\s+/)
            .map(
              (s=>abr.filter(
                a=>(new RegExp('^'+escapeRegex(s),'i'))
                  .test(a)&&s.length>=a.match(/^[A-Z]+/)[0].length
				  )[0])
				)
            .map(_=>typeof _=="undefined"?"*error*":_).join(' ')
			)
