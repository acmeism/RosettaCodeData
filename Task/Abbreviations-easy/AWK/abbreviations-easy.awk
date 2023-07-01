#!/usr/bin/awk -f
BEGIN {
FS=" ";
split("   Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy" \
      "   COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find" \
      "   NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput" \
      "   Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO" \
      "   MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT" \
      "   READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT" \
      "   RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up" \
      , CMD);

	for (k=1; k <= length(CMD); k++) {
		cmd[k] = CMD[k];
		sub(/[a-z]*$/,"",cmd[k]);
		# print "0: ",CMD[k],"\t",cmd[k];
	}
}

function GET_ABBR(input) {
	for (k2=1; k2<=length(CMD); k2++) {
		if (index(toupper(CMD[k2]),input)==1) {
			if (index(input,toupper(cmd[k2]))==1) {
				return toupper(CMD[k2]);
			}
		}
	}
	return "*error*";
}

{
	R="";	
	for (k1=1; k1 <= NF; k1++) {
		R=R" "GET_ABBR(toupper($k1))
	}
	print R;
}
