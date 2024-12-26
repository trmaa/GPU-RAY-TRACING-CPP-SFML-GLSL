#include <SFML/Graphics.hpp>
#include <cstdlib>
#include <string>
#include "window.hpp"
#include "camera.hpp"

int main() {
    Window window(1920, 1080, "Ray tracing");
    Camera camera;

    sf::Clock clck;
    sf::Time elapsed;
    float dt;
    while (window.isOpen()) {
        sf::Event event;
        while (window.pollEvent(event)) {
            if (event.type == sf::Event::Closed) {
                window.close();
            }
        }
        elapsed = clck.restart();
        dt = elapsed.asSeconds();

        camera.move(dt, event);
        window.repaint(dt, camera);
    }
}
