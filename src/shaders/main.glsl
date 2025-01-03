#version 330 core

uniform vec2 screen_size;
uniform vec3 cam_pos;
uniform vec3 cam_dir;
uniform float iTime;

uniform sampler2D log_texture;

#include "ray.glsl"
#include "sphere.glsl"
#include "scene.glsl"

float random(vec3 seed) {
    return fract(sin(dot(seed /*+ vec3(iTime)*/, vec3(12.9898, 78.233, 45.164))) * 43758.5453);
}

void main() {
    vec2 uv = (gl_FragCoord.xy / screen_size) * 2.0 - 1.0;
    //uv.y = -uv.y;
    uv.x = uv.x * screen_size.x / screen_size.y;

    Ray ray = create_ray(cam_pos, cam_dir, uv); 

    vec3 final_col = vec3(0);
    int rays_per_pixel = 6;
    for (int j = 0; j < rays_per_pixel; j++) {
        vec3 col = vec3(0);
        vec3 first_col = col;
        Ray current_ray = ray;

        int bounces = 6;
        for (int bounce = 0; bounce < bounces; bounce++) {
            float closest_t = -1.0;
            vec3 closest_normal;
            vec3 hit_point;
            vec3 first_hit_col;
            float attenuation = 1.0 - float(bounce) / float(bounces);

            Sphere hit_sphere;
            bool hit_found = false;
    
            for (int i = 0; i < sphere_amount; ++i) {
                Sphere sphere = spheres[i];
                float t = check_collision(sphere, current_ray);

                if (t > 0.0 && (closest_t < 0.0 || t < closest_t)) {
                    closest_t = t;
                    hit_point = ray_at(current_ray, t);
                    closest_normal = normalize(sphere_normal(sphere, hit_point));
                    hit_sphere = sphere;
                    hit_found = true;
                    col = sphere_color(hit_sphere, closest_normal);
                    if (bounce == 0) {
                        first_col = col;
                    }
                }
            }

            if (!hit_found) {
                if (bounce == 0) {
                    col = vec3(0);
                }
                break;
            }

            float shadow_bright = 1.0;
            vec3 light_position = vec3(-50.0, 70.0, -50.0);
            vec3 light_dir = normalize(light_position - hit_point);
            Ray ray_to_light = cast_ray(hit_point + closest_normal * 0.01, light_dir);
            float light_distance = length(light_position - hit_point);
            float intensity = dot(normalize(closest_normal), normalize(ray_to_light.direction));
            bool got_light = false;
            
            vec3 light_col = vec3(1);
            for (int i = 0; i < sphere_amount; i++) {
                Sphere sphere = spheres[i];
                float t = check_collision(sphere, ray_to_light);

                if (t > 0.0 && t < light_distance) {
                    got_light = true;
                    shadow_bright = 0.0;
                    break;
                }
            }
 
            first_col *= shadow_bright * intensity * attenuation;
            col = first_col * sphere_color(hit_sphere, closest_normal);
            
            vec3 random_vec = vec3(
                random(hit_point + vec3(j,0,0)),
                random(hit_point + vec3(j,1,0)),
                random(hit_point + vec3(j,0,1))
            );
            vec3 roughness_offset = normalize(random_vec*2 - vec3(1)) * hit_sphere.roughness;
            vec3 reflected_dir = reflect(current_ray.direction, closest_normal);
            current_ray = cast_ray(hit_point + closest_normal * 0.01, reflected_dir + roughness_offset);
        }

        final_col += col;
    }

    final_col /= float(rays_per_pixel);
    gl_FragColor = vec4(final_col, 1.0);
}
