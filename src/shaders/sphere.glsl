struct Sphere {
    float radius;
    vec3 center;
    vec3 color;
    float roughness;
};

float check_collision(Sphere sphere, Ray ray) {
    vec3 oc = ray.origin - sphere.center;
    float a = dot(ray.direction, ray.direction);
    float b = 2.0 * dot(oc, ray.direction);
    float c = dot(oc, oc) - sphere.radius * sphere.radius;
    float discriminant = b * b - 4.0 * a * c;

    if (discriminant < 0.0) {
        return -1.0;
    } else {
        float val1 = (-b - sqrt(discriminant)) / (2.0 * a);
        float val2 = (-b + sqrt(discriminant)) / (2.0 * a);
        return val1 > 2.0 ? val1 : val2;
    }
}

vec3 sphere_normal(Sphere s, vec3 hitp) {
    return normalize(hitp - s.center);
}

vec2 normal_to_uv(vec3 normal) {
    float u = 0.5 + atan(normal.z, normal.x) / (2.0 * 3.141592653589793);
    float v = 0.5 - asin(normal.y) / 3.141592653589793;
    return vec2(u, v);
}

vec3 sphere_color(Sphere s, vec3 normal) {
    vec2 uv = normal_to_uv(normal);
    vec3 texture_color = texture(log_texture, uv).rgb;
    return s.color;
}
