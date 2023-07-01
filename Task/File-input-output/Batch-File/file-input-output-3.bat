for /f "" %L in ('more^<input.txt') do echo %L>>output.txt
