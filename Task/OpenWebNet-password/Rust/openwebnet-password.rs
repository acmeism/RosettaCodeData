fn own_password_calculation(password: i64, nonce: &str) -> i64 {
    const M1: i64 = 0xFFFF_FFFF;
    const M8: i64 = 0xFFFF_FFF8;
    const M16: i64 = 0xFFFF_FFF0;
    const M128: i64 = 0xFFFF_FF80;
    const M16777216: i64 = 0xFF00_0000;

    let mut flag = true;
    let mut number1 = 0;
    let mut number2 = 0;

    for ch in nonce.chars() {
        number2 = number2 & M1;

        match ch {
            '1' => {
                if flag { number2 = password; }
                flag = false;
                number1 = number2 & M128;
                number1 = number1 >> 7;
                number2 = number2 << 25;
                number1 = number1 + number2;
            },

            '2' => {
                if flag { number2 = password; }
                flag = false;
                number1 = number2 & M16;
                number1 = number1 >> 4;
                number2 = number2 << 28;
                number1 = number1 + number2;
            },

            '3' => {
                if flag { number2 = password; }
                flag = false;
                number1 = number2 & M8;
                number1 = number1 >> 3;
                number2 = number2 << 29;
                number1 = number1 + number2;
            },

            '4' => {
                if flag { number2 = password; }
                flag = false;
                number1 = number2 << 1;
                number2 = number2 >> 31;
                number1 = number1 + number2;
            },

            '5' => {
                if flag { number2 = password; }
                flag = false;
                number1 = number2 << 5;
                number2 = number2 >> 27;
                number1 = number1 + number2;
            },

            '6' => {
                if flag { number2 = password; }
                flag = false;
                number1 = number2 << 12;
                number2 = number2 >> 20;
                number1 = number1 + number2;
            },

            '7' => {
                if flag { number2 = password; }
                flag = false;
                number1 = number2 & 0xFF00;
                number1 = number1 + ((number2 & 0xFF) << 24);
                number1 = number1 + ((number2 & 0xFF0000) >> 16);
                number2 = (number2 & M16777216) >> 8;
                number1 = number1 + number2;
            },

            '8' => {
                if flag { number2 = password; }
                flag = false;
                number1 = number2 & 0xFFFF;
                number1 = number1 << 16;
                number1 = number1 + (number2 >> 24);
                number2 = number2 & 0xFF0000;
                number2 = number2 >> 8;
                number1 = number1 + number2;
            },

            '9' => {
                if flag { number2 = password; }
                flag = false;
                number1 = !number2;
            },

            _ => {
                number1 = number2;
            },
        }
        number2 = number1;
    }

    return number1 & M1;
}

fn own_password_calculation_test(password: &str, nonce: &str, expected: i64) {
    let result = own_password_calculation(password.parse::<i64>().unwrap(), nonce);
    let message = format!("{}  {}  {}  {}", password, nonce, result, expected);
    println!("{}  {}", if result == expected { "PASS" } else { "FAIL" }, message);
}

fn main() {
    own_password_calculation_test("12345", "603356072", 25280520);
    own_password_calculation_test("12345", "410501656", 119537670);
}
