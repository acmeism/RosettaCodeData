BEGIN {
    do_task1()
    do_task2()
    do_task3()
    exit
}


function do_task1(){
    print "Task 1"
    v[1] = 2
    v[2] = -4
    for (n=3; n<=100; n++) v[n] = 111 - 1130 / v[n-1] + 3000 / (v[n-1] * v[n-2])

    for (i=3; i<=8; i++) print_results(i)
    print_results(20)
    print_results(30)
    print_results(50)
    print_results(100)
}

# This works because all awk variables are global, except when declared locally
function print_results(n){
    printf("n = %d\t%20.16f\n", n, v[n])
}

# This function doesn't need any parameters; declaring balance and i in the function parameters makes them local
function do_task2(      balance, i){
    balance[0] = exp(1)-1
    for (i=1; i<=25; i++) balance[i] = balance[i-1]*i-1
    printf("\nTask 2\nBalance after 25 years: $%12.10f", balance[25])
}

function do_task3(      a, b, f_ab){
    a = 77617
    b = 33096

    f_ab = 333.75 * b^6 + a^2 * (11*a^2*b^2 - b^6 - 121*b^4 - 2) + 5.5*b^8 + a/(2*b)
    printf("\nTask 3\nf(%6.12f, %6.12f) = %10.24f", a, b, f_ab)
}
