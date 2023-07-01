import numpy as np
from PIL import Image
from scipy.spatial import KDTree

def generate_voronoi_diagram(X, Y, num_cells):
    # Random colors and points
    colors = np.random.randint((256, 256, 256), size=(num_cells, 3), dtype=np.uint8)
    points = np.random.randint((Y, X), size=(num_cells, 2))

    # Construct a list of all possible (y,x) coordinates
    idx = np.indices((Y, X))
    coords = np.moveaxis(idx, 0, -1).reshape((-1, 2))

    # Find the closest point to each coordinate
    _d, labels = KDTree(points).query(coords)
    labels = labels.reshape((Y, X))

    # Export an RGB image
    rgb = colors[labels]
    img = Image.fromarray(rgb, mode='RGB')
    img.save('VoronoiDiagram.png', 'PNG')
    img.show()
    return rgb
