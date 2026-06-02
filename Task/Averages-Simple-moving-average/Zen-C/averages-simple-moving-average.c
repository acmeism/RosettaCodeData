import "std/vec.zc"

alias clos = fn(f64) -> f64;

fn sma(period: usize) -> clos {
    let storage = Vec<f64>::new();
    let i = 0;
    let sum = 0.0;
    return fn[=](input: f64) -> f64 {
        if storage.length() < period {
            sum += input;
            storage << input;
        }
        sum += input - storage[i];
        storage[i] = input;
        i = (i + 1) % period;
        return sum / storage.length();
    }
}

fn main() {
    let sma3 = sma(3);
    let sma5 = sma(5);
    println "  x     sma3   sma5";
    let a: f64[10] = [1.0, 2.0, 3.0, 4.0, 5.0, 5.0, 4.0, 3.0, 2.0, 1.0];
    for i in 0..10 {
        let x = a[i];
        printf("%5.2f  %5.2f  %5.2f\n", x, sma3(x), sma5(x));
    }
}
