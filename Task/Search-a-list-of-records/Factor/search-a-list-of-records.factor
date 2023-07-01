USING: accessors io kernel math prettyprint sequences ;
IN: rosetta-code.search-list

TUPLE: city name pop ;

CONSTANT: data {
    T{ city f "Lagos" 21.0 }
    T{ city f "Cairo" 15.2 }
    T{ city f "Kinshasa-Brazzaville" 11.3 }
    T{ city f "Greater Johannesburg" 7.55 }
    T{ city f "Mogadishu" 5.85 }
    T{ city f "Khartoum-Omdurman" 4.98 }
    T{ city f "Dar Es Salaam" 4.7 }
    T{ city f "Alexandria" 4.58 }
    T{ city f "Abidjan" 4.4 }
    T{ city f "Casablanca" 3.98 }
}

! Print the index of the first city named Dar Es Salaam.
data [ name>> "Dar Es Salaam" = ] find drop .

! Print the name of the first city with under 5 million people.
data [ pop>> 5 < ] find nip name>> print

! Print the population of the first city starting with 'A'.
data [ name>> first CHAR: A = ] find nip pop>> .
