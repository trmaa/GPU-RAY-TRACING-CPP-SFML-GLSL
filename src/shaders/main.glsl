#version 330 core

uniform vec2 screen_size;
uniform vec3 cam_pos;
uniform vec3 cam_dir;
uniform float iTime;

#include "ray.glsl"
#include "sphere.glsl"
#include "scene.glsl"

float random(vec3 seed) {
    return fract(sin(dot(seed + vec3(iTime), vec3(12.9898, 78.233, 45.164))) * 43758.5453);
}

void main() {
    vec2 uv = (gl_FragCoord.xy / screen_size) * 2.0 - 1.0;
    uv.y = -uv.y;
    uv.x = uv.x * screen_size.x / screen_size.y;

    Ray ray = create_ray(cam_pos, cam_dir, uv); 

    vec3 final_col = vec3(0.5);
    int rays_per_pixel = 6;
    for (int j = 0; j < rays_per_pixel; j++) {
        vec3 col = vec3(1);
        Ray current_ray = ray;

        for (int bounce = 0; bounce < 4; bounce++) {
            float closest_t = -1.0;
            vec3 closest_normal = vec3(0.0);
            vec3 hit_point = vec3(0.0);
            float attenuation = 1.0 - float(bounce) / 4.0;

            Sphere hit_sphere;
            bool hit_found = false;

            for (int i = 0; i < 6; ++i) {
                Sphere sphere = spheres[i];
                float t = check_collision(sphere, current_ray);

                if (t > 0.0 && (closest_t < 0.0 || t < closest_t)) {
                    closest_t = t;
                    hit_point = ray_at(current_ray, t);
                    closest_normal = normalize(sphere_normal(sphere, hit_point));
                    hit_sphere = sphere;
                    hit_found = true;
                }
            }

            if (!hit_found) {
                break;
            }
            if (hit_sphere.emissive) {
                col = sphere_color(hit_sphere);
                break;
            }

            float light_intensity = clamp(dot(closest_normal, normalize(vec3(-1))) + 0.2, 0.7, 1.0);
            col = normalize(col) * attenuation * light_intensity * sphere_color(hit_sphere);

            vec3 random_vec = vec3(
                random(hit_point + vec3(j, 1.0, 0.0)),
                random(hit_point + vec3(j, 0.0, 1.0)),
                random(hit_point + vec3(j, 0.0, 0.0))
            );
            vec3 roughness_offset = normalize(random_vec - vec3(0.5)) * hit_sphere.roughness;
            current_ray = cast_ray(hit_point + closest_normal * 0.01, reflect(current_ray.direction, closest_normal) + roughness_offset);
        }

        final_col += col;
    }

    final_col /= float(rays_per_pixel);
    gl_FragColor = vec4(final_col, 1.0);
}
