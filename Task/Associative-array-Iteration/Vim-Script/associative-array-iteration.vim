let dict = {"apples": 11, "oranges": 25, "pears": 4}

echo "Iterating over key-value pairs"
for [key, value] in items(dict)
    echo key " => " value
endfor
echo "\n"

echo "Iterating over keys"
for key in keys(dict)
    echo key
endfor
echo "\n"

echo "Iterating over values"
for value in values(dict)
    echo value
endfor
