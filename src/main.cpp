#include <SFML/Graphics.hpp>
#include <cstdlib>
#include <string>
#include "window.hpp"
#include "camera.hpp"

int main() {
    Window window("Ray tracing");
    Camera camera;

    sf::Clock clck;
    sf::Time elapsed;
    float dt;
    sf::Vector2i lastMousePosition = sf::Mouse::getPosition(window);
    while (window.isOpen()) {
        sf::Event event;
        while (window.pollEvent(event)) {
            if (event.type == sf::Event::Closed) {
                window.close();
            }
        }
        elapsed = clck.restart();
        dt = elapsed.asSeconds();

        camera.move(dt);

        sf::Vector2i currentMousePosition = sf::Mouse::getPosition(window);
        sf::Vector2i mouseDelta = currentMousePosition - lastMousePosition;
        lastMousePosition = currentMousePosition;
        camera.handleMouseMovement(mouseDelta);

        window.repaint(dt, camera);
    }
}
