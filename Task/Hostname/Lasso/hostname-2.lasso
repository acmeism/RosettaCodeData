define host_name => thread {

	data
		public initiated::date, // when the thread was initiated. Most likely at Lasso server startup
		private hostname::string // as reported by the servers hostname

	public onCreate() => {
		.reset
	}

	public reset() => {
		if(lasso_version(-lassoplatform) >> 'Win') => {
			protect => {
				local(process = sys_process('cmd',(:'hostname.exe')))
				#process -> wait
				.hostname = string(#process -> readstring) -> trim&
				#process -> close
			}
		else
			protect => {
				local(process = sys_process('/bin/hostname'))
				#process -> wait
				.hostname = string(#process -> readstring) -> trim&
				#process -> close
			}
		}
		.initiated = date(date -> format(`yyyyMMddHHmmss`)) // need to set format to get rid of nasty hidden fractions of seconds
		.hostname -> size == 0 ? .hostname = 'undefined'
	}

	public asString() => .hostname

}

host_name
