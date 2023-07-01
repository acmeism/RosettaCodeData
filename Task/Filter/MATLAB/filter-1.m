function evens = selectEvenNumbers(list)

    evens = list( mod(list,2) == 0 );

end
