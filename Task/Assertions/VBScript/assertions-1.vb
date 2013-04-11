sub Assert( boolExpr, strOnFail )
	if not boolExpr then
		Err.Raise vbObjectError + 99999, , strOnFail
	end if
end sub
