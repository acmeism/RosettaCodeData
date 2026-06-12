use std::fmt;

const GEO_BASE_32: &str = "0123456789bcdefghjkmnpqrstuvwxyz";

#[derive(Debug, Clone)]
struct Range {
    lower: f64,
    upper: f64,
}

impl Range {
    fn new(lower: f64, upper: f64) -> Self {
        Range { lower, upper }
    }
}

#[derive(Debug, Clone)]
struct Location {
    latitude: f64,
    longitude: f64,
}

impl Location {
    fn new(latitude: f64, longitude: f64) -> Self {
        Location { latitude, longitude }
    }
}

impl fmt::Display for Location {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let sector_sn = if self.latitude < 0.0 { " S" } else { " N" };
        let sector_we = if self.longitude < 0.0 { " W" } else { " E" };
        write!(f, "({}{}, {}{})", self.latitude, sector_sn, self.longitude, sector_we)
    }
}

fn encode_geohash(location: &Location, precision: u32) -> String {
    let mut latitude_range = Range::new(-90.0, 90.0);
    let mut longitude_range = Range::new(-180.0, 180.0);
    let mut geohash = String::new();
    let mut geohash_value = 0u32;
    let mut bit_count = 0u32;
    let mut even = true;

    while geohash.len() < precision as usize {
        let value = if even { location.longitude } else { location.latitude };
        let range = if even { &longitude_range } else { &latitude_range };
        let mid_range = (range.lower + range.upper) / 2.0;

        if value > mid_range {
            geohash_value = (geohash_value << 1) + 1;
            if even {
                longitude_range = Range::new(mid_range, longitude_range.upper);
            } else {
                latitude_range = Range::new(mid_range, latitude_range.upper);
            }
        } else {
            geohash_value <<= 1;
            if even {
                longitude_range = Range::new(longitude_range.lower, mid_range);
            } else {
                latitude_range = Range::new(latitude_range.lower, mid_range);
            }
        }

        even = !even;
        if bit_count < 4 {
            bit_count += 1;
        } else {
            bit_count = 0;
            if let Some(ch) = GEO_BASE_32.chars().nth(geohash_value as usize) {
                geohash.push(ch);
            }
            geohash_value = 0;
        }
    }
    geohash
}

fn decode_geohash(geohash: &str) -> String {
    let mut latitude_range = Range::new(-90.0, 90.0);
    let mut longitude_range = Range::new(-180.0, 180.0);
    let mut even = true;

    for ch in geohash.chars() {
        if let Some(position) = GEO_BASE_32.find(ch) {
            let binary = format!("{:05b}", position);

            for bit_char in binary.chars() {
                let mid_range = if even {
                    (longitude_range.lower + longitude_range.upper) / 2.0
                } else {
                    (latitude_range.lower + latitude_range.upper) / 2.0
                };

                if bit_char == '0' {
                    if even {
                        longitude_range = Range::new(longitude_range.lower, mid_range);
                    } else {
                        latitude_range = Range::new(latitude_range.lower, mid_range);
                    }
                } else {
                    if even {
                        longitude_range = Range::new(mid_range, longitude_range.upper);
                    } else {
                        latitude_range = Range::new(mid_range, latitude_range.upper);
                    }
                }
                even = !even;
            }
        }
    }

    let latitude_error = (latitude_range.lower - latitude_range.upper).abs();
    let longitude_error = (longitude_range.lower - longitude_range.upper).abs();
    let max_error = latitude_error.max(longitude_error);
    let mid_latitude = (latitude_range.lower + latitude_range.upper) / 2.0;
    let mid_longitude = (longitude_range.lower + longitude_range.upper) / 2.0;
    let sector_sn = if mid_latitude < 0.0 { " S" } else { " N" };
    let sector_we = if mid_longitude < 0.0 { " W" } else { " E" };

    format!("({:.15}{}, {:.15}{}) ± {:.15}",
            mid_latitude, sector_sn, mid_longitude, sector_we, max_error)
}

fn main() {
    let locations = vec![
        Location::new(51.433718, -0.214126),
        Location::new(51.433718, -0.214126),
        Location::new(57.64911, 10.40744),
        Location::new(57.64911, 10.40744),
    ];
    let precisions = vec![2, 9, 11, 21];

    let mut test_results = Vec::new();
    for (i, location) in locations.iter().enumerate() {
        let geohash = encode_geohash(location, precisions[i]);
        test_results.push(geohash.clone());
        println!("geohash for {} with precision {:2} => {}",
                 location, precisions[i], geohash);
    }
    println!();

    for test_result in &test_results {
        println!("{:<21} => {}", test_result, decode_geohash(test_result));
    }
}
