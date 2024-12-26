import os

def preprocess_shader(input_file, output_file, include_path):
    with open(input_file, 'r') as infile:
        lines = infile.readlines()

    with open(output_file, 'w') as outfile:
        for line in lines:
            if line.strip().startswith("#include"):
                include_file = line.strip().split('"')[1]
                include_full_path = os.path.join(include_path, include_file)
                if os.path.exists(include_full_path):
                    with open(include_full_path, 'r') as incfile:
                        outfile.write(incfile.read())
                        outfile.write("\n")
                else:
                    raise FileNotFoundError(f"Included file {include_file} not found.")
            else:
                outfile.write(line)

preprocess_shader("src/shaders/main.glsl", "src/shaders/compiled_shader.glsl", "src/shaders/")
