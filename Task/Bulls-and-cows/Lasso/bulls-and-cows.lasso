[
define randomizer() => {
	local(n = string)
	while(#n->size < 4) => {
		local(r = integer_random(1,9)->asString)
		#n !>> #r ? #n->append(#r)
	}
	return #n
}
define cowbullchecker(n::string,a::string) => {
	integer(#n) == integer(#a) ? return (:true,map('cows'=0,'bulls'=4,'choice'=#a))
	local(cowbull = map('cows'=0,'bulls'=0,'choice'=#a),'checked' = array)
	loop(4) => {
		if(#checked !>> integer(#a->values->get(loop_count))) => {
			#checked->insert(integer(#a->values->get(loop_count)))
			if(integer(#n->values->get(loop_count)) == integer(#a->values->get(loop_count))) => {
				#cowbull->find('bulls') += 1
			else(#n->values >> #a->values->get(loop_count))
				#cowbull->find('cows') += 1
			}
		}
	}
	#cowbull->find('bulls') == 4 ? return (:true,map('cows'=0,'bulls'=4,'choice'=#a))
	return (:true,#cowbull)
}
session_start('user')
session_addvar('user', 'num')
session_addvar('user', 'historic_choices')
// set up rand
var(num)->isNotA(::string) ? var(num = randomizer)
var(historic_choices)->isNotA(::array) ? var(historic_choices = array)
local(success = false)
// check answer
if(web_request->param('a')->asString->size) => {
	local(success,result) = cowbullchecker($num,web_request->param('a')->asString)
	$historic_choices->insert(#result)
}
if(web_request->params->asStaticArray >> 'restart') => {
	$num = randomizer
	$historic_choices = array
}
]
<h1>Bulls and Cows</h1>
<p>Guess the 4-digit number...</p>
<p>Your win if the guess is the same as the randomly chosen number.<br>
- A score of one bull is accumulated for each digit in your guess that equals the corresponding digit in the randomly chosen initial number.<br>
- A score of one cow is accumulated for each digit in your guess that also appears in the randomly chosen number, but in the wrong position.
</p>
[
local(win = false)
if($historic_choices->size) => {
	with c in $historic_choices do => {^
		'<p>'+#c->find('choice')+': Bulls: '+#c->find('bulls')+', Cows: '+#c->find('cows')
		if(#c->find('bulls') == 4) => {^
			' - YOU WIN!'
			#win = true
		^}
		'</p>'
	^}
}
if(not #win) => {^
]
<form action="?" method="post">
	<input name="a" value="[web_request->param('a')->asString]" size="5">
	<input type="submit" name="guess">
	<a href="?restart">Restart</a>
</form>
[else
	'<a href="?restart">Restart</a>'
^}]
