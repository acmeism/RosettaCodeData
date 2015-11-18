| ?- logtalk << call([Z]>>(call([X,Y]>>(Y is X*X), 5, R), Z is R*R), T).
T = 625
yes
