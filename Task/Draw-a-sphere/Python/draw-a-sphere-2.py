import pygame
from pygame.locals import *
import time
import sys
import random
import math
class Tricubic:
    def __init__(self,pts):
        self.coefficients = []
        for plane in pts:
            planecoeffs = []
            for line in plane:
                p = (line[3]-line[2])-(line[0]-line[1])
                q = (line[0]-line[1])-p
                r = line[2]-line[0]
                s = line[1]
                planecoeffs.append([p,q,r,s])
            self.coefficients.append(planecoeff)
    def Eval(at):
        return Misc.Cubic([CoeffBicubic(coeffs[0],d),CoeffBicubic(coeffs[1],d),CoeffBicubic(coeffs[2],d),CoeffBicubic(coeffs[3],d)],d.z)
    def CoeffCubic(coeffs,d):
        return (coeffs[0]*(d.x**3))+(coeffs[1]*(d.x**2))+(coeffs[2]*d.x)+coeffs[3]
    def CoeffBicubic(coeffs,d):
        return Misc.Cubic([CoeffCubic(coeffs[0],d),CoeffCubic(coeffs[1],d),CoeffCubic(coeffs[2],d),CoeffCubic(coeffs[3],d)],d.y)
class Misc:
    def LinePara(line,t):
        return Vector3.Add(line[0],Vector3.Scale(Vector3.Subtract(line[1],line[0]),t))
    def LUR(at,above):
        look = at.Unit()
        right = Vector3.Cross(look,above).Unit()
        up = Vector3.Scale(Vector3.Cross(look,right),-1)
        return [look,up,right]
    def LinePlane(line,triangle,cp=True):
        try:
            u = Vector3.Subtract(triangle.points[1].point,triangle.points[0])
            v = Vector3.Subtract(triangle.points[2],triangle.points[0])
            n = Vector3.Cross(u,v)
            r = (Vector3.Dot(n,Vector3.Subtract(triangle.points[0],line.start))/Vector3.Dot(n,line.direction))
            if stp:
                point = Vector3.Add(Vector3.Scale(line.direction,r),line.start)
                w = Vector3.Subtract(point,triangle.points[0])
                udv = Vector3.Dot(u,v)
                wdv = Vector3.Dot(w,v)
                vdv = Vector3.Dot(v,v)
                wdu = Vector3.Dot(w,u)
                udu = Vector3.Dot(u,u)
                denominator = (udv**2)-(udu*vdv)
                s = ((udv*wdv)-(vdv*wdu))/denominator
                t = ((udv*wdu)-(udu*wdv))/denominator
                return [r,Vector2(s,t),point]
                print('hooray')
            else:
                return [r]
        except:
            return None
    def Cubic(pts,d):
        p = (pts[3]-pts[2])-(pts[0]-pts[1])
        q = (pts[0]-pts[1])-p
        r = pts[2]-pts[0]
        s = pts[1]
        return (p*(d**3))+(q*(d**2))+(r*d)+s
    def Bicubic(pts,d):
        return Misc.Cubic([Misc.Cubic(pts[0],d.x),Misc.Cubic(pts[1],d.x),Misc.Cubic(pts[2],d.x),Misc.Cubic(pts[3],d.x)],d.y)
    def Tricubic(pts,d):
        return Misc.Cubic([Misc.Bicubic(pts[0],d),Misc.Bicubic(pts[1],d),Misc.Bicubic(pts[2],d),Misc.Bicubic(pts[3],d)],d.z)
    def Quadcubic(pts,d):
        return Misc.Cubic([Misc.Tricubic(pts[0],d),Misc.Tricubic(pts[1],d),Misc.Tricubic(pts[2],d),Misc.Tricubic(pts[3],d)],d.w)
    def Linear(pts,d):
        return (pts[2]*d)+(pts[1]*(1-d))
    def Bilinear(pts,d):
        return Misc.Linear([0,Misc.Linear(pts[1],d.x),Misc.Linear(pts[2],d.x)],d.y)
    def Trilinear(pts,d):
        return Misc.Linear([0,Misc.Bilinear(pts[1],d),Misc.Bilinear(pts[2],d)],d.z)
    def LP2(line,triangle,cp=True):
        try:
            bla = triangle.points[1]
            bla = triangle.points[0]
            u = Vector3.Subtract(triangle.points[1].point,triangle.points[0].point)
            v = Vector3.Subtract(triangle.points[2].point,triangle.points[0].point)
            n = Vector3.Cross(u,v)
            d = Vector3.Subtract(line[1],line[0])
            r = (Vector3.Dot(n,Vector3.Subtract(triangle.points[0].point,line[0]))/Vector3.Dot(n,d))
            if cp:
                point = Vector3.Add(Vector3.Scale(d,r),line[0])
                w = Vector3.Subtract(point,triangle.points[0].point)
                udv = Vector3.Dot(u,v)
                wdv = Vector3.Dot(w,v)
                vdv = Vector3.Dot(v,v)
                wdu = Vector3.Dot(w,u)
                udu = Vector3.Dot(u,u)
                denominator = (udv**2)-(udu*vdv)
                s = ((udv*wdv)-(vdv*wdu))/denominator
                t = ((udv*wdu)-(udu*wdv))/denominator
                return (r,Vector2(s,t),point)
            else:
                return (r)
        except:
            return None
    def Phong(normal,viewer,light,material,term):
        # light (vector_to,diffuse,specular)
        # material (ambient,diffuse,specular,shininess)
        n = normal.Unit()
        v = viewer.Unit()
        l = light[0].Unit()
        ldn = Vector3.Dot(l,n)
        #print(ldn)
        val = 0
        if ldn > 0:
            val += material[1][term]*ldn*light[1][term]
            rdv = Vector3.Dot(Vector3.Subtract(Vector3.Scale(n,2*ldn),l),v)
            if rdv > 0:
                val += (material[2][term]*(rdv**material[3])*light[2][term])
        #print(val)
        return val
    def Lighting(ambient,normal,viewer,lights,material,term):
        # lights [(vector_to,diffuse,specular)]
        # material (ambient,diffuse,specular,shininess)
        val = material[0][term]*ambient[term]
        for light in lights:
            val += Misc.Phong(normal,viewer,light,material,term)
        return val
    def Lighting2(start,direction,ambient,intersect,triangle,lights):
        coord = intersect[1]
        val = Color.Add(Color.Multiply(ambient,Color.Multiply(triangle.material.color['ambient'],triangle.Map('ambient',coord))),
                        Color.Multiply(triangle.material.color['glow'],triangle.Map('glow',coord)))
        for light in lights:
            for n in range(3):
                val[n] += Misc.Phong(triangle.InterpolatedNormal(coord),
                                     Vector3.Scale(direction,-1),
                                     (light.To(intersect[2]),light.Diffuse(intersect[2]),light.Specular(intersect[2])),
                                     (Color(),
                                      Color.Multiply(triangle.material.color['diffuse'],triangle.Map('diffuse',coord)),
                                      Color.Multiply(triangle.material.color['specular'],triangle.Map('specular',coord)),
                                      triangle.material.shiny),n)
        return val
    def Ray(start,direction,scene,color=True,sector=None):
        intersect = None
        intersected = None
        col = None
        for triangle in scene.triangles:
            possible = True
            if sector != None:
                possible = False
                for point in triangle.points:
                    if not(point.sector.x < sector.x):
                        possible = True
                if possible:
                    possible = False
                    for point in triangle.points:
                        if not(point.sector.x > sector.x):
                            possible = True
                if possible:
                    possible = False
                    for point in triangle.points:
                        if not(point.sector.y < sector.y):
                            possible = True
                if possible:
                    possible = False
                    for point in triangle.points:
                        if not(point.sector.y > sector.y):
                            possible = True
            possible = True
            if possible:
                tmp = Misc.LP2([start,Vector3.Add(start,direction)],triangle,color)
                write = False
                if type(tmp) == type(5.1):
                    tmp = None
                if (tmp != None):
                    if (intersect == None):
                        if (tmp[0] > 0) and (tmp[1].x >= 0) and (tmp[1].y >= 0) and (tmp[1].x+tmp[1].y <= 1):
                            write = True
                    elif (tmp[0] > 0) and (tmp[0] < intersect[0]) and (tmp[1].x >= 0) and (tmp[1].y >= 0) and (tmp[1].x+tmp[1].y <= 1):
                        write = True
                if write:
                    intersect = tmp
                    intersected = triangle
        if color and (intersect != None):
            applicable = []
            for light in scene.lights:
                block = Misc.Ray(intersect[2],light.To(intersect[2]),scene,False)
                if block == None:
                    applicable.append(light)
                elif light.location != None:
                    if Vector3.Subtract(light.location,intersect[2]).Magnitude() < block[0]:
                        applicable.append(light)
            col = Misc.Lighting2(start,direction,scene.ambient,intersect,intersected,applicable)
            return (intersect,col)
        else:
            return intersect
class DirLight:
    def __init__(self,direction,diffuse,specular):
        self.location = None
        self.direction = direction.Unit()
        self.diffuse = diffuse
        self.specular = specular
    def To(self,frm):
        return Vector3.Scale(self.direction,-1)
    def Diffuse(self,to):
        return self.diffuse
    def Specular(self,to):
        return self.specular
class Material:
    def __init__(self):
        self.color = {'ambient':Color(1,1,1),
                      'diffuse':Color(1,1,1),
                      'specular':Color(1,1,1),
                      'glow':Color(1,1,1)}
        self.maps = {'ambient':Map(),
                     'diffuse':Map(),
                     'specular':Map(),
                     'glow':Map(),
                     'bump':Map()}
        self.shiny = 10
class Map:
    def __init__(self,surface=None):
        self.surface = surface
        if self.surface != None:
            self.width = self.surface.get_width()
            self.height = self.surface.get_height()
    def __getitem__(self,index):
        if self.surface == None:
            return Color(1,1,1)
        else:
            try:
                return Color.From255(self.surface.get_at((int(index.x*(self.width-1)),int(index.y*(self.height-1)))))
            except:
                return Color(0,0,1)
class Color:
    def __init__(self,r=0,g=0,b=0):
        self.r = r
        self.g = g
        self.b = b
    def __getitem__(self,index):
        if index == 0:
            return self.r
        elif index == 1:
            return self.g
        elif index == 2:
            return self.b
    def __setitem__(self,index,value):
        if index == 0:
            self.r = value
        elif index == 1:
            self.g = value
        elif index == 2:
            self.b = value
    def Multiply(A,B):
        return Color(A.r*B.r,A.g*B.g,A.b*B.b)
    def Add(A,B):
        return Color(A.r+B.r,A.g+B.g,A.b+B.b)
    def From255(A):
        return Color(A.r/255,A.g/255,A.b/255)
class Vertex:
    def __init__(self,point,normal,maps):
        self.bpoint = point
        self.bnormal = normal
        self.maps = maps
        for name in ['ambient','diffuse','specular','glow','bump']:
            try:
                bla = self.maps[name]
            except:
                self.maps[name] = Vector2()
        self.sector = None
    def Transform(self,points,norms):
        self.point = Matrix2.Multiply(self.bpoint.Horizontal(),points).Vectorize()
        self.normal = Matrix2.Multiply(self.bnormal.Horizontal(),norms).Vectorize()
class Triangle:
    def __init__(self,vertices,material=Material()):
        self.points = vertices
        self.material = material
    def Map(self,name,coord):
        pts = []
        for n in range(3):
            pts.append(self.points[n].maps[name])
        loc = Vector2.Add(pts[0],
                          Vector2.Add(Vector2.Scale(Vector2.Subtract(pts[1],pts[0]),coord.x),
                                      Vector2.Scale(Vector2.Subtract(pts[2],pts[0]),coord.y)))
        #print(loc.x,loc.y)
        return self.material.maps[name][loc]
    def InterpolatedNormal(self,coord):
        return Vector3.Add(Vector3.Scale(self.points[0].normal,1-coord.x-coord.y),
                           Vector3.Add(Vector3.Scale(self.points[1].normal,coord.x),Vector3.Scale(self.points[2].normal,coord.y))).Unit()
class Line:
    def __init__(self,A,B=None,direction=None):
        self.start = A
        if B != None:
            self.direction = Vector3.Subtract(B,A).Unit()
        elif direction != None:
            self.direction = direction
        else:
            raise RuntimeError('Neither B nor direction are specified')
class Scene:
    def __init__(self):
        self.triangles = []
        self.vertices = []
        self.lights = []
        self.exterior = []
        self.ambient = 0
class Matrix2:
    def __init__(self,data=[[]]):
        self.FromData(data)
    def __getitem__(self,index):
        return self.data[index[1]][index[0]]
    def __setitem__(self,index,value):
        self.data[index[1]][index[0]]=value
    def Dimension(self):
        self.rows = len(self.data)
        self.cols = len(self.data[0])
    def FromData(self,data):
        self.data = data
        length=len(data[0])
        for row in data:
            if len(row)!=length:
                self.data=None
                raise RuntimeError('Data rows are not of uniform length.')
        self.Dimension()
    def Multiply(A,B):
        if A.cols!=B.rows:
            raise RuntimeError('Column count of Matrix2 \"A\" does not match row count of Matrix2 \"B\".')
        matrix = Matrix2.Empty(B.cols,A.rows)
        x=0
        while x<matrix.cols:
            y=0
            while y<matrix.rows:
                val=0
                n=0
                while n<A.cols:
                    val+=A[(n,y)]*B[(x,n)]
                    n+=1
                matrix[(x,y)]=val
                y+=1
            x+=1
        return matrix
    def Scalar(A,n):
        pass
    def Empty(rows,cols):
        data = []
        row = [0]*rows
        n = 0
        while n < cols:
            data.append(row[:])
            n+=1
        matrix=Matrix2(data)
        matrix.Dimension()
        return matrix
    def Identity(cols):
        matrix = Matrix2.Empty(cols,cols)
        n = 0
        while n < cols:
            matrix[(n,n)]=1
            n += 1
        return matrix
    def Vectorize(self):
        if self.cols==1:
            if self.rows!=4:
                raise RuntimeError('Only 1 by 4 or 4 by 1 Matrix2s can be cast to Vector3s.')
            vertical=True
        elif self.rows==1:
            if self.cols!=4:
                raise RuntimeError('Only 1 by 4 or 4 by 1 Matrix2s can be cast to Vector3s.')
            vertical = False
        else:
            raise RuntimeError('Only 1 by 4 or 4 by 1 Matrix2s can be cast to Vector3s.')
        vector=[0]*4
        n=0
        while n<4:
            if vertical:
                vector[n]=self[(0,n)]
            else:
                vector[n]=self[(n,0)]
            n+=1
        return Vector3(vector[0],vector[1],vector[2],vector[3])
    def Print(self,decimals,spaces):
        length=0
        for row in self.data:
            for val in row:
                string=str(round(val,decimals))
                if length<len(string):
                    length=len(string)
        text=''
        for row in self.data:
            temp=''
            for value in row:
                val=str(round(float(value),decimals))
                pads=length-len(val)
                pad=int(pads/2)
                temp+=(' '*pad)+val+(' '*(pads-pad))+(' '*spaces)
            text+=(' '*spaces)+temp[0:len(temp)-1]+(' '*spaces)+'\n'
        return(text[0:len(text)-1])
    def RotX(angle):
        return Matrix2([
            [1,0,0,0],
            [0,math.cos(angle),0-math.sin(angle),0],
            [0,math.sin(angle),math.cos(angle),0],
            [0,0,0,1]])
    def RotY(angle):
        return Matrix2([
            [math.cos(angle),0,0-math.sin(angle),0],
            [0,1,0,0],
            [math.sin(angle),0,math.cos(angle),0],
            [0,0,0,1]])
    def RotZ(angle):
        return Matrix2([
            [math.cos(angle),0-math.sin(angle),0,0],
            [math.sin(angle),math.cos(angle),0,0],
            [0,0,1,0],
            [0,0,0,1]])
    def Translate(vector):
        return Matrix2([
            [1,0,0,0],
            [0,1,0,0],
            [0,0,1,0],
            [vector.x,vector.y,vector.z,1]])
    def Scale(vector):
        return Matrix2([
            [vector.x,0,0,0],
            [0,vector.y,0,0],
            [0,0,vector.z,0],
            [0,0,0,1]])
    def Clone(self):
        data = []
        for row in self.data:
            data.append(row[:])
        return Matrix2(data)
    def Inverse(self):
        adjoint = self.Adjoint()
        det = self.Determinant()
        if det == 0:
            raise RuntimeError('Cannot find the inverse of a matrix with a determinant of 0')
        inverse = Matrix2.Empty(self.rows,self.cols)
        x = 0
        while x < self.cols:
            y = 0
            while y < self.rows:
                inverse[(x,y)] = adjoint[(x,y)]/det
                y += 1
            x += 1
        return inverse
    def Transpose(self):
        transpose = Matrix2.Empty(self.cols,self.rows)
        x = 0
        while x < self.cols:
            y = 0
            while y < self.rows:
                transpose[(y,x)] = self[(x,y)]
                y += 1
            x += 1
        return transpose
    def Adjoint(self):
        return self.Cofactors().Transpose()
    def Determinant(self):
        if self.rows != self.cols:
            raise RuntimeError('Cannot find the determinant of a non-square matrix')
        if self.rows == 1:
            return self[(0,0)]
        cofactors = self.Cofactors()
        determinant = 0
        n = 0
        while n < self.cols:
            determinant += self[(n,0)]*cofactors[(n,0)]
            n += 1
        return determinant
    def Minors(self):
        if self.rows != self.cols:
            raise RuntimeError('Cannot find the minors of a non-square matrix')
        if self.rows == 1:
            raise RuntimeError('Cannot find the minors of a 1 by 1 matrix')
        minors = Matrix2.Empty(self.rows,self.cols)
        lines = range(self.rows)
        x = 0
        while x < self.cols:
            y = 0
            while y < self.cols:
                tiny = Matrix2.Empty(self.rows-1,self.cols-1)
                ox = 0
                nx = 0
                while ox < self.cols:
                    oy = 0
                    ny = 0
                    while oy < self.cols:
                        if not((ox == x) or (oy == y)):
                            tiny[(nx,ny)] = self[(ox,oy)]
                        if oy != y:
                            ny += 1
                        oy += 1
                    if ox != x:
                        nx += 1
                    ox += 1
                minors[(x,y)] = tiny.Determinant()
                y += 1
            x += 1
        return minors
    def Cofactors(self):
        minors = self.Minors()
        cofactors = Matrix2.Empty(self.rows,self.cols)
        x = 0
        while x < self.cols:
            y = 0
            while y < self.rows:
                if int((x+y)/2) == ((x+y)/2):
                    cofactors[(x,y)] = minors[(x,y)]
                else:
                    cofactors[(x,y)] = -1*minors[(x,y)]
                y += 1
            x += 1
        return cofactors
    def Perspective(e):
        return Matrix2([
            [1,0,0,0],
            [0,1,0,0],
            [0,0,1,1/e[2]],
            [-e[0],-e[1],0,0]])
    def Add(A,B):
        if A.rows != B.rows:
            RuntimeError('The row counts of Matrix \"A\" and Matrix \"B\" are not identical.')
        if A.cols != B.cols:
            RuntimeError('The column counts of Matrix \"A\" and Matrix \"B\" are not identical.')
        matrix = Matrix.Empty(A.rows,A.cols)
        for x in range(A.cols):
            for y in range(A.rows):
                matrix[(x,y)] = A[(x,y)]+B[(x,y)]
        return matrix
    def Subtract(A,B):
        if A.rows != B.rows:
            RuntimeError('The row counts of Matrix \"A\" and Matrix \"B\" are not identical.')
        if A.cols != B.cols:
            RuntimeError('The column counts of Matrix \"A\" and Matrix \"B\" are not identical.')
        matrix = Matrix.Empty(A.rows,A.cols)
        for x in range(A.cols):
            for y in range(A.rows):
                matrix[(x,y)] = A[(x,y)]+B[(x,y)]
        return matrix
    def DivHomogeneous(self):
        if (self.cols,self.rows) == (1,4):
            for y in range(3):
                self[(0,y)] = self[(0,y)]/self[(0,3)]
            self[(0,3)] = 1
        if (self.cols,self.rows) == (4,1):
            for x in range(3):
                self[(x,0)] = self[(x,0)]/self[(3,0)]
            self[(3,0)] = 1
        else:
            raise RuntimeError('1 by 4 or 4 by 1 Matrix2 expected')
    def Object(pos,look,up,right):
        return Matrix2([
            [right.x,right.y,right.z,0],
            [up.x,up.y,up.z,0],
            [look.x,look.y,look.z,0],
            [pos.x,pos.y,pos.z,1]])
    def Camera(eye,look,up,right):
        return Matrix2([
            [right.x,up.x,look.x,0],
            [right.y,up.y,look.y,0],
            [right.z,up.z,look.z,0],
            [-Vector3.Dot(eye,right),
             -Vector3.Dot(eye,up),
             -Vector3.Dot(eye,look),1]])
    def YPR(rot):
        return Matrix2.Multiply(
            Matrix2.Multiply(Matrix2.RotZ(rot.z),
                             Matrix2.RotX(rot.x)),
            Matrix2.RotY(rot.y))
class Vector2:
    def __init__(self,data=0,y=0):
        if (type(data) == type(5)) or (type(data) == type(5.1)):
            self.x = data
            self.y = y
        else:
            self.x = data[0]
            self.y = data[1]
    def __getitem__(self,index):
        if index == 0:
            return self.x
        elif index == 1:
            return self.y
    def __setitem__(self,index,value):
        if index == 0:
            self.x = value
        elif index == 1:
            self.y = 1
    def Add(A,B):
        return Vector2(A.x+B.x,A.y+B.y)
    def Subtract(A,B):
        return Vector2(A.x-B.x,A.y-B.y)
    def Scale(A,n):
        return Vector2(A.x*n,A.y*n)
    def Magnitude(self):
        return ((self.x**2)+(self.y**2))**.5
    def Unit(self):
        return Vector2.Scale(self,1/self.Magnitude())
    def Clone(self):
        return Vector2(self.x,self.y)
class Vector3:
    def __init__(self,data=0,y=0,z=0,w=1):
        if (type(data) == type(5)) or (type(data) == type(5.1)):
            self.x = data/w
            self.y = y/w
            self.z = z/w
        else:
            try:
                temp = data[3]
            except:
                temp = 1
            self.x = data[0]/temp
            self.y = data[1]/temp
            self.z = data[2]/temp
    def __getitem__(self,index):
        if index == 0:
            return self.x
        elif index == 1:
            return self.y
        elif index == 2:
            return self.z
    def __setitem__(self,index,value):
        if index == 0:
            self.x = value
        elif index == 1:
            self.y = value
        elif index == 2:
            self.z = value
    def Vertical(self):
        return Matrix2([[self.x],[self.y],[self.z],[1]])
    def Horizontal(self):
        return Matrix2([[self.x,self.y,self.z,1]])
    def Dot(A,B):
        return (A.x*B.x)+(A.y*B.y)+(A.z*B.z)
    def Cross(A,B):
        return Vector3([
            (A.y*B.z)-(A.z*B.y),
            (A.z*B.x)-(A.x*B.z),
            (A.x*B.y)-(A.y*B.x)])
    def Add(A,B):
        return Vector3(A.x+B.x,A.y+B.y,A.z+B.z)
    def Subtract(A,B):
        return Vector3(A.x-B.x,A.y-B.y,A.z-B.z)
    def Scale(A,n):
        return Vector3(A.x*n,A.y*n,A.z*n)
    def Magnitude(self):
        return ((self.x**2)+(self.y**2)+(self.z**2))**.5
    def Print(self,decimals,spaces):
        return self.Horizontal().Print(decimals,spaces)
    def Same(A,B):
        same = False
        if A.x == B.x:
            if A.y == B.y:
                if A.z == B.z:
                    same = True
        return same
    def Unit(self):
        return Vector3.Scale(self,1/self.Magnitude())
    def Clone(self):
        return Vector3(self.x,self.y,self.z)
class Vector4:
    def __init__(self,data=0,y=0,z=0,w=0):
        if (type(data) == type(5)) or (type(data) == type(5.1)):
            self.x = data
            self.y = y
            self.z = z
            self.w = w
        else:
            self.x = data[0]
            self.y = data[0]
            self.z = data[0]
            self.w = data[0]

points = [Vector3([-1,-1,0]),Vector3([1,-1,0]),Vector3([0,1,0])]
width = 255
height = width
screen = pygame.display.set_mode((width,height),0,32)
scl = 2
pos =  Vector3([0,0,5])
view = Vector3([0,0,1])
frames = 0

def Transform(point,mat):
   return Matrix2.Multiply(point.Horizontal(),mat).Vectorize()

def RV():
   return Vector3([random.random(),random.random(),random.random()])

green = pygame.Color(0,255,0)
def XY(bla):
   return (((width*bla[0])+width)/2,((height*bla[1])+width)/2)

screen.fill(pygame.Color(0,0,0))
size = 255

world = Matrix2.Identity(4)
inv = world.Inverse()
invt = world.Inverse().Transpose()
center = Vector3(0,0,2)


def Texture(size):
   texture = []
   for pa in range(size):
      plane = []
      for pb in range(size):
         line = []
         for pc in range(size):
            line.append(random.random())
         plane.append(line)
      texture.append(plane)
   return texture

lights = [(Vector3(-10,6,-9),[.7,.7*.9,.7*.8],[.7,.7*.9,.9*.8])]
lights = [(Vector3(-10,6,-9),[.8,.8,.8],[.7,.7,.7])]

depth = 3
groups = []
for n in range(1):
   textures = []
   for n in range(depth):
      textures.append(Texture(4**(n+1)))
   groups.append(textures)

def Select(texture,at):
   sel = []
   for pa in range(4):
      aplane = texture[pa+math.floor(at.z)]
      bplane = []
      for pb in range(4):
         aline = aplane[pb+math.floor(at.y)]
         bline = []
         for pc in range(4):
            bline.append(aline[pc+math.floor(at.x)])
         bplane.append(bline)
      sel.append(bplane)
   return (sel,Vector3(at.x%1,at.y%1,at.z%1))
def Round(val):
   return val-(val-math.floor(val))

theta = math.tan(70*math.pi/360)
for x in range(width):
   for event in pygame.event.get():
      if event.type == QUIT:
         pygame.quit()
         sys.exit()
      if event.type == KEYDOWN:
         pass
   for y in range(height):
      l = Vector3(theta*2*((x/width)-.5),theta*2*((y/width)-.5),1).Unit()
      ldc = Vector3.Dot(l,center)
      d = ldc-(((ldc**2)-Vector3.Dot(center,center)+1)**.5)
      if type(d) != type((-1)**.5):
         intersection = Vector3.Scale(l,d)
         normal = Vector3.Subtract(intersection,center).Unit()
         point = Transform(normal,world)

         s = Vector3.Scale(Vector3.Add(point,Vector3(1,1,1)),.5)
         val = 0
         for i in range(depth):
            sel = Select(groups[0][i],Vector3.Scale(s,4**i))
            val += Misc.Tricubic(sel[0],sel[1])*((1/2)**i)/4

         val = (25*val)%1
         vals = [0,Misc.Linear([0,.3,1],val),1]

         coloring = []
         for i in range(3):
            #light = Misc.Lighting([1,1,1],normal,Vector3.Scale(intersection,-1),lights,([0,.03*val,.03],[0,.7*val,.7],[.3,.3,.3],7),i)
            light = Misc.Lighting([.1,.1,.1],normal,Vector3.Scale(intersection,-1),lights,(vals,vals,[1,1,1],10),i)
            if light > 1:
               light = 1
            elif light < 0:
               light = 0
            coloring.append(round(255*light))
         screen.set_at((x,height-y),pygame.Color(coloring[0],coloring[1],coloring[2]))
   pygame.display.update()
pygame.image.save(screen,"PythonSphere.png")
while True:
   for event in pygame.event.get():
      if event.type == QUIT:
         pygame.quit()
         sys.exit()
      if event.type == KEYDOWN:
         pass
