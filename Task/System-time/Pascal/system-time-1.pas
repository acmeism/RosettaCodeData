type
	timeStamp = packed record
			dateValid: Boolean;
			year: integer;
			month: 1..12;
			day: 1..31;
			timeValid: Boolean;
			hour: 0..23;
			minute: 0..59;
			second: 0..59;
		end;
