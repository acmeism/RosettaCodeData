switch actually
    case az
        echo The word is "az".
    case 'a*z'
        echo Begins with a and ends with z.
    case 'a*'
        echo Begins with a.
    case 'z*'
        echo Ends with z.
    case '*'
        echo Neither begins with a or ends with z.
end
