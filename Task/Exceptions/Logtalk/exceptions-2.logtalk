| ?- exceptions::double(1, Double).
Double = 2
yes

| ?- exceptions::double("1", Double).
Double = 2
yes

| ?- exceptions::double(a, Double).
uncaught exception: error(not_a_number(a),logtalk(exceptions::double(a,_),user))
