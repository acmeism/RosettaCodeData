import math

# Constants
MAXN = 2500
EPS = 1e-8


class Vect:
    def __init__(self, x=0.0, y=0.0, z=0.0, id=0):
        self.x = x
        self.y = y
        self.z = z
        self.id = id

    def __sub__(self, other):
        return Vect(self.x - other.x, self.y - other.y, self.z - other.z)

    def __truediv__(self, other):
        return Vect(self.y * other.z - self.z * other.y,
                    self.z * other.x - self.x * other.z,
                    self.x * other.y - self.y * other.x)

    def __mul__(self, other):
        return self.x * other.x + self.y * other.y + self.z * other.z

    def m(self):
        return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z)

    def __eq__(self, other):
        return eq(self.x, other.x) and eq(self.y, other.y) and eq(self.z, other.z)

    def __repr__(self):
        return f"Vect({self.x}, {self.y}, {self.z}, {self.id})"


class Line:
    def __init__(self, u=None, v=None):
        self.u = u
        self.v = v


class Plane:
    def __init__(self, u=None, v=None, w=None):
        self.vec = [u, v, w] if u is not None and v is not None and w is not None else [None, None, None]

    def normal(self):
        return (self.vec[1] - self.vec[0]) / (self.vec[2] - self.vec[0])

    def u(self):
        return self.vec[0]


def gtr(a, b):
    return a - b > EPS


def eq(a, b):
    return -EPS < a - b < EPS


def Abs(x):
    return -x if gtr(0, x) else x


# Signed distance
def dist_point_plane(v, p):
    return (v - p.u()) * p.normal() / p.normal().m()


# Unsigned distance
def dist_point_line(v, f):
    return (((f.v - f.u) / (v - f.u)).m() / (f.v - f.u).m()) if (v - f.u).m() > 0 else 0


def dist_point_point(u, v):
    return (u - v).m()


def isabove(v, p):
    return gtr((v - p.u()) * p.normal(), 0)


# Convex Hull Structures
TIME = 0


class Facet:
    def __init__(self, id=0, p=None):
        # neighbor，correspond to point (u->v, v->w, w->u)
        self.n = [0, 0, 0]
        self.id = id
        # access timestamp
        self.vistime = 0
        self.isdel = False
        self.p = p if p is not None else Plane()

    def in_(self, n1, n2, n3):
        self.n = [n1, n2, n3]

    def __repr__(self):
        return f"Facet(id={self.id}, isdel={self.isdel}, vistime={self.vistime})"


# Edge of the horizon
class Edge:
    def __init__(self):
        self.netid = 0
        self.facetid = 0


# Store all faces
FAC = []


class ConvexHulls3d:
    def __init__(self, index):
        # Index face
        self.index = index
        self.surfacearea = 0.0

    def dfsArea(self, nf):
        global TIME, FAC
        # Already visited in current timestamp
        if FAC[nf].vistime == TIME:
            return
        FAC[nf].vistime = TIME
        if FAC[nf].p.normal() is not None:  # check if plane is initialized
            self.surfacearea += FAC[nf].p.normal().m() / 2
        for i in range(3):
            self.dfsArea(FAC[nf].n[i])

    def getSurfaceArea(self):
        global TIME, FAC
        if gtr(self.surfacearea, 0):
            return self.surfacearea
        TIME += 1
        self.dfsArea(self.index)
        return self.surfacearea

    def getHorizon(self, f, p, vistime, e1, e2, resfdel):
        global TIME, FAC
        if not isabove(p, FAC[f].p):
            return 0
        if FAC[f].vistime == TIME:
            return -1
        FAC[f].vistime = TIME
        # Mark the deleted face
        FAC[f].isdel = True
        resfdel.append(FAC[f].id)
        ret = -2
        for i in range(3):
            res = self.getHorizon(FAC[f].n[i], p, vistime, e1, e2, resfdel)
            if res == 0:
                pt = [FAC[f].p.vec[i].id, FAC[f].p.vec[(i + 1) % 3].id]
                for j in range(2):
                    if vistime[pt[j]] != TIME:
                        vistime[pt[j]] = TIME
                        e1[pt[j]].netid = pt[(j + 1) % 2]
                        e1[pt[j]].facetid = FAC[f].n[i]
                    else:
                        e2[pt[j]].netid = pt[(j + 1) % 2]
                        e2[pt[j]].facetid = FAC[f].n[i]
                ret = pt[0]
            elif res != -1 and res != -2:
                # The face is enclosed in the middle
                ret = res
        return ret


# Global Variables
# Global points
pts = []


# Construct initial simplex
def getStart(point, totp):
    global FAC, pts
    pt = [point[1]] * 6
    s = [point[1]] * 4

    # Find the maximum point of the coordinate axis
    for i in range(2, totp + 1):
        if gtr(point[i].x, pt[0].x):
            pt[0] = point[i]
        if gtr(pt[1].x, point[i].x):
            pt[1] = point[i]
        if gtr(point[i].y, pt[2].y):
            pt[2] = point[i]
        if gtr(pt[3].y, point[i].y):
            pt[3] = point[i]
        if gtr(point[i].z, pt[4].z):
            pt[4] = point[i]
        if gtr(pt[5].z, point[i].z):
            pt[5] = point[i]

    # Take the two points with the largest distance
    for i in range(6):
        for j in range(i + 1, 6):
            if gtr(dist_point_point(pt[i], pt[j]), dist_point_point(s[0], s[1])):
                s[0] = pt[i]
                s[1] = pt[j]

    # Take the point farthest from the line connecting the two points
    for i in range(6):
        if gtr(dist_point_line(pt[i], Line(s[0], s[1])), dist_point_line(s[2], Line(s[0], s[1]))):
            s[2] = pt[i]

    # Take the point farthest from the face
    for i in range(1, totp + 1):  # !!
        if gtr(Abs(dist_point_plane(point[i], Plane(s[0], s[1], s[2]))),
               Abs(dist_point_plane(s[3], Plane(s[0], s[1], s[2])))):
            s[3] = point[i]

    # Ensure that the constructed face faces outwards
    if gtr(0, dist_point_plane(s[3], Plane(s[0], s[1], s[2]))):
        s[1], s[2] = s[2], s[1]

    # Construct simplex
    f = [0] * 4
    for i in range(4):
        FAC.append(Facet(id=len(FAC)))
        f[i] = len(FAC) - 1

    FAC[f[0]].p = Plane(s[0], s[2], s[1])  # Bottom face
    FAC[f[1]].p = Plane(s[0], s[1], s[3])
    FAC[f[2]].p = Plane(s[1], s[2], s[3])
    FAC[f[3]].p = Plane(s[2], s[0], s[3])

    FAC[f[0]].in_(f[3], f[2], f[1])
    FAC[f[1]].in_(f[0], f[2], f[3])
    FAC[f[2]].in_(f[0], f[3], f[1])
    FAC[f[3]].in_(f[0], f[1], f[2])

    # Assign point set space to four faces
    for i in range(4):
        pts.append([])

    # Assign points to four faces
    for i in range(1, totp + 1):
        if point[i] == s[0] or point[i] == s[1] or point[i] == s[2] or point[i] == s[3]:
            continue
        for j in range(4):
            if isabove(point[i], FAC[f[j]].p):
                pts[f[j]].append(point[i])
                break

    # Return the initial simplex, using a face as index
    return ConvexHulls3d(f[0])


# Border line graph information
e = [[Edge() for _ in range(MAXN)] for _ in range(2)]
# Timestamp of each point access
vistime = [0] * MAXN
que = []
# Save the newly constructed face
resfnew = []
# Save the deleted face
resfdel = []
# Save the point to be allocated
respt = []


def quickHull3d(point, totp):
    global FAC, pts, TIME, e, vistime, que, resfnew, resfdel, respt
    hull = getStart(point, totp)
    # Add the face of initial simplex to queue
    que = [hull.index]
    for i in range(3):
        que.append(FAC[hull.index].n[i])
    # snew saves index face of the final convex hull
    snew = 0

    while que:
        nf = que.pop(0)
        # Skip if the current face has been deleted
        if FAC[nf].isdel:
            continue
        # Skip if no vertices are allocated to the current face
        if not pts[nf]:
            snew = nf
            continue

        # Find the farthest point from the face
        p = pts[nf][0]
        for i in range(1, len(pts[nf])):
            if gtr(dist_point_plane(pts[nf][i], FAC[nf].p), dist_point_plane(p, FAC[nf].p)):
                p = pts[nf][i]

        # Find the horizon
        TIME += 1
        resfdel = []
        # The current face must be deleted, so start dfs from current face
        s = hull.getHorizon(nf, p, vistime, e[0], e[1], resfdel)

        # Iterate over horizon(go around a circle), construct new face
        # When finding horizon, we can't know whether an edge is clockwise or counterclockwise, so it needs to be judged here
        resfnew = []
        TIME += 1
        from_ = 0  # The previous visited point
        lastf = 0  # The last created face
        fstf = 0  # The first created face
        while vistime[s] != TIME:
            # Record whether the current point has been visited with timestamp
            vistime[s] = TIME
            net = 0  # Next point
            f = 0  # The unseen face connected to the current edge on horizon
            fnew = 0  # New face

            # Make sure the traversal direction is correct
            if e[0][s].netid == from_:
                net = e[1][s].netid
                f = e[1][s].facetid
            else:
                net = e[0][s].netid
                f = e[0][s].facetid

            # Find the counterclockwise information of these two points on the adjacent face
            pt1 = -1
            pt2 = -1
            for i in range(3):
                if point[s] == FAC[f].p.vec[i]:
                    pt1 = i
                if point[net] == FAC[f].p.vec[i]:
                    pt2 = i

            # Make sure pt1->pt2 is arranged counterclockwise by adjacent face points
            if (pt1 + 1) % 3 != pt2:
                pt1, pt2 = pt2, pt1  # swap

            # The face constructed in this way faces outward
            FAC.append(Facet(id=len(FAC), p=Plane(FAC[f].p.vec[pt2], FAC[f].p.vec[pt1], p)))
            fnew = len(FAC) - 1
            pts.append([])
            resfnew.append(fnew)

            # Maintain adjacency information
            FAC[fnew].n[0] = f
            FAC[f].n[pt1] = fnew
            if lastf:
                # Can't determine whether to traverse clockwise or counterclockwise in advance
                # Maintain adjacency information between new faces
                if FAC[fnew].p.vec[1] == FAC[lastf].p.vec[0]:
                    FAC[fnew].n[1] = lastf
                    FAC[lastf].n[2] = fnew
                else:
                    FAC[fnew].n[2] = lastf
                    FAC[lastf].n[1] = fnew
            else:
                fstf = fnew  # No new face yet
            lastf = fnew
            from_ = s
            s = net

        # Give the new face head and tail maintenance critical information
        if FAC[fstf].p.vec[1] == FAC[lastf].p.vec[0]:
            FAC[fstf].n[1] = lastf
            FAC[lastf].n[2] = fstf
        else:
            FAC[fstf].n[2] = lastf
            FAC[lastf].n[1] = fstf

        # Get all the points to be assigned
        respt = []
        for i in range(len(resfdel)):
            for j in range(len(pts[resfdel[i]])):
                respt.append(pts[resfdel[i]][j])
            pts[resfdel[i]] = []

        # Assign points
        for i in range(len(respt)):
            if respt[i] == p:
                continue  # Skip the points used to create the new face
            for j in range(len(resfnew)):
                if isabove(respt[i], FAC[resfnew[j]].p):
                    pts[resfnew[j]].append(respt[i])
                    break  # Make sure the points are not reassigned

        # Add the new face to queue
        for i in range(len(resfnew)):
            que.append(resfnew[i])
    hull.index = snew
    return hull


def preConvexHulls():
    global pts, FAC
    # 0 for reservation
    pts.append([])
    FAC.append(Facet())


if __name__ == "__main__":
    preConvexHulls()
    n = 4 # number of points
    point = [None] * (n + 1)  # 1-indexed to match original code
    my_input=[[0.0,0.0,0.0], [1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0] ]

    for i in range(1, n + 1):
        x, y, z = my_input[i-1]
        point[i] = Vect(x, y, z, id=i)
    hull = quickHull3d(point, n)
    print(f"{hull.getSurfaceArea():.3f}")
