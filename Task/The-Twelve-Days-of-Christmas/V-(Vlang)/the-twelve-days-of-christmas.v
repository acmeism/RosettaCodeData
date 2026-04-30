const gifts = "A partridge in a pear tree,Two turtle doves,Three french hens,Four calling birds,"
+ "Five golden rings,Six geese a-laying,Seven swans a-swimming,Eight maids a-milking,Nine ladies dancing,"
+ "Ten lords a-leaping,Eleven pipers piping,Twelve drummers drumming"
const days  = "first second third fourth fifth sixth seventh eighth ninth tenth eleventh twelfth"

fn main() {
    lstgifts := gifts.split(",")
    lstdays  := days.split(" ")
    for ial in 1..13 {
        println("On the ${lstdays[ial-1]} day of Christmas")
        println("My true love gave to me:")
        for jir := ial - 1; jir >= 0; jir-- {
            if ial > 1 && jir == 0 { println("and ") }
            println(lstgifts[jir])
        }
        println("")
    }
}
