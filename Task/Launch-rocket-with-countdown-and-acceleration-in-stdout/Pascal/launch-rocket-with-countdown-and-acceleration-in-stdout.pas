program launchRocketWithCountdownAndAccelerationOnOutput(output);

const
	screenWidth = 80;

type
	wholeNumber = 0..maxInt;
	natural = 1..maxInt;

var
	n: wholeNumber;

{
	Pascal, as defined by ISO standard 7185, does not provide any
	facilities to time actions. Nevertheless, most compiler vendors
	invented their own `sleep` or `delay` procedures.
}
procedure sleep(n: natural);
begin
	{ Yes, in Pascal an empty statement is valid. }
	{ There is really nothing after `do`. }
	for n := n downto 1 do
end;

procedure drawRocket(column: natural);
begin
	{ `page` is shorthand for `page(output)`, }
	{ as is `writeLn(…)` shorthand for `writeLn(output, …)`. }
	page;
	{ It should be an easy feat to adapt this to contain ASCII only. }
	writeLn(' ':column, '🙮')
end;

{ === MAIN ============================================================= }
begin
	for n := 5 downto 0 do
	begin
		drawRocket(1);
		writeLn;
		writeLn(n);
		sleep(5318008)
	end;
	
	n := 1;
	while n < screenWidth do
	begin
		n := round(n * 1.5);
		sleep(58008);
		drawRocket(n)
	end
end.
