#ifndef CAMERA_HPP
#define CAMERA_HPP

#include <SFML/Graphics.hpp>
#include <cmath>

class Camera {
private:
    sf::Vector3f _position;
    sf::Vector3f _angle;

    float _speed;

public:
    sf::Vector3f position() { return this->_position; }
    sf::Vector3f angle() { return this->_angle; }

public:
    Camera(): _position(0,0,-15), _angle(0,0,0), _speed(8.f) {}
    ~Camera() = default;

public:
    void move(const float& dt, const sf::Event& event) {
        float fixedSpeed = _speed * dt;

        if (sf::Keyboard::isKeyPressed(sf::Keyboard::Up)) {
            _position.x += std::sin(_angle.y) * fixedSpeed;
            _position.z += std::cos(_angle.y) * fixedSpeed;
        }
        if (sf::Keyboard::isKeyPressed(sf::Keyboard::Down)) {
            _position.x -= std::sin(_angle.y) * fixedSpeed;
            _position.z -= std::cos(_angle.y) * fixedSpeed;
        }
        if (sf::Keyboard::isKeyPressed(sf::Keyboard::Left)) {
            _position.x += std::sin(_angle.y - 3.14159f / 2) * fixedSpeed;
            _position.z += std::cos(_angle.y - 3.14159f / 2) * fixedSpeed;
        }
        if (sf::Keyboard::isKeyPressed(sf::Keyboard::Right)) {
            _position.x -= std::sin(_angle.y - 3.14159f / 2) * fixedSpeed;
            _position.z -= std::cos(_angle.y - 3.14159f / 2) * fixedSpeed;
        }
        if (sf::Keyboard::isKeyPressed(sf::Keyboard::RControl)) {
            _position.y -= fixedSpeed;
        }
        if (sf::Keyboard::isKeyPressed(sf::Keyboard::RShift)) {
            _position.y += fixedSpeed;
        }
        if (sf::Keyboard::isKeyPressed(sf::Keyboard::LAlt)) {
            _angle.y += 0.1f*fixedSpeed;
        }
        if (sf::Keyboard::isKeyPressed(sf::Keyboard::LShift)) {
            _angle.y -= 0.1f*fixedSpeed;
        }
        if (sf::Keyboard::isKeyPressed(sf::Keyboard::LControl)) {
            _angle.x += 0.1f*fixedSpeed;
        }
        if (sf::Keyboard::isKeyPressed(static_cast<sf::Keyboard::Key>(40))) {
            _angle.x -= 0.1f*fixedSpeed;
        }
    }
};

#endif
