list=Import["http://www.puzzlers.org/pub/wordlists/unixdict.txt","Lines"];
text={#,StringJoin@@Sort[Characters[#]]}&/@list;
text=SortBy[text,#[[2]]&];
splits=Split[text,#1[[2]]==#2[[2]]&][[All,All,1]];
maxlen=Max[Length/@splits];
Select[splits,Length[#]==maxlen&]
