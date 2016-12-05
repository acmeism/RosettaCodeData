set gifts to {"A partridge in a pear tree.", "Two turtle doves, and", ¬
	"Three French hens,", "Four calling birds,", ¬
	"Five gold rings,", "Six geese a-laying,", ¬
	"Seven swans a-swimming,", "Eight maids a-milking,", ¬
	"Nine ladies dancing,", "Ten lords a-leaping,", ¬
	"Eleven pipers piping,", "Twelve drummers drumming"}

set labels to {"first", "second", "third", "fourth", "fifth", "sixth", ¬
	"seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth"}

repeat with day from 1 to 12
	log "On the " & item day of labels & " day of Christmas, my true love sent to me:"
	repeat with gift from day to 1 by -1
		log item gift of gifts
	end repeat
	log ""
end repeat
