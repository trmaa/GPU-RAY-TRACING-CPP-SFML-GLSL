struct Sphere {
    float radius;
    vec3 center;
    vec3 color;
    float roughness;
    bool emissive;
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
        return val1>2?val1:val2;
    }
}

vec3 sphere_normal(Sphere s, vec3 hitp) {
    return normalize(hitp - s.center); 
}

vec3 sphere_color(Sphere s) {
    return s.color; 
}
