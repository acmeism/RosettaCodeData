const cities = {"Lagos": 21.0, "Cairo": 15.2, "Kinshasa-Brazzaville": 11.3, "Greater Johannesburg": 7.55, "Mogadishu": 5.85, "Khartoum-Omdurman": 4.98, "Dar Es Salaam": 4.7, "Alexandria": 4.58, "Abidjan": 4.4, "Casablanca": 3.98}	

fn main() {
	mut count := 0
	mut result :=""
	for city, population in cities {
		count++
		if city == "Dar Es Salaam" && !result.contains("Index") {
			result += "Index of '${city}': ${count - 1}\n"
		}
		if population < 5 && !result.contains("million") {
			result += "First city with less than 5 million: ${city}\n"
		}
		if city[0].ascii_str() == "A" && !result.contains("letter") {
			result += "First population that starts with letter 'A': ${population}\n"
		}
	}
	println(result.all_before_last("\n"))
}
