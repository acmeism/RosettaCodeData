case when a then b else c end

declare @n int
set @n=124
print case when @n=123 then 'equal' else 'not equal' end

--If/ElseIf expression
set @n=5
print case when @n=3 then 'Three' when @n=4 then 'Four' else 'Other' end
