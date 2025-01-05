#version 330 core

uniform vec2 screen_size;
uniform vec3 cam_pos;
uniform vec3 cam_dir;
uniform float iTime;

uniform sampler2D log_texture;

#include "ray.glsl"
#include "sphere.glsl"
#include "triangle.glsl"
#include "scene.glsl"

float random(vec3 seed) {
    return fract(sin(dot(seed /*+ vec3(iTime)*/, vec3(12.9898, 78.233, 45.164))) * 43758.5453);
}

void main() {
    vec2 uv = (gl_FragCoord.xy / screen_size) * 2.0 - 1.0;
    //uv.y = -uv.y;
    uv.x = -uv.x * screen_size.x / screen_size.y;

    Ray ray = create_ray(cam_pos, cam_dir, uv); 

    vec3 final_col = vec3(0);
    vec3 sky_col = vec3(0);
    int rays_per_pixel = 4;
    for (int j = 0; j < rays_per_pixel; j++) {
        vec3 col = vec3(0);
        vec3 first_col = col;
        Ray current_ray = ray;

//SEE FOR SPHERES OR LIGHTS

        int bounces = 3;
        for (int bounce = 0; bounce < bounces; bounce++) {
            float closest_t = -1.0;
            vec3 closest_normal;
            vec3 hit_point;
            vec3 first_hit_col;
            float attenuation = 1.0 - float(bounce) / float(bounces);

            Sphere hit_sphere;
            bool sphere_is_hit = false;
            Triangle hit_triangle;
            bool triangle_is_hit = false;

            bool hit_found = false;
            bool light_found = false;
    
            float t;
            for (int i = 0; i < sphere_amount; ++i) {
                Sphere sphere = spheres[i];
                t = check_collision(sphere, current_ray);

                if (t > 0.0 && (closest_t < 0.0 || t < closest_t)) {
                    closest_t = t;
                    hit_point = ray_at(current_ray, t);
                    closest_normal = normalize(sphere_normal(sphere, hit_point));
                    hit_sphere = sphere;
                    sphere_is_hit = true;
                    triangle_is_hit = false;
                    hit_found = true;
                    col = sphere_color(hit_sphere, closest_normal);
                    if (bounce == 0) {
                        first_col = col;
                    }
                }
            }
            for (int i = 0; i < triangle_amount; ++i) {
                Triangle triangle = trianglez[i];
                t = check_collision(triangle, current_ray);

                if (t > 0.0 && (closest_t < 0.0 || t < closest_t)) {
                    closest_t = t;
                    hit_point = ray_at(current_ray, t);
                    closest_normal = normalize(triangle_normal(triangle, current_ray));
                    hit_triangle = triangle;
                    triangle_is_hit = true;
                    sphere_is_hit = false;
                    hit_found = true;
                    col = triangle.color;
                    if (bounce == 0) {
                        first_col = col;
                    }
                }
            }
            for (int i = 0; i < light_amount; ++i) {
                Sphere light = lights[i];
                t = check_collision(light, current_ray);

                if (t > 0.0 && (closest_t < 0.0 || t < closest_t)) {
                    closest_t = t;
                    light_found = true;
                    hit_found = true;
                    col = light.color;
                }
            }

            if (!hit_found) {
                if (bounce == 0) {
                    //col = vec3(ray.direction.x, ray.direction.y, ray.direction.z);
                    col = sky_col;
                }
                break;
            }
            if (light_found) {
                break;
            }

//SEE FOR SHADOWS

            vec3 light_col = vec3(1);

            float shadow_bright = 1.0;
            vec3 ilumination = vec3(0);
            
            for (int j = 0; j < light_amount; j++) {
                Sphere light = lights[j];
                vec3 light_dir = normalize(light.center - hit_point);
                Ray ray_to_light = cast_ray(hit_point + closest_normal * 0.01, light_dir);
                float light_distance = length(light.center - hit_point);

                float day_light = (sky_col.x + sky_col.y + sky_col.z) / 3.0;

                float dot_product = dot(normalize(closest_normal), normalize(ray_to_light.direction));
                if (day_light > 0.0) {
                    dot_product += day_light;
                    dot_product /= 2.0;
                }

                if (dot_product > 0.0) {
                    ilumination += sphere_color(light, closest_normal) * dot_product;
                }

                bool in_shadow = false;

                for (int i = 0; i < sphere_amount; i++) {
                    Sphere sphere = spheres[i];
                    float t = check_collision(sphere, ray_to_light);

                    if (t > 0.0 && t < light_distance && sphere != hit_sphere) {
                        in_shadow = true;
                        break;
                    }
                }

                if (!in_shadow) {
                    for (int i = 0; i < triangle_amount; i++) {
                        Triangle triangle = trianglez[i];
                        float t = check_collision(triangle, ray_to_light);

                        if (t > 0.0 && t < light_distance) {
                            in_shadow = true;
                            break;
                        }
                    }
                }

                if (in_shadow) {
                    shadow_bright = day_light*0.5 + 0.5 ;
                }
            }

            first_col *= shadow_bright * ilumination * attenuation;

// SET THE COLOR

            if (sphere_is_hit) {
                col = first_col * sphere_color(hit_sphere, closest_normal);
            } else if (triangle_is_hit) {
                col = first_col * hit_triangle.color;
            }
            col = mix(col, sky_col, 0.2);
            
//BOUNCE

            vec3 random_vec = vec3(
                random(hit_point + vec3(j,0,0)),
                random(hit_point + vec3(j,1,0)),
                random(hit_point + vec3(j,0,1))
            );

            vec3 roughness_offset;
            if (sphere_is_hit) {
                roughness_offset = normalize(random_vec*2 - vec3(1)) * hit_sphere.roughness;
            } else if (triangle_is_hit) {
                roughness_offset = normalize(random_vec*2 - vec3(1)) * hit_triangle.roughness;
            }
            vec3 reflected_dir = reflect(current_ray.direction, closest_normal);
            current_ray = cast_ray(hit_point + closest_normal * 0.01, reflected_dir + roughness_offset);
        }

        final_col += col;
    }

    final_col /= float(rays_per_pixel);
    gl_FragColor = vec4(final_col, 1.0);
}
