sub g { say Backtrace.new.concise }
sub f { g }
sub MAIN { f }
