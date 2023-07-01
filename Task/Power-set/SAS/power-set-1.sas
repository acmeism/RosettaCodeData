options mprint mlogic symbolgen source source2;

%macro SubSets (FieldCount = );
data _NULL_;
	Fields = &FieldCount;
	SubSets = 2**Fields;
	call symput ("NumSubSets", SubSets);
run;

%put &NumSubSets;

data inital;
	%do j = 1 %to &FieldCount;
		F&j. = 1;
	%end;
run;

data SubSets;
	set inital;
	RowCount =_n_;
	call symput("SetCount",RowCount);
run;

%put SetCount ;

%do %while (&SetCount < &NumSubSets);

data loop;
	%do j=1 %to &FieldCount;
		if rand('GAUSSIAN') > rand('GAUSSIAN') then F&j. = 1;
	%end;

data SubSets_  ;
set SubSets loop;
run;

proc sort data=SubSets_  nodupkey;
	by F1 - F&FieldCount.;
run;

data Subsets;
	set SubSets_;
	RowCount =_n_;
run;

proc sql noprint;
	select max(RowCount) into :SetCount
	from SubSets;
quit;
run;

%end;
%Mend SubSets;
