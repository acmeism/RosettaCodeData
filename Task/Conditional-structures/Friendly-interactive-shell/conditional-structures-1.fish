set var 'Hello World'
if test $var = 'Hello World'
    echo 'Welcome.'
else if test $var = 'Bye World'
    echo 'Bye.'
else
    echo 'Huh?'
end
