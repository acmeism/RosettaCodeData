--- Read CSV file and add columns headed with 'SUM'
--- with trace
-- trace(0)

include get.e
include std/text.e

function split(sequence s, integer c)
    sequence removables = " \t\n\r\x05\u0234\" "
    sequence out
    integer first, delim
    out = {}
    first = 1
    while first <= length(s) do
        delim = find_from(c,s,first)
        if delim = 0 then
            delim = length(s)+1
        end if
        out = append(out,trim(s[first..delim-1],removables))
        first = delim + 1
    end while
    return out
end function

procedure main()
    integer fn    -- the file number
    integer fn2   -- the output file number
    integer e     -- the number of lines read
    object line   -- the next line from the file
    sequence data = {} -- parsed csv data row
    sequence headerNames = {} -- array saving column names
    atom sum = 0.0     -- sum for each row
    sequence var  -- holds numerical data read

    -- First we try to open the file called "data.csv".
    fn = open("data.csv", "r")
    if fn = -1 then
        puts(1, "Can't open data.csv\n")
	-- abort();
    end if

    -- Then we create an output file for processed data.
    fn2 = open("newdata.csv", "w")
    if fn2 = -1 then
        puts(1, "Can't create newdata.csv\n")
    end if

    -- By successfully opening the file we have established that
    -- the file exists, and open() gives us a file number (or "handle")
    -- that we can use to perform operations on the file.

    e = 1
    while 1 do
        line = gets(fn)
        if atom(line) then
            exit
        end if
        data = split(line, ',')

        if (e=1) then
            -- Save the header labels and
	    -- write them to output file.
            headerNames = data
	    for i=1 to length(headerNames) do
	        printf(fn2, "%s,", {headerNames[i]})
	    end for
	    printf(fn2, "SUM\n")
        end if

        -- Run a sum for the numerical data.
        if (e >= 2) then
	    for i=1 to length(data) do
	        printf(fn2, "%s,", {data[i]})
		var = value(data[i])
		if var[1] = 0 then
		    -- data read is numerical
		    -- add to sum
		    sum = sum + var[2]
		end if
	    end for
            printf(fn2, "%g\n", {sum})
	    sum = 0.0
        end if
        e = e + 1
    end while

    close(fn)
    close(fn2)
end procedure

main()
