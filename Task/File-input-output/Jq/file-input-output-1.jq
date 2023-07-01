jq -M --raw-input --raw-output '. as $line | $line' input.txt > output.txt
