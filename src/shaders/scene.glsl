const int sphere_amount = 4;
Sphere spheres[sphere_amount] = Sphere[](
    Sphere(4, vec3(20, 0, 0), vec3(1, 0.1, 0.1), -0.1, false, 0),
    Sphere(30, vec3(0, -32.0, 0), vec3(0.5, 1, 0.1), 1, false, 0),
    Sphere(1.9, vec3(0, 0, 0), vec3(1), 1, false, 0),
    Sphere(30, vec3(20, 50, 50), vec3(1), 0, true, 0)
);
