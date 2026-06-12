seq char a f | str join ',' | $'{,($in)}{($in)}' | str expand | into int -r 16 | str join ' '
