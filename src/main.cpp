#include <SFML/Graphics.hpp>
#include <cstdlib>
#include <string>
#include "window.hpp"
#include "camera.hpp"

int main() {
    Window window("Ray tracing");
    Camera camera;
    camera.lock_mouse(window);

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

        camera.move(dt);
        camera.handle_mouse_movement(window);

        window.repaint(dt, camera);
    }
}
