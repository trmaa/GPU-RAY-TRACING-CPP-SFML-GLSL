struct Ray {
    vec3 origin;
    vec3 direction;
    float far;
};

Ray create_ray(vec3 o, vec3 angle_c, vec2 id) {
    Ray ray;
    ray.far = 10 * screen_size.x / 1920;

    angle_c.x += 3.14159/2;
    angle_c.y -= 3.14159/2;
    ray.origin = o;

    vec3 camera_space_direction = normalize(vec3(id.x, id.y, -ray.far));

    float cos_pitch = sin(angle_c.x);
    float sin_pitch = cos(angle_c.x);
    float cos_yaw = sin(angle_c.y);
    float sin_yaw = cos(angle_c.y);

    mat3 R_x = mat3(
        1, 0, 0,
        0, cos_pitch, -sin_pitch,
        0, sin_pitch, cos_pitch
    );

    mat3 R_y = mat3(
        cos_yaw, 0, sin_yaw,
        0, 1, 0,
        -sin_yaw, 0, cos_yaw
    );

    mat3 R = R_y * R_x;

    ray.direction = normalize(R * camera_space_direction);

    return ray;
}

Ray cast_ray(vec3 o, vec3 d) {
    Ray ray;
    ray.origin = o;
    ray.direction = normalize(d);
    return ray;
}

vec3 ray_at(Ray ray, float t) {
    return ray.origin + t * ray.direction;
}
