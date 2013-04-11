dim c
set c = new closure

c.compose "ucase", "lcase"
wscript.echo c.formula
wscript.echo c("dog")

c.compose "log", "exp"
wscript.echo c.formula
wscript.echo c(12.3)

function inc( n )
	inc = n + 1
end function

c.compose "inc", "inc"
wscript.echo c.formula
wscript.echo c(12.3)

function twice( n )
	twice = n * 2
end function

c.compose "twice", "inc"
wscript.echo c.formula
wscript.echo c(12.3)
