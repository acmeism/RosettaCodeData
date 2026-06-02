#Requires AutoHotkey v2.0

_EmptyMap := Map() ; create empty map
MyMap := Map("key1", 1, "key2", 2) ; initialize with key-value pairs
MyMap["key3"] := 3 ; add key-value pair
MyMap.Set "key4", 4, "key5", 5 ; another way
MyMap.Delete "key1" ; remove key-value pair (by key)
_hasKey1 := MyMap.Has("key1") ; test key existence

info := ""
; iteration
for key, value in MyMap
    info .= "key: " key " value: " value "`n"

MsgBox info
