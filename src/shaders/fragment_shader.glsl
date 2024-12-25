#version 330 core

uniform vec2 screenSize;

void main() {
    vec2 uv = (gl_FragCoord.xy / screenSize) * 2.0 - 1.0;

    float radius = 0.5;
    vec2 centre = vec2(0.0);

    vec3 col = vec3(0.0);

    if (length(uv - centre) <= radius) {
        col = vec3(uv.x, uv.y, 0.2);
    }

    gl_FragColor = vec4(col, 1.0);
}
