sub twice(&todo) {
   todo(); todo(); # declaring &todo also defines bare function
}
twice { say "Boing!" }
# output:
# Boing!
# Boing!

sub twice-with-param(&todo) {
    todo(0); todo(1);
}
twice-with-param -> $time {
   say "{$time+1}: Hello!"
}
# output:
# 1: Hello!
# 2: Hello!
