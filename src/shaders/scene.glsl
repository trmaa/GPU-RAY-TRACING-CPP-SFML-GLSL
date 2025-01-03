const int sphere_amount = 4;
Sphere spheres[sphere_amount] = Sphere[](
    Sphere(4, vec3(20, 0, 0), vec3(1, 0.1, 0.1), -0.1),
    Sphere(30, vec3(0, -32.0, 0), vec3(0.5, 1, 0.1), 1),
    Sphere(1.9, vec3(0, 0, 0), vec3(1), 1),
    Sphere(30, vec3(20, 50, 50), vec3(1), 0)
);

const int light_amount = 2;
Sphere lights[light_amount] = Sphere[](
    Sphere(2, vec3(30,10,20), vec3(1), 0),
    Sphere(2, vec3(-20,40,20), vec3(1, 0.5, 0.5), 0)
);
