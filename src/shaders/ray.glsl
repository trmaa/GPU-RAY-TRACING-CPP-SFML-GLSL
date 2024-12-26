struct Ray {
    vec3 origin;
    vec3 direction;
};

Ray create_ray(vec3 o, vec3 d) {
    Ray ray;
    ray.origin = o;
    ray.direction = normalize(d);
    return ray;
}

vec3 ray_at(Ray ray, float t) {
    return ray.origin + t * ray.direction;
}
