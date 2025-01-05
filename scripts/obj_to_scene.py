def parse_vertices_and_faces(obj_file):
    vertices = []
    faces = []

    with open(obj_file, 'r') as file:
        for line in file:
            parts = line.strip().split()
            if not parts:
                continue
            if parts[0] == 'v':
                vertices.append(tuple(map(float, parts[1:4])))
            elif parts[0] == 'f':
                indices = [int(p.split('/')[0]) - 1 for p in parts[1:]]
                if len(indices) == 3:
                    faces.append(indices)
                elif len(indices) == 4:
                    faces.append([indices[0], indices[1], indices[2]])
                    faces.append([indices[0], indices[2], indices[3]])
    return vertices, faces


def generate_triangle_lines(vertices, faces):
    return [
        f"    Triangle(vec3({v0[0]},{v0[1]},{v0[2]}), "
        f"vec3({v1[0]-v0[0]},{v1[1]-v0[1]},{v1[2]-v0[2]}), "
        f"vec3({v2[0]-v0[0]},{v2[1]-v0[1]},{v2[2]-v0[2]}), vec3(1, 1, 0), 1)"
        for face in faces
        for v0, v1, v2 in [[vertices[face[0]], vertices[face[1]], vertices[face[2]]]]
    ]


def update_scene_glsl(scene_file, triangle_lines):
    with open(scene_file, 'r') as file:
        scene_lines = file.readlines()

    new_scene_lines = []
    inside_triangle_section = False

    for line in scene_lines:
        if "const int triangle_amount" in line:
            new_scene_lines.append(f"const int triangle_amount = {len(triangle_lines)};\n")
        elif "Triangle trianglez[triangle_amount]" in line:
            new_scene_lines.append(line)
            new_scene_lines.append(",\n".join(triangle_lines))
            new_scene_lines.append("\n);\n")
            inside_triangle_section = True
        elif inside_triangle_section:
            if line.strip() == ");":
                inside_triangle_section = False
        else:
            new_scene_lines.append(line)

    with open(scene_file, 'w') as file:
        file.writelines(new_scene_lines)


def obj_to_scene(obj_file, scene_file):
    vertices, faces = parse_vertices_and_faces(obj_file)
    triangle_lines = generate_triangle_lines(vertices, faces)
    update_scene_glsl(scene_file, triangle_lines)


obj_to_scene("./bin/scene/scene.obj", "./src/shaders/scene.glsl")
