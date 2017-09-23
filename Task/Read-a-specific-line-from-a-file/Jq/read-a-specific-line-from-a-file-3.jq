$ jq -n -r 'range(0;20) | tostring' | jq --arg line 10 -n -R -r -f Read_a_specific_line_from_a_file.jq
9
