program convertSecondsToCompoundDuration(output);

const
	suffixUnitWeek    = 'wk';
	suffixUnitDay     = 'd';
	suffixUnitHour    = 'hr';  { Use `'h'` to be SI-compatible. }
	suffixUnitMinute  = 'min';
	suffixUnitSecond  = 'sec'; { NB: Only `'s'` is SI-approved. }
	
	suffixSeparator   = ' ';  { A non-breaking space would be appropriate. }
	quantitySeparator = ', ';
	
	{ Maximum expected length of `string` “12345 wk, 6 d, 7 hr, 8 min, 9 sec” }
	timeSpanPrintedMaximumLength = 4 * length(quantitySeparator) +
		20 + length(suffixUnitWeek) + 1 + length(suffixUnitDay) +
		2 + length(suffixUnitHour) + 2 + length(suffixUnitMinute) +
		2 + length(suffixUnitSecond) + 5 * length(suffixSeparator);
	
	{ Units of time expressed in seconds. }
	minute = 60;
	hour   = 60 * minute;
	day    = 24 * hour;
	week   =  7 * day;

type
	wholeNumber   = 0..maxInt;
	naturalNumber = 1..maxInt;
	
	canonicalTimeSpan = record
			weeks:   wholeNumber;
			days:    0..6;
			hours:   0..23;
			minutes: 0..59;
			seconds: 0..59;
		end;
	
	stringFitForTimeSpan = string(timeSpanPrintedMaximumLength);

{
	\brief turns a time span expressed in seconds into a `canonicalTimeSpan`
	\param duration the non-negative duration expressed in seconds
	\return a `canonicalTimeSpan` representing \param duration seconds
}
function getCanonicalTimeSpan(duration: wholeNumber): canonicalTimeSpan;
	{ Perform `div`ision and update `duration`. }
	function split(protected unit: naturalNumber): wholeNumber;
	begin
		split := duration div unit;
		duration := duration mod unit
	end;
var
	result: canonicalTimeSpan;
begin
	with result do
	begin
		weeks   := split(week);
		days    := split(day);
		hours   := split(hour);
		minutes := split(minute);
		seconds := duration
	end;
	{ In Pascal there needs to be _exactly_ one assignment to the }
	{ result variable bearing the same name as of the `function`. }
	getCanonicalTimeSpan := result
end;

{
	\brief turns a non-trivial duration into a string
	\param n a positive duration expressed in seconds
	\return \param n expressed in some human-readable form
}
function timeSpanString(protected n: naturalNumber): stringFitForTimeSpan;
const
	qs = quantitySeparator;
var
	result: stringFitForTimeSpan;
begin
	with getCanonicalTimeSpan(n) do
	begin
		{ `:1` specifies the minimum-width. Omitting it would cause }
		{ the compiler to insert a vendor-defined default, e. g. 20. }
		writeStr(result, weeks:1, suffixSeparator, suffixUnitWeek);
		{ For strings, `:n` specifies the _exact_ width (padded with spaces). }
		writeStr(result, result:ord(weeks > 0) * length(result));
		
		if days > 0 then
		begin
			writeStr(result, result, qs:ord(length(result) > 0) * length(qs),
				days:1, suffixSeparator, suffixUnitDay);
		end;
		if hours > 0 then
		begin
			writeStr(result, result, qs:ord(length(result) > 0) * length(qs),
				hours:1, suffixSeparator, suffixUnitHour);
		end;
		if minutes > 0 then
		begin
			writeStr(result, result, qs:ord(length(result) > 0) * length(qs),
				minutes:1, suffixSeparator, suffixUnitMinute);
		end;
		if seconds > 0 then
		begin
			writeStr(result, result, qs:ord(length(result) > 0) * length(qs),
				seconds:1, suffixSeparator, suffixUnitSecond);
		end
	end;
	timeSpanString := result
end;

{ === MAIN ============================================================= }
begin
	writeLn(   7259, ' seconds are “', timeSpanString(7259), '”');
	writeLn(  86400, ' seconds are “', timeSpanString(86400), '”');
	writeLn(6000000, ' seconds are “', timeSpanString(6000000), '”')
end.
