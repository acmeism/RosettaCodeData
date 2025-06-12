use std::io::{self,BufRead};
extern crate rand;
use rand::Rng;

fn op_type(x: char) -> i32{
    match x {
        '-' | '+' => return 1,
        '/' | '*' => return 2,
        '(' | ')' => return -1,
        _   => return 0,
    }
}

fn to_rpn(input: &mut String){

    let mut rpn_string : String = String::new();
    let mut rpn_stack : String = String::new();
    let mut last_token = '#';
    for token in input.chars(){
        if token.is_digit(10) {
            rpn_string.push(token);
        }
        else if op_type(token) == 0 {
            continue;
        }
        else if op_type(token) > op_type(last_token) || token == '(' {
                rpn_stack.push(token);
                last_token=token;
        }
        else {
            while let Some(top) = rpn_stack.pop() {
                if top=='(' {
                    break;
                }
                rpn_string.push(top);
            }
            if token != ')'{
                rpn_stack.push(token);
            }
        }
    }
    while let Some(top) = rpn_stack.pop() {
        rpn_string.push(top);
    }

    println!("you formula results in {}", rpn_string);

    *input=rpn_string;
}

fn calculate(input: &String, list : &mut [u32;4]) -> f32{
    let mut stack : Vec<f32> = Vec::new();
    let mut accumulator : f32 = 0.0;

    for token in input.chars(){
        if token.is_digit(10) {
            let test = token.to_digit(10).unwrap() as u32;
            match list.iter().position(|&x| x == test){
                Some(idx) => list[idx]=10 ,
                _         => println!(" invalid digit: {} ",test),
            }
            stack.push(accumulator);
            accumulator = test as f32;
        }else{
            let a = stack.pop().unwrap();
            accumulator = match token {
                '-' => a-accumulator,
                '+' => a+accumulator,
                '/' => a/accumulator,
                '*' => a*accumulator,
                _ => {accumulator},//NOP
            };
        }
    }
    println!("you formula results in {}",accumulator);
    accumulator
}

fn main() {

    let mut rng = rand::thread_rng();
    // each from 1 ──► 9 (inclusive)
    let mut list :[u32;4]=[
        rng.gen::<u32>()%9+1,
        rng.gen::<u32>()%9+1,
        rng.gen::<u32>()%9+1,
        rng.gen::<u32>()%9+1
    ];

    println!("form 24 with using + - / * {:?}",list);
    //get user input
    let mut input = String::new();
    io::stdin().read_line(&mut input).unwrap();
    //convert to rpn
    to_rpn(&mut input);
    let result = calculate(&input, &mut list);

    if list.iter().any(|&list| list !=10){
        println!("and you used all numbers");
        match result {
            24.0 => println!("you won"),
            _ => println!("but your formulla doesn't result in 24"),
        }
    }else{
        println!("you didn't use all the numbers");
    }

}
