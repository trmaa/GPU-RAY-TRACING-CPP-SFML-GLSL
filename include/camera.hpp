#ifndef CAMERA_HPP
#define CAMERA_HPP

#include "SFML/Window/Keyboard.hpp"
#include <SFML/Graphics.hpp>
#include <cmath>

class Camera {
private:
    sf::Vector3f _position;
    sf::Vector3f _angle;

    float _speed;
    float _mouseSensitivity;

public:
    sf::Vector3f position() const { return _position; }
    sf::Vector3f angle() const { return _angle; }

public:
    Camera()
        : _position(0, 0, -15), _angle(0, 0, 0), _speed(8.f), _mouseSensitivity(0.2f) {}
    ~Camera() = default;

    void move(const float& dt) {
        float fixedSpeed = _speed * dt;
        if (sf::Keyboard::isKeyPressed(sf::Keyboard::LControl)) {
            fixedSpeed *= 10;
        }

        if (sf::Keyboard::isKeyPressed(sf::Keyboard::W)) {
            _position.x += std::sin(_angle.y) * fixedSpeed;
            _position.z += std::cos(_angle.y) * fixedSpeed;
        }

        if (sf::Keyboard::isKeyPressed(sf::Keyboard::S)) {
            _position.x -= std::sin(_angle.y) * fixedSpeed;
            _position.z -= std::cos(_angle.y) * fixedSpeed;
        }

        if (sf::Keyboard::isKeyPressed(sf::Keyboard::A)) {
            _position.x += std::sin(_angle.y - 3.14159f / 2) * fixedSpeed;
            _position.z += std::cos(_angle.y - 3.14159f / 2) * fixedSpeed;
        }

        if (sf::Keyboard::isKeyPressed(sf::Keyboard::D)) {
            _position.x += std::sin(_angle.y + 3.14159f / 2) * fixedSpeed;
            _position.z += std::cos(_angle.y + 3.14159f / 2) * fixedSpeed;
        }

        if (sf::Keyboard::isKeyPressed(sf::Keyboard::Space)) {
            _position.y += fixedSpeed;
        }

        if (sf::Keyboard::isKeyPressed(sf::Keyboard::LShift)) {
            _position.y -= fixedSpeed;
        }
    }

    void handleMouseMovement(const sf::Vector2i& mouseDelta) {
        _angle.y += mouseDelta.x * _mouseSensitivity * 0.0174533f;
        _angle.x -= mouseDelta.y * _mouseSensitivity * 0.0174533f;

        const float maxPitch = 89.0f * 0.0174533f;
        if (_angle.x > maxPitch) _angle.x = maxPitch;
        if (_angle.x < -maxPitch) _angle.x = -maxPitch;
    }
};

#endif
