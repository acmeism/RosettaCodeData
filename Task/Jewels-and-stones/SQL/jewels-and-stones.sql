-- See how many jewels are among the stones
declare @S varchar(1024) 	=	'AaBbCcAa'
,	@J varchar(1024)	=	'aA';

declare @SLEN	int = len(@S);
declare @JLEN	int = len(@J);
declare @TCNT	int = 0;

declare @SPOS	int = 1;	-- curr position in @S
declare @JPOS	int = 1;	-- curr position in @J
declare @FCHR	char(1);	-- char to find

while @JPOS <= @JLEN
begin

	set @FCHR = substring(@J, @JPOS, 1);

	set @SPOS = 1;

	while @SPOS > 0 and @SPOS <= @SLEN
	begin
		
		set @SPOS = charindex(@FCHR, @S COLLATE Latin1_General_CS_AS, @SPOS);
		
		if @SPOS > 0 begin
			set @TCNT = @TCNT + 1;
			set @SPOS = @SPOS + 1;
		end
	end

	set @JPOS = @JPOS + 1;
end
print 'J='+@J+' S='+@S+' TOTAL = '+cast(@TCNT as varchar(8));
