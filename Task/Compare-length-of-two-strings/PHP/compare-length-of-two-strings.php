<?php


function retrieveStrings()
{
    if (isset($_POST['input'])) {
        $strings = explode("\n", $_POST['input']);
    } else {
        $strings = ['abcd', '123456789', 'abcdef', '1234567'];
    }
    return $strings;
}


function setInput()
{
    echo join("\n", retrieveStrings());
}


function setOutput()
{
    $strings = retrieveStrings();

    // Remove empty strings
    //
    $strings = array_map('trim', $strings);
    $strings = array_filter($strings);

    if (!empty($strings)) {
        usort($strings, function ($a, $b) {
            return strlen($b) - strlen($a);
        });
        $max_len = strlen($strings[0]);
        $min_len = strlen($strings[count($strings) - 1]);
        foreach ($strings as $s) {
            $length = strlen($s);
            if ($length == $max_len) {
                $predicate = "is the longest string";
            } elseif ($length == $min_len) {
                $predicate = "is the shortest string";
            } else {
                $predicate = "is neither the longest nor the shortest string";
            }
            echo "$s has length $length and $predicate\n";
        }
    }
}

?>


<!DOCTYPE html>
<html lang="en">

<head>
    <style>
        div {
            margin-top: 4ch;
            margin-bottom: 4ch;
        }

        label {
            display: block;
            margin-bottom: 1ch;
        }

        textarea {
            display: block;
        }

        input {
            display: block;
            margin-top: 4ch;
            margin-bottom: 4ch;
        }
    </style>
</head>


<body>
    <main>
        <form action=<?php echo $_SERVER['SCRIPT_NAME'] ?> method="post" accept-charset="utf-8">
            <div>
                <label for="input">Input:
                </label>
                <textarea rows='20' cols='80' name='input'><?php setInput(); ?></textarea>
                </label>
            </div>
            <input type="submit" value="press to compare strings">
            </input>
            <div>
                <label for="Output">Output:
                </label>
                <textarea rows='20' cols='80' name='output'><?php setOutput(); ?></textarea>
            </div>
        </form>
    </main>
</body>

</html>
