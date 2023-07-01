struct Point {
    lat: f64,
    lon: f64,
}

fn haversine(origin: Point, destination: Point) -> f64 {
    const R: f64 = 6372.8;

    let lat1 = origin.lat.to_radians();
    let lat2 = destination.lat.to_radians();
    let d_lat = lat2 - lat1;
    let d_lon = (destination.lon - origin.lon).to_radians();

    let a = (d_lat / 2.0).sin().powi(2) + (d_lon / 2.0).sin().powi(2) * lat1.cos() * lat2.cos();
    let c = 2.0 * a.sqrt().asin();
    R * c
}

#[cfg(test)]
mod test {
    use super::{Point, haversine};

    #[test]
    fn test_haversine() {
        let origin: Point = Point {
            lat: 36.12,
            lon: -86.67
        };
        let destination: Point = Point {
            lat: 33.94,
            lon: -118.4
        };
        let d: f64 = haversine(origin, destination);
        println!("Distance: {} km ({} mi)", d, d / 1.609344);
        assert_eq!(d, 2887.2599506071106);
    }

}
