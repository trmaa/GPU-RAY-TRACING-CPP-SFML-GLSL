#include <SFML/Graphics.hpp>

int main() {
    sf::RenderWindow window(
            sf::VideoMode(800, 600),
            "Ray tracing");

    sf::Shader shader;
    if (!shader.loadFromFile("./src/shaders/fragment_shader.glsl",
                sf::Shader::Fragment)) {
        return -1;
    }
    shader.setUniform("screenSize", sf::Vector2f(window.getSize()));

    sf::RectangleShape fullscreenRect(sf::Vector2f(window.getSize().x, window.getSize().y));
    fullscreenRect.setPosition(0, 0);

    while (window.isOpen()) {
        sf::Event event;
        while (window.pollEvent(event)) {
            if (event.type == sf::Event::Closed) {
                window.close();
            }
        }

        window.clear();

        window.draw(fullscreenRect, &shader);

        window.display();
    }
}
