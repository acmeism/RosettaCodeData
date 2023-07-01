'begin'
    'string' dog = "Benjamin";
    'begin'
        'string' Dog = "Samba";
        'begin'
            'string' DOG = "Bernie";
            'if' DOG /= Dog 'or' DOG /= dog
            'then' print( ( "The three dogs are named: ", dog, ", ", Dog, " and ", DOG ) )
            'else' print( ( "There is just one dog named: ", DOG ) )
            'fi'
        'end'
    'end'
'end'
