%macro step();
	%sysfunc(round(%sysfunc(ranuni(0))))
	%mend step;
