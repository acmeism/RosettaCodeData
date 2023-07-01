function R = abbreviations_easy(input)

CMD=strsplit(['Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy' ...
'   COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find'  ...
'   NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput' ...
'   Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO' ...
'   MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT' ...
'   READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT' ...
'   RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up' ],' ');

for k=1:length(CMD)	
	cmd{k} = CMD{k}(CMD{k}<'a');
	CMD{k} = upper(CMD{k});
end

ilist = strsplit(input,' ');
R = '';
for k=1:length(ilist)
	input = upper(ilist{k});

	ix = find(strncmp(CMD, input, length(input)));
	result= '*error*';
	for k = ix(:)',	
		if strncmp(input, cmd{k}, length(cmd{k}));
			result = CMD{k};
		end
	end
	R = [R,' ',result];
end
