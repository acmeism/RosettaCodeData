%macro step_up();

	%do %while (not %step);
		%put Step Down;
		%step_up;
		%end;
	%put Step Up;

	%mend step_up;
