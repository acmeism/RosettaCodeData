import Foundation

func haversine(lat1:Double, lon1:Double, lat2:Double, lon2:Double) -> Double {
    let lat1rad = lat1 * Double.pi/180
    let lon1rad = lon1 * Double.pi/180
    let lat2rad = lat2 * Double.pi/180
    let lon2rad = lon2 * Double.pi/180

    let dLat = lat2rad - lat1rad
    let dLon = lon2rad - lon1rad
    let a = sin(dLat/2) * sin(dLat/2) + sin(dLon/2) * sin(dLon/2) * cos(lat1rad) * cos(lat2rad)
    let c = 2 * asin(sqrt(a))
    let R = 6372.8

    return R * c
}

print(haversine(lat1:36.12, lon1:-86.67, lat2:33.94, lon2:-118.40))
