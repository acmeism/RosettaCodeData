program systemTime(output);
var
	ts: timeStamp;
begin
	getTimeStamp(ts);
	
	{
		If `getTimeStamp` is unable to obtain the time, it will
		set `timeValid` to `false` and `hour`, `minute` and
		`second` are set to a time representing midnight (0:00:00).
	}
	if ts.timeValid then
	begin
		writeLn(time(ts));
	end;
end.
