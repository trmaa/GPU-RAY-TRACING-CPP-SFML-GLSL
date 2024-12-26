#ifndef WINDOW_HPP
#define WINDOW_HPP

#include <SFML/Graphics.hpp>
#include <string>
#include "camera.hpp"

class Window: public sf::RenderWindow {
private:
	int _width;
	int _height;
	std::string _title;

	sf::Font _font;
	sf::Text _fps_text;

	sf::Shader _shader;
	sf::RectangleShape _screen;

public:
	const int& width() { return this->_width; }
	const int& height() { return this->_height; }

public:
	Window(int w, int h, std::string title):
		_width(w), _height(h), _title(title) {
		this->create(sf::VideoMode(this->_width, this->_height), this->_title);

		this->_font.loadFromFile("./bin/fonts/pixelmix.ttf");
		this->_fps_text.setFont(this->_font);
		this->_fps_text.setCharacterSize(50);
		this->_fps_text.setFillColor(sf::Color::White);
		this->_fps_text.setPosition(10, 10);

		std::system("python3 ./src/shaders/compiler.py");
		this->_shader.loadFromFile("./src/shaders/compiled_shader.glsl", sf::Shader::Fragment);
		this->_shader.setUniform("screen_size", sf::Vector2f(this->getSize()));

		sf::RectangleShape s(sf::Vector2f(this->_width, this->_height));
		this->_screen = s;
		this->_screen.setPosition(0, 0);
	}

	void repaint(const float& dt, Camera camera) {
        this->clear();

		this->_shader.setUniform("cam_pos", camera.position());
		this->_shader.setUniform("cam_dir", camera.angle());
        this->draw(this->_screen, &this->_shader);

		this->_fps_text.setString(std::to_string(1.f/dt));
        this->draw(this->_fps_text);

        this->display();
	}
};

#endif
