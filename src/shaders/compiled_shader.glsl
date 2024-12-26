#version 330 core

struct Ray {
    vec3 origin;
    vec3 direction;
    float far;
};

Ray create_ray(vec3 o, vec3 angle_c, vec2 id) {
    Ray ray;
    ray.far = 2;

    ray.origin = o;

    vec3 angle_o = vec3(
        atan(id.y/ray.far),
        atan(id.x/ray.far),
        0);
    vec3 angle_f = angle_o + angle_c;

    ray.direction = normalize(vec3(
            cos(angle_f.x)*sin(angle_f.y),
            sin(angle_f.x),
            cos(angle_f.x)*cos(angle_f.y)));

    return ray;
}

vec3 ray_at(Ray ray, float t) {
    return ray.origin + t * ray.direction;
}

struct Sphere {
    float radius;
    vec3 center;
};

Sphere create_sphere(float r, vec3 c) {
    Sphere sphere;
    sphere.radius = r;
    sphere.center = c;
    return sphere;
}

float check_collision(Sphere sphere, Ray ray) {
    vec3 oc = ray.origin - sphere.center;
    float a = dot(ray.direction, ray.direction);
    float b = 2.0 * dot(oc, ray.direction);
    float c = dot(oc, oc) - sphere.radius * sphere.radius;
    float discriminant = b * b - 4.0 * a * c;

    if (discriminant < 0.0) {
        return -1.0;
    } else {
        return (-b - sqrt(discriminant)) / (2.0 * a);
    }
}


uniform vec2 screen_size;

uniform vec3 cam_pos;
uniform vec3 cam_dir;

void main() {
    vec2 uv = (gl_FragCoord.xy / screen_size) * 2.0 - 1.0;
    uv.y = -uv.y;

    Ray ray = create_ray(cam_pos, cam_dir, uv);
    Sphere sphere = create_sphere(1.0, vec3(0.0, 0.0, 0.0));

    vec3 col = vec3(0.0);
    float t = check_collision(sphere, ray);

    if (t > 0.0) {
        vec3 hit_point = ray_at(ray, t);
        vec3 normal = normalize(hit_point - sphere.center);
        col = vec3(normal.x, normal.y, normal.z);
    }

    gl_FragColor = vec4(col, 1.0);
}
