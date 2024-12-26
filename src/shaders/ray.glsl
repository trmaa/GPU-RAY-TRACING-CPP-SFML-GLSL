struct Ray {
    vec3 origin;
    vec3 direction;
    float far;
};

Ray create_ray(vec3 o, vec3 angle_c, vec2 id) {
    Ray ray;
    ray.far = 4*screen_size.x/1920;

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
