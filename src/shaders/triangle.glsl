struct Triangle {
    vec3 p1;
    vec3 p2;
    vec3 p3;
    vec3 color;
    float roughness;
};

vec3 triangle_normal(Triangle triangle, Ray ray) {
    float dotp = dot(cross(triangle.p2, triangle.p3), ray.direction);
    if (dotp > 0) {
        return cross(triangle.p3, triangle.p2);
    }
    return cross(triangle.p2, triangle.p3);
}

float check_collision(Triangle triangle, Ray ray) {
    float denominator = dot(ray.direction, triangle_normal(triangle, ray));

    if (abs(denominator) > 0) { 
        vec3 diff = triangle.p1 - ray.origin;
        float t = dot(diff, triangle_normal(triangle, ray)) / denominator;
        
        vec3 hitp = ray_at(ray, t);
        
        vec3 v0 = triangle.p2;
        vec3 v1 = triangle.p3;
        vec3 v2 = hitp - triangle.p1;

        float d00 = dot(v0, v0);
        float d01 = dot(v0, v1);
        float d11 = dot(v1, v1);
        float d20 = dot(v2, v0);
        float d21 = dot(v2, v1);
        float denom = d00 * d11 - d01 * d01;

        float v = (d11 * d20 - d01 * d21) / denom;
        float w = (d00 * d21 - d01 * d20) / denom;
        float u = 1.0 - v - w;

        bool cond = (u >= 0.0) && (v >= 0.0) && (w >= 0.0);
        if (cond && t >= 0.0) {
            return t;
        }
    }

    return -1.0;
}
