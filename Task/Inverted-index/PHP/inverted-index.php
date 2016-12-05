<?php

function buildInvertedIndex($filenames)
{
    $invertedIndex = [];

    foreach($filenames as $filename)
    {
        $data = file_get_contents($filename);

        if($data === false) die('Unable to read file: ' . $filename);

        preg_match_all('/(\w+)/', $data, $matches, PREG_SET_ORDER);

        foreach($matches as $match)
        {
            $word = strtolower($match[0]);

            if(!array_key_exists($word, $invertedIndex)) $invertedIndex[$word] = [];
            if(!in_array($filename, $invertedIndex[$word], true)) $invertedIndex[$word][] = $filename;
        }
    }

    return $invertedIndex;
}

function lookupWord($invertedIndex, $word)
{
    return array_key_exists($word, $invertedIndex) ? $invertedIndex[$word] : false;
}

$invertedIndex = buildInvertedIndex2(['file1.txt', 'file2.txt', 'file3.txt']);

foreach(['cat', 'is', 'banana', 'it'] as $word)
{
    $matches = lookupWord($invertedIndex, $word);

    if($matches !== false)
    {
        echo "Found the word \"$word\" in the following files: " . implode(', ', $matches) . "\n";
    }
    else
    {
        echo "Unable to find the word \"$word\" in the index\n";
    }
}
