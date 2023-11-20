type item = [3]f32
type vec2 = {x: f32, y: f32}
type vec3 = {x: f32, y: f32, z: f32}

def index_to_relative (i:i64) (max:i64): f32 = (f32.i64 i) / (f32.i64 max) * 2.0 - 1.0
def dot (v1:vec3) (v2:vec3): f32 = (v1.x * v2.x) + (v1.y * v2.y) + (v1.z * v2.z)
def add (v1:vec3) (v2:vec3): vec3 = {x= v1.x+v2.x, y= v1.y+v2.y, z= v1.z+v2.z}
def mul (v1:vec3) (s:f32): vec3 = {x= v1.x * s, y= v1.y * s, z= v1.z * s}
def normalize (v: vec3): vec3 = 
    let length = f32.abs (f32.sqrt (v.x * v.x) + (v.y * v.y) + (v.z * v.z))
    in {x= v.x/length, y= v.y/length, z= v.z/length}

def ray_origin: vec3 = {x = 0, y = 0, z = 1}
def sphere_radius: f32 = 0.5
def light_dir: vec3 = normalize {x = -1, y = -1, z = -1}
def light_dir_neg: vec3 = mul light_dir (-1.0)

def bg: item = [0, 0, 0]
def sphere: item = [1, 0, 1]

def generate cols rows n m: item =
    let x = index_to_relative m cols
    let y = index_to_relative n rows
    let ray_direction:vec3 = {x, y, z = -1}
    let a = dot ray_direction ray_direction
	let b = 2.0 * dot ray_origin ray_direction
	let c = (dot ray_origin ray_origin) - sphere_radius * sphere_radius
    let discriminant = b * b - 4.0 * a * c
    in if discriminant < 0.0 then [0, 0, 0] else
        let closest_t = (-b - f32.sqrt discriminant) / (2.0 * a)
        let _t0 = (-b + f32.sqrt discriminant) / (2.0 * a) -- currently unused
        let hit_point = add ray_origin (mul ray_direction closest_t)
        let normal = normalize hit_point
        let light_intensity = f32.max (dot normal light_dir_neg) 0.0
        in [light_intensity, 0, light_intensity]

def main cols rows: [][]item = tabulate_2d cols rows (generate cols rows)