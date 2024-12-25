#version 130

in vec2 fragTexCoords;     // Receive texture coordinates from vertex shader
out vec4 fragColor;         // Output color to the screen

uniform sampler2D texture;  // The texture we are sampling from

void main() {
    fragColor = texture2D(texture, fragTexCoords); // Sample the texture
}
