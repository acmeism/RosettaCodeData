main(){
    print(multiply(1,2));
    print(multiply2(1,2));
    print(multiply3(1,2));
}

// the following definitions are equivalent
// arrow syntax without type annotations
multiply(num1, num2) => num1 * num2;

// arrow syntax with type annotations
int multiply2(int num1, int num2) => num1 * num2;

// c style with curly braces
int multiply3(int num1, int num2){
    return num1 * num2;
}
