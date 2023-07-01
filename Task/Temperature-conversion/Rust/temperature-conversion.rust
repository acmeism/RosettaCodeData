fn main() -> std::io::Result<()> {
    print!("Enter temperature in Kelvin to convert: ");
    let mut input = String::new();
    std::io::stdin().read_line(&mut input)?;
    match input.trim().parse::<f32>() {
        Ok(kelvin) => {
            if kelvin < 0.0 {
                println!("Negative Kelvin values are not acceptable.");
            } else {
                println!("{} K", kelvin);
                println!("{} °C", kelvin - 273.15);
                println!("{} °F", kelvin * 1.8 - 459.67);
                println!("{} °R", kelvin * 1.8);
            }
        }

        _ => println!("Could not parse the input to a number."),
    }

    Ok(())
}
