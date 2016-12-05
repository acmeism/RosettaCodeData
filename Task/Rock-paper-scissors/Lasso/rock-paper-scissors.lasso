session_start('user')
session_addvar('user', 'historic_choices')
session_addvar('user', 'win_record')
session_addvar('user', 'plays')
var(historic_choices)->isNotA(::map) ? var(historic_choices = map('rock'=0, 'paper'=0, 'scissors'=0))
var(plays)->isNotA(::integer) ? var(plays = 0)
var(win_record)->isNotA(::array) ? var(win_record = array)

define br => '<br>'
define winner(c::string,p::string) => {
	if(#c == $superior->find(#p)) => {
		$win_record->insert('lasso')
		return 'Lasso'
	else(#p == $superior->find(#c))
		$win_record->insert('user')
		return 'User'
	else
		$win_record->insert('tie')
		return 'Nobody'
		}
	}

	var(
		choice 				= web_request->param('choice')->asString,
	lookup 				= array('rock', 'paper', 'scissors'),
	computer_choice 	= $lookup->get(math_random(3,1)),
	superior			= map('rock'='paper', 'paper'='scissors', 'scissors'='rock'),
	controls			= '<a href=?choice=rock>Rock</a> <a href=?choice=paper>Paper</a> <a href=?choice=scissors>Scissors</a> <a href=?choice=quit>Quit</a><br/>'
)
if($choice == 'quit') => {^
	'See ya. <a href=?>Start over</a>'
	session_end('user')
	$historic_choices = map('rock'=0, 'paper'=0, 'scissors'=0)
	$plays = 0
	$win_record = array
	
else(array('rock','paper','scissors') >> $choice)
		$controls

		if($plays != 0) => {
			local('possibilities') = array
			with i in $lookup do => {
				loop($historic_choices->find(#i)) => { #possibilities->insert(#i) }
			}
			
			$computer_choice = $superior->find(#possibilities->get(math_random($plays,1)))
		}

		'User chose ' + $choice + br
	'Lasso chose ' + $computer_choice + br
	winner($computer_choice->asString, $choice) + ' wins!'

		$historic_choices->find($choice) = $historic_choices->find($choice)+1
		$plays += 1

	else($choice->size == 0)
		$controls

	else
		'Invalid Choice.'+ br + $controls
^}
if($win_record->size) => {^
	br
	br
	'Win record: '+br
	'Lasso: '+($win_record->find('lasso')->size)+br
	'User: '+($win_record->find('user')->size)+br
	'Tie: '+($win_record->find('tie')->size)+br
^}
