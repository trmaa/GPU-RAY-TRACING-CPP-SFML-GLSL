const int sphere_amount = 2;
Sphere spheres[sphere_amount] = Sphere[](
    Sphere(30, vec3(0, -31.1, 0), vec3(0, 1, 0), 1),
    Sphere(1, vec3(1, 0, -1), vec3(1, 0, 0), 1)
);

const int light_amount = 1;
Sphere lights[light_amount] = Sphere[](
    Sphere(5, vec3(120,110,-100), vec3(1), 0)
);

const int triangle_amount = 12;
Triangle trianglez[triangle_amount] = Triangle[](
    Triangle(vec3(-3.0,-1.0,1.0), vec3(0.0,2.0,0.0), vec3(0.0,2.0,-2.0), vec3(1, 1, 0), 1),
    Triangle(vec3(-3.0,-1.0,1.0), vec3(0.0,2.0,-2.0), vec3(0.0,0.0,-2.0), vec3(1, 1, 0), 1),
    Triangle(vec3(-3.0,-1.0,-1.0), vec3(0.0,2.0,0.0), vec3(2.0,2.0,0.0), vec3(1, 1, 0), 1),
    Triangle(vec3(-3.0,-1.0,-1.0), vec3(2.0,2.0,0.0), vec3(2.0,0.0,0.0), vec3(1, 1, 0), 1),
    Triangle(vec3(-1.0,-1.0,-1.0), vec3(0.0,2.0,0.0), vec3(0.0,2.0,2.0), vec3(1, 1, 0), 1),
    Triangle(vec3(-1.0,-1.0,-1.0), vec3(0.0,2.0,2.0), vec3(0.0,0.0,2.0), vec3(1, 1, 0), 1),
    Triangle(vec3(-1.0,-1.0,1.0), vec3(0.0,2.0,0.0), vec3(-2.0,2.0,0.0), vec3(1, 1, 0), 1),
    Triangle(vec3(-1.0,-1.0,1.0), vec3(-2.0,2.0,0.0), vec3(-2.0,0.0,0.0), vec3(1, 1, 0), 1),
    Triangle(vec3(-3.0,-1.0,-1.0), vec3(2.0,0.0,0.0), vec3(2.0,0.0,2.0), vec3(1, 1, 0), 1),
    Triangle(vec3(-3.0,-1.0,-1.0), vec3(2.0,0.0,2.0), vec3(0.0,0.0,2.0), vec3(1, 1, 0), 1),
    Triangle(vec3(-1.0,1.0,-1.0), vec3(-2.0,0.0,0.0), vec3(-2.0,0.0,2.0), vec3(1, 1, 0), 1),
    Triangle(vec3(-1.0,1.0,-1.0), vec3(-2.0,0.0,2.0), vec3(0.0,0.0,2.0), vec3(1, 1, 0), 1)
);
