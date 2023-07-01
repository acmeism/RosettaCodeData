pub struct Vector3 {pub x: f64, pub y: f64, pub z: f64, pub w: f64}

pub struct Triangle {pub r: [usize; 3], pub(crate) col: [f32; 4], pub(crate) p: [Vector3; 3], n: Vector3, pub t: [Vector2; 3]}
pub struct Mesh{pub v: Vec<Vector3>, pub f: Vec<Triangle>}

impl Triangle{
    pub fn new() -> Triangle {return Triangle {r: [0, 0, 0], col: [0.0; 4], p: [Vector3::new(0.0, 0.0, 0.0), Vector3::new(0.0, 0.0, 0.0), Vector3::new(0.0, 0.0, 0.0)], n: Vector3::new(0.0, 0.0, 0.0), t: [Vector2::new(0.0, 0.0), Vector2::new(0.0, 0.0), Vector2::new(0.0, 0.0)]}}
    pub fn copy(&self) -> Triangle {return Triangle {r: self.r.clone(), col: self.col, p: [self.p[0].copy(), self.p[1].copy(), self.p[2].copy()], n: self.n.copy(), t: [self.t[0].copy(), self.t[1].copy(), self.t[2].copy()]}}
}


impl Vector3 {
    pub fn new(x: f64, y: f64, z: f64) -> Vector3 {return Vector3 {x, y, z, w: 1.0}}
    pub fn normalize(&mut self) {
        let l = (self.x * self.x + self.y * self.y + self.z * self.z).sqrt();
        self.x /= l;
        self.y /= l;
        self.z /= l;
    }
    pub fn dot_product(v1: &Vector3, v2: &Vector3) -> f64 {return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z}
    pub fn cross_product(v1: &Vector3, v2: &Vector3) -> Vector3 {return Vector3::new(v1.y * v2.z - v1.z * v2.y, v1.z * v2.x - v1.x * v2.z, v1.x * v2.y - v1.y * v2.x)}
    pub fn intersect_plane(plane_n: &Vector3, plane_p: &Vector3, line_start: &Vector3, line_end: &Vector3, mut t: f64) -> Vector3 {
        let mut p_n = plane_n.copy();

        p_n.normalize();
        let plane_d = -Vector3::dot_product(&p_n, plane_p);
        let ad = Vector3::dot_product(line_start, &p_n);
        let bd = Vector3::dot_product(line_end, &p_n);
        t = (-plane_d - ad) / (bd - ad);
        let line = line_end.copy() - line_start;
        let line_i = line * t;
        return line_start.copy() + &line_i;
    }
    pub fn copy(&self) -> Vector3 {return Vector3 {x: self.x, y: self.y, z: self.z, w: self.w}}
}

impl Mesh {
    pub fn get_face_points(&self) -> Vec<Vector3> {
        let mut face_points: Vec<Vector3> = Vec::new();

        for curr_face in &self.f {
            let mut face_point = Vector3::new(0.0, 0.0, 0.0);
            for curr_point_index in curr_face.r {
                let curr_point = &self.v[curr_point_index];
                face_point += &curr_point
            }

            face_point /= curr_face.r.len() as f64;
            face_points.push(face_point.copy());
        }
        return face_points;
    }
    pub fn get_edges_faces(&self) -> Vec<[f64; 7]> {
        let mut edges: Vec<[usize; 3]> = Vec::new();

        for face_num in 0..self.f.len() {
            let face: Triangle = self.f[face_num].copy();
            let num_points = face.p.len();
            for point_index in 0..num_points {
                let mut point_num_1 = 0;
                let mut point_num_2 = 0;
                if point_index < num_points - 1 {
                    point_num_1 = face.r[point_index];
                    point_num_2 = face.r[point_index + 1];
                } else {
                    point_num_1 = face.r[point_index];
                    point_num_2 = face.r[0];
                }
                if point_num_1 > point_num_2 {
                    let temp = point_num_1;
                    point_num_1 = point_num_2;
                    point_num_2 = temp;
                }
                edges.push([point_num_1, point_num_2, face_num]);
            }
        }
        edges.sort();

        let num_edges = edges.len();
        let mut index = 0;
        let mut merged_edges: Vec<[f64; 4]> = Vec::new();

        while index < num_edges {
            let e1 = edges[index];
            if index < num_edges - 1 {
                let e2 = edges[index + 1];
                if e1[0] == e2[0] && e1[1] == e2[1] {
                    merged_edges.push([e1[0] as f64, e1[1] as f64, e1[2] as f64, e2[2] as f64]);
                    index += 2;
                } else {
                    merged_edges.push([e1[0] as f64, e1[1] as f64, e1[2] as f64, -1.0]);
                    index += 1;
                }
            } else {
                merged_edges.push([e1[0] as f64, e1[1] as f64, e1[2] as f64, -1.0]);
                index += 1
            }
        }

        let mut edges_centers = Vec::new();

        for me in merged_edges {
            let p1 = self.v[me[0] as usize].copy();
            let p2 = self.v[me[1] as usize].copy();
            let cp: Vector3 = Mesh::center_point(&p1, &p2);
            edges_centers.push([me[0] as f64, me[1] as f64, me[2] as f64, me[3] as f64, cp.x, cp.y, cp.z]);
        }
        return edges_centers;
    }
    pub fn get_edge_points(&self, edges_faces: &Vec<[f64; 7]>, face_points: &Vec<Vector3>) -> Vec<Vector3> {
        let mut edge_points = Vec::new();

        for edge in edges_faces {
            let cp = Vector3::new(edge[4], edge[5], edge[6]);
            let fp1: Vector3 = face_points[edge[2] as usize].copy();
            let mut fp2: Vector3 = fp1.copy();
            if edge[3] != -1.0 { fp2 = face_points[edge[3] as usize].copy() };
            let cfp = Mesh::center_point(&fp1, &fp2);
            let edge_point = Mesh::center_point(&cp, &cfp);
            edge_points.push(edge_point);
        }

        return edge_points
    }
    pub fn get_avg_face_points(&self, face_points: &Vec<Vector3>) -> Vec<Vector3> {
        let num_points = self.v.len();
        let mut temp_points = Vec::new();
        let mut div: Vec<i32> = Vec::new();

        for _ in 0..num_points {
            temp_points.push(Vector3::new(0.0, 0.0, 0.0));
            div.push(0)
        };

        for face_num in 0..self.f.len() {
            let mut fp = face_points[face_num].copy();
            for point_num in self.f[face_num].r {
                let tp = temp_points[point_num].copy();
                temp_points[point_num] = tp + &fp;
                div[point_num] += 1;
            }
        }

        let mut avg_face_points: Vec<Vector3> = Vec::new();
        for i in 0..temp_points.len() {
            let tp: Vector3 = temp_points[i].copy();
            let t = tp / (div[i] as f64);
            avg_face_points.push(t.copy());
        }

        return avg_face_points;
    }
    pub fn get_avg_mid_edges(&self, edges_faces: &Vec<[f64; 7]>) -> Vec<Vector3> {
        let num_points = self.v.len();
        let mut temp_points = Vec::new();
        let mut div: Vec<i32> = Vec::new();

        for point_num in 0..num_points{ temp_points.push(Vector3::new(0.0, 0.0, 0.0)); div.push(0)}
        for edge in edges_faces {
            let cp = Vector3::new(edge[4], edge[5], edge[6]);
            for point_num in [edge[0] as usize, edge[1] as usize] {
                let tp = temp_points[point_num].copy();
                temp_points[point_num] = tp + &cp;
                div[point_num] += 1
            }
        }

        let mut avg_mid_edges: Vec<Vector3> = Vec::new();

        for i in 0..temp_points.len(){
            let ame: Vector3 = temp_points[i].copy() / (div[i] as f64);
            avg_mid_edges.push(ame)}

        return avg_mid_edges
    }
    pub fn get_points_faces(&self) -> Vec<i32> {
        let num_points = self.v.len();
        let mut points_faces: Vec<i32> = Vec::new();

        for point_num in 0..num_points{points_faces.push(0)}

        for face_num in 0..self.f.len() {
            for point_num in self.f[face_num].r {
                points_faces[point_num] += 1;
            }
        }
        return points_faces
    }
    pub fn get_new_points(&self, points_faces: &Vec<i32>, avg_face_points: &Vec<Vector3>, avg_mid_edges: &Vec<Vector3>) -> Vec<Vector3> {
        let mut new_points: Vec<Vector3> = Vec::new();

        for point_num in 0..self.v.len() {
            let n = points_faces[point_num] as f64;
            let m1 = (n - 3.0) / n;
            let m2 = 1.0 / n;
            let m3 = 2.0 / n;
            let old_coords = self.v[point_num].copy();
            let p1 = old_coords * m1;
            let afp = avg_face_points[point_num].copy();
            let p2 = afp * m2;
            let ame = avg_mid_edges[point_num].copy();
            let p3 = ame * m3;
            let p4 = p1 + &p2;
            let new_coords = p4 + &p3;

            new_points.push(new_coords);
        }

        return new_points;
    }

    pub fn switch_nums(point_nums: [f64; 2]) -> [f64; 2] {
        return if point_nums[0] < point_nums[1] { point_nums } else {[point_nums[1], point_nums[0]]}
    }

    pub fn get_key(points: [f64; 2]) -> String {
        return points[0].to_string() + ";" + &*points[1].to_string();
    }

    pub fn subdivide(&mut self) {
        let face_points = self.get_face_points();
        let edges_faces = self.get_edges_faces();
        let edge_points = self.get_edge_points(&edges_faces, &face_points);
        let avg_face_points = self.get_avg_face_points(&face_points);
        let avg_mid_edges = self.get_avg_mid_edges(&edges_faces);
        let points_faces = self.get_points_faces();
        let mut new_points = self.get_new_points(&points_faces, &avg_face_points, &avg_mid_edges);

        let mut face_point_nums = Vec::new();
        let mut next_point_num = new_points.len();

        for face_point in face_points {
            new_points.push(face_point);
            face_point_nums.push(next_point_num);
            next_point_num += 1;
        }

        let mut edge_point_nums: HashMap<String, usize> = HashMap::new();

        for edge_num in 0..edges_faces.len() {
            let point_num_1 = edges_faces[edge_num][0];
            let point_num_2 = edges_faces[edge_num][1];
            let edge_point = edge_points[edge_num].copy();
            new_points.push(edge_point);
            edge_point_nums.insert(Mesh::get_key([point_num_1, point_num_2]), next_point_num);
            next_point_num += 1;
        }

        let mut new_faces = Vec::new();

        for old_face_num in 0..self.f.len() {
            let old_face = self.f[old_face_num].copy();
            let a = old_face.r[0] as f64;
            let b = old_face.r[1] as f64;
            let c = old_face.r[2] as f64;
            let face_point_abc = face_point_nums[old_face_num];
            let edge_point_ab = *edge_point_nums.get(&*Mesh::get_key(Mesh::switch_nums([a, b]))).unwrap();
            let edge_point_bc = *edge_point_nums.get(&*Mesh::get_key(Mesh::switch_nums([b, c]))).unwrap();
            let edge_point_ca = *edge_point_nums.get(&*Mesh::get_key(Mesh::switch_nums([c, a]))).unwrap();
            new_faces.push([a, edge_point_ab as f64, face_point_abc as f64, edge_point_ca as f64]);
            new_faces.push([b, edge_point_bc as f64, face_point_abc as f64, edge_point_ab as f64]);
            new_faces.push([c, edge_point_ca as f64, face_point_abc as f64, edge_point_bc as f64]);
        }
        self.f = Vec::new();

        for face_num in 0..new_faces.len() {
            let curr_face = new_faces[face_num];
            let mut t1: Triangle = Triangle::new();
            let mut t2: Triangle = Triangle::new();
            t1.p[0] = Vector3::new(new_points[curr_face[0] as usize].x, new_points[curr_face[0] as usize].y, new_points[curr_face[0] as usize].z);
            t1.p[1] = Vector3::new(new_points[curr_face[1] as usize].x, new_points[curr_face[1] as usize].y, new_points[curr_face[1] as usize].z);
            t1.p[2] = Vector3::new(new_points[curr_face[2] as usize].x, new_points[curr_face[2] as usize].y, new_points[curr_face[2] as usize].z);
            t2.p[0] = Vector3::new(new_points[curr_face[2] as usize].x, new_points[curr_face[2] as usize].y, new_points[curr_face[2] as usize].z);
            t2.p[1] = Vector3::new(new_points[curr_face[3] as usize].x, new_points[curr_face[3] as usize].y, new_points[curr_face[3] as usize].z);
            t2.p[2] = Vector3::new(new_points[curr_face[0] as usize].x, new_points[curr_face[0] as usize].y, new_points[curr_face[0] as usize].z);
            t1.r = [curr_face[0] as usize, curr_face[1] as usize, curr_face[2] as usize];
            t2.r = [curr_face[2] as usize, curr_face[3] as usize, curr_face[0] as usize];
            self.f.push(t1);
            self.f.push(t2);
        }
        self.v = new_points;
    }
}
