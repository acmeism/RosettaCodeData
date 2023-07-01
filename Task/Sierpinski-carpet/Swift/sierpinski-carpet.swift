import Foundation
func sierpinski_carpet(n:Int) -> String {
    func middle(str:String) -> String {
        let spacer = str.stringByReplacingOccurrencesOfString("#", withString:" ", options:nil, range:nil)
        return str + spacer + str
    }

    var carpet = ["#"]
    for i in 1...n {
        let a = carpet.map{$0 + $0 + $0}
        let b = carpet.map(middle)
        carpet = a + b + a
    }
    return "\n".join(carpet)
}

println(sierpinski_carpet(3))
