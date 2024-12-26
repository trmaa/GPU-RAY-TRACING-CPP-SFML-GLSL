#version 330 core

#include "ray.glsl"
#include "sphere.glsl"

uniform vec2 screen_size;

uniform vec3 cam_pos;
uniform vec3 cam_dir;

void main() {
    vec2 uv = (gl_FragCoord.xy / screen_size) * 2.0 - 1.0;
    uv.y = -uv.y;

    Ray ray = create_ray(cam_pos, vec3(uv, 1.0));
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
