loop(100) => {^
	local(root = math_sqrt(loop_count))
	local(state = (#root == math_ceil(#root) ? '<strong>open</strong>' | 'closed'))
	#state != 'closed' ? 'Door ' + loop_count + ': ' + #state + '<br>'
^}
