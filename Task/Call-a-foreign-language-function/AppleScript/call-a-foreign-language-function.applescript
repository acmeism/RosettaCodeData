on js_isnan(s)
	run script "isNaN(" & s & ")" in "JavaScript"
end js_isnan

js_isnan("{}+{}")
