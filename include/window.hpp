#ifndef WINDOW_HPP
#define WINDOW_HPP

#include "SFML/Graphics/Image.hpp"
#include "SFML/Graphics/Shader.hpp"
#include "SFML/Graphics/Sprite.hpp"
#include "SFML/Graphics/Texture.hpp"

class Window {
private:
	sf::Shader _shader;

	sf::Texture _texture;
	sf::Sprite _sprite;
	sf::Image _buffer;

public:

};

#endif
