#include "SFML/Graphics/Sprite.hpp"
#include "SFML/Graphics/Texture.hpp"
#include <SFML/System.hpp>
#include <SFML/Graphics.hpp>
#include <SFML/Window.hpp>

int main() {
	sf::RenderWindow window;
	window.create(sf::VideoMode(200,200),"Ray tracer");

	sf::Image buffer;
	buffer.create(200, 200);
	for (int j = 0; j < buffer.getSize().y; j++) {
		for (int i = 0; i < buffer.getSize().x; i++) {
			buffer.setPixel(i, j, sf::Color(
						255*i/buffer.getSize().x,
						255*j/buffer.getSize().y, 0));
		}
	}

	sf::Texture txtr;
	txtr.loadFromImage(buffer);
	txtr.setSmooth(true);

	sf::Sprite screen(txtr);
	float scale_x = (float)window.getSize().x/buffer.getSize().x;
	float scale_y = (float)window.getSize().y/buffer.getSize().y;
	screen.setScale(scale_x, scale_y);

	while (window.isOpen()) {
		sf::Event ev;
		while (window.pollEvent(ev)) {
			if (ev.type == sf::Event::Closed) {
				window.close();
			}
		}

		window.clear();
		window.draw(screen);
		window.display();
	}
}
