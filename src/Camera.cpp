#include <Camera.h>


void Camera::compute() {
    eye.x = cos(theta) * sin(phi) * radius + o.x;   
    eye.y = cos(phi) * radius + o.y ;
    eye.z = sin(theta) * sin(phi) * radius + o.z;   
    up = glm::vec3(0.f, phi < M_PI ?1.f:-1.f, 0.f);
}

Camera::Camera() {
    phi = 3.14/2.f;
    theta = 3.14/2.f;
    radius = 10.f;
    compute();
}

void Camera::zoom(float factor) {
    radius += factor * radius ;
    if (radius < 0.1)
    {
        radius = 10.f;
        o = eye + glm::normalize(o - eye) * radius;
    }
    compute();
}

void Camera::turn(float phi, float theta) {
    theta += 1.f * theta;
    phi   -= 1.f * phi;
    if (phi >= (2 * M_PI) - 0.1 )
        phi = 0.00001;
    else if (phi <= 0 )
        phi = 2 * M_PI - 0.1;
    compute();
}

void Camera::pan(float x, float y) {
    glm::vec3 up(0.f, phi < M_PI ?1.f:-1.f, 0.f);
    glm::vec3 fwd = glm::normalize(o - eye);
    glm::vec3 side = glm::normalize(glm::cross(fwd, up));
    up = glm::normalize(glm::cross(side, fwd));
    o[0] += up[0] * y * radius * 2;
    o[1] += up[1] * y * radius * 2;
    o[2] += up[2] * y * radius * 2;
    o[0] -= side[0] * x * radius * 2;
    o[1] -= side[1] * x * radius * 2;
    o[2] -= side[2] * x * radius * 2;       
    compute();
}

