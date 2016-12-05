[
if(sys_listunboundmethods !>> 'randoms') => {
	define randoms()::array => {
		local(out = array)
		loop(4) => { #out->insert(math_random(9,1)) }
		return #out
	}
}
if(sys_listunboundmethods !>> 'checkvalid') => {
	define checkvalid(str::string, nums::array)::boolean => {
		local(chk = array('*','/','+','-','(',')',' '), chknums = array, lastintpos = -1, poscounter = 0)
		loop(9) => { #chk->insert(loop_count) }
		with s in #str->values do => {
			#poscounter++
			#chk !>> #s && #chk !>> integer(#s) ? return false
			integer(#s) > 0 && #lastintpos + 1 >= #poscounter ? return false
			integer(#s) > 0 ? #chknums->insert(integer(#s))
			integer(#s) > 0 ? #lastintpos = #poscounter
		}
		#chknums->size != 4 ? return false
		#nums->sort
		#chknums->sort
		loop(4) => { #nums->get(loop_count) != #chknums(loop_count) ? return false }
		return true
	}
}
if(sys_listunboundmethods !>> 'executeexpr') => {
	define executeexpr(expr::string)::integer => {
		local(keep = string)
		with i in #expr->values do => {
			if(array('*','/','+','-','(',')') >> #i) => {
				#keep->append(#i)
			else
				integer(#i) > 0 ? #keep->append(decimal(#i))
			}
		}
		return integer(sourcefile('['+#keep+']','24game',true,true)->invoke)
	}
}

local(numbers = array, exprsafe = true, exprcorrect = false, exprresult = 0)
if(web_request->param('nums')->asString->size) => {
	with n in web_request->param('nums')->asString->split(',') do => { #numbers->insert(integer(#n->trim&)) }
}
#numbers->size != 4 ? #numbers = randoms()
if(web_request->param('nums')->asString->size) => {
	#exprsafe = checkvalid(web_request->param('expr')->asString,#numbers)
	if(#exprsafe) => {
		#exprresult = executeexpr(web_request->param('expr')->asString)
		#exprresult == 24 ? #exprcorrect = true
	}
}

]<h1>24 Game</h1>
<p><b>Rules:</b><br>
Enter an expression that evaluates to 24</p>
<ul>
<li>Only multiplication, division, addition, and subtraction operators/functions are allowed.</li>
<li>Brackets are allowed.</li>
<li>Forming multiple digit numbers from the supplied digits is disallowed. (So an answer of 12+12 when given 1, 2, 2, and 1 is wrong).</li>
<li>The order of the digits when given does not have to be preserved.</li>
</ul>

<h2>Numbers</h2>
<p>[#numbers->join(', ')] (<a href="?">Reload</a>)</p>
[!#exprsafe ? '<p>Please provide a valid expression</p>']
<form><input type="hidden" value="[#numbers->join(',')]" name="nums"><input type="text" name="expr" value="[web_request->param('expr')->asString]"><input type="submit" name="submit" value="submit"></form>
[if(#exprsafe)]
<p>Result: <b>[#exprresult]</b> [#exprcorrect ? 'is CORRECT!' | 'is incorrect']</p>
[/if]
