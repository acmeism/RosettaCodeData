[
session_start('user')
session_addvar('user', 'matrix')
session_addvar('user', 'winrecord')
session_addvar('user', 'turn')
var(matrix)->isNotA(::array) ? var(matrix = array('-','-','-','-','-','-','-','-','-'))
var(winrecord)->isNotA(::array) ? var(winrecord = array)
var(turn)->isNotA(::string) ? var(turn = 'x')

if(web_request->params->asStaticArray >> 'reset') => {
	$matrix = array('-','-','-','-','-','-','-','-','-')
	$turn = 'x'
}

with i in web_request->params->asStaticArray do => {
	if(#i->name->beginswith('p')) => {
		local(num = #i->name->asCopy)
		#num->removeLeading('p')
		#num = integer(#num)
		#num > 0 && $matrix->get(#num) == '-' ? $matrix->get(#num) = #i->value
		$turn == 'o' ? $turn = 'x' | $turn = 'o'
	}
}

local(
	istie 	= false,
	winner	= 'noone',
	clear	= false
)

// determine if we have a winner
if($matrix->find('-')->size < 9) => {
	local(winners = array('123','456','789','147','258','369','159','357'))
	loop(8) => {
		local(xscore = 0,oscore = 0,use = #winners->get(loop_count))
		with v in #use->values do => {
			$matrix->findposition('x') >> integer(#v) ? #xscore++
			$matrix->findposition('o') >> integer(#v) ? #oscore++
		}
		if(#xscore == 3) => {
			#winner = 'x'
			$winrecord->insert('x')
			#clear = true
			loop_abort
		}
		if(#oscore == 3) => {
			#winner = 'o'
			$winrecord->insert('o')
			#clear = true
			loop_abort
		}
		
	}
	
}
// determine if tie
if(not $matrix->find('-')->size && #winner == 'noone') => {
	#istie = true
	#winner = 'tie'
	$winrecord->insert('tie')
	#clear = true
}
]
<form action="?" method="post">
  <table>
    <tr>
      [loop(3) => {^]<td><button name="p[loop_count]" value="[$turn]"[
        $matrix->get(loop_count) != '-' || #winner != 'noone' ? ' disabled="disabled"'
      ]>[$matrix->get(loop_count) != '-' ? $matrix->get(loop_count) | ' ']</button></td>[^}]
    </tr>
    <tr>
      [loop(-from=4,-to=6) => {^]<td><button name="p[loop_count]" value="[$turn]"[
        $matrix->get(loop_count) != '-' || #winner != 'noone' ? ' disabled="disabled"'
      ]>[$matrix->get(loop_count) != '-' ? $matrix->get(loop_count) | ' ']</button></td>[^}]
    </tr>
    <tr>
      [loop(-from=7,-to=9) => {^]<td><button name="p[loop_count]" value="[$turn]"[
        $matrix->get(loop_count) != '-' || #winner != 'noone' ? ' disabled="disabled"'
      ]>[$matrix->get(loop_count) != '-' ? $matrix->get(loop_count) | ' ']</button></td>[^}]
    </tr>
  </table>
</form>
[if(#istie && #winner == 'tie')]
<p><b>It's a tie!</b></p>
[else(#winner != 'noone')]
<p>[#winner->uppercase&] won! Congratulations.</p>
[else]<math>Insert formula here</math>
<p>It is now [$turn]'s turn!</p>
[/if]
<p><a href="?reset">Reset</a></p>
[if($winrecord->size)]<p>Win record: [$winrecord->join(', ')]</p>[/if]
[if(#clear == true) => {
	$matrix = array('-','-','-','-','-','-','-','-','-')
	$turn = 'x'
}]
