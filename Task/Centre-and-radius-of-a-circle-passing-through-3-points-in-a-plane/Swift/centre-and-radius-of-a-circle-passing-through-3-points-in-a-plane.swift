import Foundation
import Matrix

extension Matrix where Element: SignedNumeric {
	func minor(row: Int, column: Int) -> Element {
		var submatrix = self
		_ = submatrix.remove(rowAt: row - 1)
		_ = submatrix.remove(columnAt: column - 1)
		return submatrix.determinant as Element
	}
}

enum MatrixErrors: Error {
	case notEnoughPoints, tooManyPoints, pointsOnALine, miscError
}

func circleFrom3Points(points: (Double,Double)... ) throws -> (Double,Double,Double){
	var pointArray: [[Double]] = [[0,0,0,0]]
	for p in points {
		pointArray.append([pow(p.0, 2) + pow(p.1, 2), p.0, p.1, 1])
	}
	guard pointArray.count > 3 else { throw MatrixErrors.notEnoughPoints }
	guard pointArray.count < 5 else { throw MatrixErrors.tooManyPoints }
	var matrix = Matrix(elements:pointArray)
	var m11 = matrix.minor(row: 1, column: 1)
	guard m11 != 0 else { throw MatrixErrors.pointsOnALine }
	var m12 = matrix.minor(row: 1, column: 2)
	var m13 = matrix.minor(row: 1, column: 3)

	let x =  0.5 * m12 / m11
	let y = -0.5 * m13 / m11
	let r = (pow(x - pointArray[1][1],2) + pow(y - pointArray[1][2],2)).squareRoot()
	return (x,y,r)
}

do {
	let (x,y,r) = try circleFrom3Points(points:  (22.83,2.07), (14.39,30.24), (33.65,17.31))
	print("x:\(x), y:\(y), r: \(r)")
} catch {
	debugPrint(error)
	exit(1)
}
