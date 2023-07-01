delElem=: {~<@<@<
uppc=:(-32*96&<*.123&>)&.(3&u:)
reduc=: ] delElem  1 i.~e."0 1
forms=:  (1 - '' -: (reduc L:0/ :: (a:"_)@(<"0@],<@[))&uppc) L:0
