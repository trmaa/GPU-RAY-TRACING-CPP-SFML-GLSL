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
    Camera(): _position(0,0,-2), _angle(0,0,0), _speed(0.4f) {}
    ~Camera() = default;

public:
    void move(float& dt, sf::Event& ev) {
        float fixedSpeed = _speed * (dt);
        if (ev.type != sf::Event::KeyPressed) {
            return;
        }
        if (ev.key.code == sf::Keyboard::Up) {
            _position.x += std::sin(_angle.y) * fixedSpeed;
            _position.z += std::cos(_angle.y) * fixedSpeed;
        }
        if (ev.key.code == sf::Keyboard::Down) {
            _position.x -= std::sin(_angle.y) * fixedSpeed;
            _position.z -= std::cos(_angle.y) * fixedSpeed;
        }
        if (ev.key.code == sf::Keyboard::Left) {
            _position.x += std::sin(_angle.y - 3.14159f / 2) * fixedSpeed;
            _position.z += std::cos(_angle.y - 3.14159f / 2) * fixedSpeed;
        }
        if (ev.key.code == sf::Keyboard::Right) {
            _position.x -= std::sin(_angle.y - 3.14159f / 2) * fixedSpeed;
            _position.z -= std::cos(_angle.y - 3.14159f / 2) * fixedSpeed;
        }
        if (ev.key.code == sf::Keyboard::RControl) {
            _position.y -= fixedSpeed;
        }
        if (ev.key.code == sf::Keyboard::RShift) {
            _position.y += fixedSpeed;
        }
        if (ev.key.code == sf::Keyboard::LAlt) {
            _angle.y += 0.1f;
        }
        if (ev.key.code == sf::Keyboard::LShift) {
            _angle.y -= 0.1f;
        }
        if (ev.key.code == sf::Keyboard::LControl) {
            _angle.x += 0.1f;
        }
        if (ev.key.code == 40) {
            _angle.x -= 0.1f;
        }
    }
};

#endif
