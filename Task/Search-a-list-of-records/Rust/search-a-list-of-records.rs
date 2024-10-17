struct City {
    name: &'static str,
    population: f64,
}

fn main() {
    let cities = [
        City {
            name: "Lagos",
            population: 21.0,
        },
        City {
            name: "Cairo",
            population: 15.2,
        },
        City {
            name: "Kinshasa-Brazzaville",
            population: 11.3,
        },
        City {
            name: "Greater Johannesburg",
            population: 7.55,
        },
        City {
            name: "Mogadishu",
            population: 5.85,
        },
        City {
            name: "Khartoum-Omdurman",
            population: 4.98,
        },
        City {
            name: "Dar Es Salaam",
            population: 4.7,
        },
        City {
            name: "Alexandria",
            population: 4.58,
        },
        City {
            name: "Abidjan",
            population: 4.4,
        },
        City {
            name: "Casablanca",
            population: 3.98,
        },
    ];

    println!(
        "{:?}",
        cities.iter().position(|city| city.name == "Dar Es Salaam")
    );
    println!(
        "{:?}",
        cities
            .iter()
            .find(|city| city.population < 5.0)
            .map(|city| city.name)
    );
    println!(
        "{:?}",
        cities
            .iter()
            .find(|city| city.name.starts_with('A'))
            .map(|city| city.population)
    );
}
