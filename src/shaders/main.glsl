#version 330 core

uniform vec2 screen_size;

uniform vec3 cam_pos;
uniform vec3 cam_dir;

#include "ray.glsl"
#include "sphere.glsl"

void main() {
    vec2 uv = (gl_FragCoord.xy / screen_size) * 2.0 - 1.0;
    uv.y = -uv.y;
    uv.x = uv.x * screen_size.x / screen_size.y;

    Ray ray = create_ray(cam_pos, cam_dir, uv);

    Sphere spheres[5] = Sphere[](
        Sphere(1.0, vec3(-2.0, 0.0, -5.0), vec3(1, 0, 0)),
        Sphere(0.8, vec3(0.0, 1.0, -4.0), vec3(0, 0, 1)),
        Sphere(1.2, vec3(2.0, -1.0, -6.0), vec3(0, 1, 0)),
        Sphere(0.6, vec3(1.0, 1.0, -3.0), vec3(1, 1, 0)),
        Sphere(1.0, vec3(-1.5, -0.5, -4.5), vec3(0, 1, 1))
    );

    vec3 col = vec3(1);
    float closest_t;

    for (int bounce = 0; bounce < 4; bounce++) {
        closest_t = -1.0;
        vec3 closest_normal = vec3(0.0);
        vec3 hit_point = vec3(0.0);
        float attenuation = 1-bounce/5;

        Sphere hit_sphere;
        bool hit_found = false;

        for (int i = 0; i < 5; ++i) {
            Sphere sphere = spheres[i];
            float t = check_collision(sphere, ray);

            if (t > 0.0 && (closest_t < 0.0 || t < closest_t)) {
                closest_t = t;
                hit_point = ray_at(ray, t);
                closest_normal = normalize(sphere_normal(sphere, hit_point));
                hit_sphere = sphere;
                hit_found = true;
            }
        }

        if (!hit_found) {
            break; 
        }
        
        float light_intensity = clamp((dot(closest_normal, normalize(vec3(-1)))+0.1), 0.65, 1);
        col = attenuation * sphere_color(hit_sphere)* light_intensity * col;

        ray.origin = hit_point + closest_normal * 0.01;
        ray.direction = reflect(ray.direction, closest_normal);
    }

    gl_FragColor = vec4(col, 1.0);
}
