#!/usr/bin/lasso9

define config => type {

	data public configtxt, public path

	public oncreate(
		path::string = 'testing/configuration.txt'
	) => {
		.configtxt = file(#path) -> readstring
		.path = #path
	}

	public get(term::string) => {
		.clean
		local(
			regexp	= regexp(-find = `(?m)^` + #term + `($|\s*=\s*|\s+)(.*)$`, -input = .configtxt, -ignorecase),
			result
		)

		while(#regexp -> find) => {
			#result = (#regexp -> groupcount > 1 ? (#regexp -> matchString(2) -> trim& || true))
			if(#result -> asstring >> ',') => {
				#result = #result -> split(',')
				#result -> foreach => {#1 -> trim}
			}
			return #result
		}
		return false
	}

	public set(term::string, value) => {
		if(#value === false) => {
			.disable(#term)
			return
		}
		.enable(#term)
		if(#value -> isanyof(::string, ::integer, ::decimal)) => {
			.configtxt = regexp(-find = `(?m)^(` + #term + `) ?(.*?)$`, -replace = `$1 ` + #value, -input = .configtxt, -ignorecase) -> replaceall
		}
	}

	public disable(term::string) => {
		.clean
		local(regexp = regexp(-find = `(?m)^(` + #term + `)`, -replace = `; $1`, -input = .configtxt, -ignorecase))
		.configtxt = #regexp -> replaceall
	}

	public enable(term::string, -comment::string = '# Added ' + date) => {
		.clean
		local(regexp = regexp(-find = `(?m)^(; )?(` + #term + `)`, -replace = `$2`, -input = .configtxt, -ignorecase))
		if(#regexp -> find) => {
			.configtxt = #regexp -> replaceall
		else
			.configtxt -> append('\n' + (not #comment -> beginswith('#') ? '# ') +
				#comment + '\n' +
				string_uppercase(#term) + '\n'
			)
		}
	}

	public write => {
		local(config = file(.path))
		#config -> opentruncate
		#config -> dowithclose => {
			#config -> writestring(.configtxt)
		}

	}

	public clean => {

		local(
			cleaned = array,
			regexp	= regexp(-find = `^(;+)\W*$`)
		)

		with line in .configtxt -> split('\n') do {
			#line -> trim
			#regexp -> input = #line

			if(#line -> beginswith('#') or #line == '') => {
				#cleaned -> insert(#line)
			else(not (#regexp -> find))
				if(#line -> beginswith(';')) => {
					#line -> replace(regexp(`^;+ *`), `; `)
				else
					#line -> replace(regexp(`^(.*?) +(.*?)`), `$1 $2`)
				}
				#line -> replace(regexp(`\t`))
				#cleaned -> insert(#line)
			}
		}

		.configtxt = #cleaned -> join('\n')

	}

}
