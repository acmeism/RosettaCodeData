[
	define_tag("hailstone", -required="n", -type="integer", -copy);
		local("sequence") = array(#n);
		while(#n != 1);
			((#n % 2) == 0) ? #n = (#n / 2) | #n = (#n * 3 + 1);
			#sequence->insert(#n);
		/while;
		return(#sequence);
	/define_tag;

	local("result");
	#result = hailstone(27);
	while(#result->size > 8);
		#result->remove(5);
	/while;
	#result->insert("...",5);

	"Hailstone sequence for n = 27 -> { " + #result->join(", ") + " }";

	local("longest_sequence") = 0;
	local("longest_index") = 0;
	loop(-from=1, -to=100000);
		local("length") = hailstone(loop_count)->size;
		if(#length > #longest_sequence);
			#longest_index = loop_count;
			#longest_sequence = #length;
		/if;
	/loop;

	"<br/>";
	"Number with the longest sequence under 100,000: " #longest_index + ", with " + #longest_sequence + " elements.";
]
