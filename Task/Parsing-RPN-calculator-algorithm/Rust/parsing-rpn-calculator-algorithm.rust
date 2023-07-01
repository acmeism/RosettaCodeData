fn rpn(text: &str) -> f64 {
    let tokens = text.split_whitespace();
    let mut stack: Vec<f64> = vec![];
    println!("input operation stack");

    for token in tokens {
        print!("{:^5} ", token);
        match token.parse() {
            Ok(num) => {
                stack.push(num);
                println!("push      {:?}", stack);
            }
            Err(_) => {
                match token {
                    "+" => {
                        let b = stack.pop().expect("missing first operand");
                        let a = stack.pop().expect("missing second operand");
                        stack.push(a + b);
                    }
                    "-" => {
                        let b = stack.pop().expect("missing first operand");
                        let a = stack.pop().expect("missing second operand");
                        stack.push(a - b);
                    }
                    "*" => {
                        let b = stack.pop().expect("missing first operand");
                        let a = stack.pop().expect("missing second operand");
                        stack.push(a * b);
                    }
                    "/" => {
                        let b = stack.pop().expect("missing first operand");
                        let a = stack.pop().expect("missing second operand");
                        stack.push(a / b);
                    }
                    "^" => {
                        let b = stack.pop().expect("missing first operand");
                        let a = stack.pop().expect("missing second operand");
                        stack.push(a.powf(b));
                    }
                    _ => panic!("unknown operator {}", token),
                }
                println!("calculate {:?}", stack);
            }
        }
    }

    stack.pop().unwrap_or(0.0)
}

fn main() {
    let text = "3 4 2 * 1 5 - 2 3 ^ ^ / +";

    println!("\nresult: {}", rpn(text));
}
