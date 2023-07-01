input is:
((data da\(\)ta "quot\\ed data" 123 4.5)
 ("data" (!@# (4.5) "(mo\"re" "data)")))
parsed as:
(
    (
        data
        da\(\)ta
        "quot\\ed data"
        123
        4.5
    )
    (
        "data"
        (
            !@#
            (
                4.5
            )
            "(mo\"re"
            "data)"
        )
    )
)
