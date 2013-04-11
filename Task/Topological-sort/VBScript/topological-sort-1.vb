class topological
	dim dictDependencies
	dim dictReported
	dim depth
	
	sub class_initialize
		set dictDependencies = createobject("Scripting.Dictionary")
		set dictReported = createobject("Scripting.Dictionary")
		depth = 0
	end sub
	
	sub reset
		dictReported.removeall
	end sub
	
	property let dependencies( s )
		'assuming token tab token-list newline
		dim i, j ,k
		dim aList
		dim dep
		dim a1
		aList = Split( s, vbNewLine )
		'~ remove empty lines at end
		do while aList( UBound( aList ) ) = vbnullstring
			redim preserve aList( UBound( aList ) - 1 )
		loop

		for i = lbound( aList ) to ubound( aList )
			aList( i ) = Split( aList( i ), vbTab, 2 )
			a1 = Split( aList( i )( 1 ), " " )
			k = 0
			for j = lbound( a1) to ubound(a1)
				if a1(j) <> aList(i)(0) then
					a1(k) = a1(j)
					k = k + 1
				end if
			next
			redim preserve a1(k-1)
			aList(i)(1) = a1
		next
		for i = lbound( aList ) to ubound( aList )
			dep = aList(i)(0)
			if not dictDependencies.Exists( dep ) then
				dictDependencies.add dep, aList(i)(1)
			end if
		next
		
	end property
	
	sub resolve( s )
		dim i
		dim deps
		'~ wscript.echo string(depth,"!"),s
		depth = depth + 1
		if dictDependencies.Exists(s) then
			deps = dictDependencies(s)
			for i = lbound(deps) to ubound(deps)
				resolve deps(i)
			next
		end if
		if not seen(s) then
			wscript.echo s
			see s
		end if
		depth = depth - 1
	end sub

	function seen( key )
		seen = dictReported.Exists( key )
	end function
	
	sub see( key )
		dictReported.add key, ""
	end sub
	
	property get keys
		keys = dictDependencies.keys
	end property
end class
