#version 130

in vec2 position;  // Vertex position
in vec2 texCoords; // Texture coordinates

out vec2 fragTexCoords; // Pass texture coordinates to fragment shader

void main() {
    gl_Position = vec4(position, 0.0, 1.0); // Set the vertex position
    fragTexCoords = texCoords;              // Pass texture coordinates
}
