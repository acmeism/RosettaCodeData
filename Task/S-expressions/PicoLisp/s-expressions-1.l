: (any "((data \"quoted data\" 123 4.5) (data (!@# (4.5) \"(more\" \"data)\")))")
-> ((data "quoted data" 123 5) (data (!@# (5) "(more" "data)")))

: (view @)
+---+-- data
|   |
|   +-- "quoted data"
|   |
|   +-- 123
|   |
|   +-- 5
|
+---+-- data
    |
    +---+-- !@#
        |
        +---+-- 5
        |
        +-- "(more"
        |
        +-- "data)"
