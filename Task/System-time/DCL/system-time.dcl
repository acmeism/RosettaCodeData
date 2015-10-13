$ start_time = f$time()
$ wait 0::10
$ end_time = f$time()
$ write sys$output "start time was ", start_time
$ write sys$output "end time was   ", end_time
$ write sys$output "delta time is         ", f$delta_time( start_time, end_time )
