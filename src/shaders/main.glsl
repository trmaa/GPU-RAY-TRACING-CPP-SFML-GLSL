#version 330 core

uniform vec2 screen_size;

uniform vec3 cam_pos;
uniform vec3 cam_dir;

#include "ray.glsl"
#include "sphere.glsl"

void main() {
    vec2 uv = (gl_FragCoord.xy / screen_size) * 2.0 - 1.0;
    uv.y = -uv.y;
    uv.x = uv.x*screen_size.x/screen_size.y;

    Ray ray = create_ray(cam_pos, cam_dir, uv);

    Sphere spheres[5] = Sphere[](
        Sphere(1.0, vec3(-2.0, 0.0, -5.0)),
        Sphere(0.8, vec3(0.0, 1.0, -4.0)),
        Sphere(1.2, vec3(2.0, -1.0, -6.0)),
        Sphere(0.6, vec3(1.0, 1.0, -3.0)),
        Sphere(1.0, vec3(-1.5, -0.5, -4.5))
    );

    float closest_t = -1.0;
    vec3 closest_normal = ray.direction;
    vec3 hit_point = ray.origin;

    for (int bounce = 0; bounce < 4; bounce++) {
        for (int i = 0; i < 5; ++i) {
            Sphere sphere = spheres[i];
            float t = check_collision(sphere, ray);

            if (t > 0.0 && (closest_t < 0.0 || t < closest_t)) {
                closest_t = t;
                vec3 hit_point = ray_at(ray, t);
                closest_normal = normalize(sphere_normal(sphere, hit_point));
            } else {
                continue;
            }
        }
        ray = cast_ray(hit_point + closest_normal*0.01, (closest_normal*2*dot(closest_normal, ray.direction))+ray.direction);
    }

    vec3 col = closest_t > 0.0 ? closest_normal * 0.5 + 0.5 : vec3(0.0);

    gl_FragColor = vec4(col, 1.0);
}
