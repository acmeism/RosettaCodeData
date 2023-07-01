%macro step_up();

	%if not %step %then %do;
		%put Step Down;
		%step_up;
		%step_up;
		%end;
	%else %put Step Up;

	%mend step_up;

%step_up;
