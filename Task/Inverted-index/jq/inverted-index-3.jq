$ jq -r -c -n --argfile in <(jq -R 'split(" ") | select(length>0) | [input_filename, unique]' T?.txt) -f Inverted_index.jq
Enter a string or an array of strings to search for, quoting each string, or 0 to exit:
"is"
["T0.txt","T1.txt","T2.txt"]
Enter a string or an array of strings to search for, quoting each string, or 0 to exit:
["is", "banana"]
["T2.txt"]
Enter a string or an array of strings to search for, quoting each string, or 0 to exit:
0
$
