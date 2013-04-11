#! /bin/bash
stripchar-l ()
#removes the specified character from the left side of the string
#USAGE: stripchar "stuff" "s" --> tuff
{
    string="$1";
    string=${string#"$2"};

  echo "$string"
}

join ()
#join a string of characters on a specified delimiter
#USAGE: join "1;2;3;4" ";" "," --> 1,2,3,4
{
    local result="";
    local list="$1";
    OLDIFS="$IFS";
    local IFS=${2-" "};
    local output_field_seperator=${3-" "};

    for element in $list;
    do
        result="$result$output_field_seperator$element";
    done;

    result="`stripchar-l "$result" "$output_field_seperator"`";
    echo "$result";
    IFS="$OLDIFS"
}

split ()
{
#split a string of characters on a specified delimiter
#USAGE: split "1;2;3;4" ";" --> 1 2 3 4	
    local list="$1";
    local input_field_seperator=${2-" "};
    local output_field_seperator=" ";

  #defined in terms of join
  join "$list" "$input_field_seperator" "$output_field_seperator"
}

strtokenize ()
{
#splits up a string of characters into tokens,
#based on a user supplied delimiter
#USAGE:strtokenize "1;2;3;4" ";" ":" --> 1:2:3:4
    local list="$1";
	local input_delimiter=${2-" "};
	local output_delimiter=${3-" "};
	local contains_a_space=" "; #added to highlight the use
                                    #of " " as an argument to join	

  #splits it input then joins it with a user supplied delimiter
  join "$( split "$list" "$input_delimiter" )" \
    "$contains_a_space" "$output_delimiter";
}
