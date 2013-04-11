n = string(ceil(random(10)));
show_message("I'm thinking of a number from 1 to 10");
g = get_string("Please enter guess", "");
while(g != n){
    g=get_string("I'm sorry "+g+" is not my number, try again. Please enter guess", "");}
show_message("Correct! "+g+" was my number!");
exit
