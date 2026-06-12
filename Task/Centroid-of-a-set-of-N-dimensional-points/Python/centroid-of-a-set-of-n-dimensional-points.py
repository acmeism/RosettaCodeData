from typing import List

def centroid(points: List[List[float]]) -> List[float]:
    """
    Calculate the centroid (geometric center) of a set of points in n-dimensional space.

    Args:
        points: A list of points, where each point is a list of float coordinates.
                All points must have the same dimensionality.

    Returns:
        A list representing the centroid point coordinates.

    Raises:
        ValueError: If the input list is empty or if points have inconsistent dimensions.
    """
    # Check if the input list is empty
    if not points:
        raise ValueError("List must contain at least one point")

    # Determine the number of dimensions
    dimension = len(points[0])
    if not all(len(l) == dimension for l in points):
        raise ValueError("Points must all have the same dimension")

    result = [0.0] * dimension  # Initialise centroid coordinates with zeros
    for i in range(dimension):
        for j in range(len(points)):
            result[i] += points[j][i]  # Sum up corresponding coordinates
        result[i] /= len(points)  # Compute the average for each coordinate

    return result

points: List[List[List[float]]] = [
    [[1.0], [2.0], [3.0]],
    [[8.0, 2.0], [0.0, 0.0]],
    [[5.0, 5.0, 0.0], [10.0, 10.0, 0.0]],
    [[1.0, 3.1, 6.5], [-2.0, -5.0, 3.4], [-7.0, -4.0, 9.0], [2.0, 0.0, 3.0]],
    [[0.0, 0.0, 0.0, 0.0, 1.0], [0.0, 0.0, 0.0, 1.0, 0.0], [0.0, 0.0, 1.0, 0.0, 0.0], [0.0, 1.0, 0.0, 0.0, 0.0]],
]

for point in points:
    print(f"\nSet: {point}\nCentroid: {centroid(point)}")
