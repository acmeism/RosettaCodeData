<?php

function piece_wise($iban_all_digits) {

    $remainder = NULL;
    $slice = 9;

    for ($i=0; $i<strlen($iban_all_digits); $i=$i+$slice)
    {
        if ($i>0)
        {
            $slice = 7;
        }

        $part = $remainder . substr($iban_all_digits, $i, $slice);
        //echo "REMAINDER: " . $remainder . "<br>";
        //echo "PART: $part" . "<br>";
        $remainder = intval($part) % 97;
    }

return $remainder;

}


$iban = "GB82 WEST 1234 5698 7654 32";

//remove space
$iban = str_replace(' ', '', $iban);

//echo $iban; echo '<br>';
$iban_length = strlen($iban);
$country_code = substr($iban, 0, 2);

/*
    IBAN lengths are country specific
    full list available at
    https://en.wikipedia.org/wiki/International_Bank_Account_Number#IBAN_formats_by_country
*/
$lengths = ['GB' => 22];


if ($lengths[$country_code] != $iban_length)
{
    exit ("IBAN length not valid for $country_code");
}


// 2. move first four characters to the end
$iban = substr($iban, 4) . substr($iban, 0, 4);


//3. Replace letters in IBAN with digits
//(A=10, B=11 ... Z=35)

$iban_arr = str_split($iban, 1);


$iban_all_digits = '';

foreach ($iban_arr as $key=>$value)
{
    if (ctype_alpha($value))
    {
        $value = ord($value) - 55;
    }
    $iban_all_digits = $iban_all_digits . $value;
}


if (piece_wise($iban_all_digits) === 1)
{
    echo "VALID IBAN!";
}

else
{
    echo "IBAN NOT VALID";
}
