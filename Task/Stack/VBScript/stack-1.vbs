class stack
	dim tos
	dim stack()
	dim stacksize
	
	private sub class_initialize
		stacksize = 100
		redim stack( stacksize )
		tos = 0
	end sub

	public sub push( x )
		stack(tos) = x
		tos = tos + 1
	end sub
	
	public property get stackempty
		stackempty = ( tos = 0 )
	end property
	
	public property get stackfull
		stackfull = ( tos > stacksize )
	end property
	
	public property get stackroom
		stackroom = stacksize - tos
	end property
	
	public function pop()
		pop = stack( tos - 1 )
		tos = tos - 1
	end function

	public sub resizestack( n )
		redim preserve stack( n )
		stacksize = n
		if tos > stacksize then
			tos = stacksize
		end if
	end sub
end class

dim s
set s = new stack
s.resizestack 10
wscript.echo s.stackempty
dim i
for i = 1 to 10
	s.push rnd
	wscript.echo s.stackroom
	if s.stackroom = 0 then exit for
next
for i = 1 to 10
	wscript.echo s.pop
	if s.stackempty then exit for
next
