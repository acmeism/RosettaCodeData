entity fizzbuzz is
end entity fizzbuzz;

architecture beh of fizzbuzz is

	procedure fizzbuzz(num : natural) is
	begin
		if num mod 15 = 0 then
			report "FIZZBUZZ";
		elsif num mod 3 = 0 then
			report "FIZZ";
		elsif num mod 5 = 0 then
		    report "BUZZ";
		else
			report to_string(num);
		end if;
	end procedure fizzbuzz;

begin

	p_fizz : process is
	begin
		for i in 1 to 100 loop
		fizzbuzz(i);
		end loop;
		wait for 200 us;
	end process p_fizz;

end architecture beh;
