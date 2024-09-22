create DATABASE universidad;
USE universidad;

-- Create usuario table
CREATE TABLE usuario (
    id INTEGER PRIMARY KEY auto_increment,
    nombre VARCHAR(255),
    apellido VARCHAR(255),
    newAttr INTEGER,
    email VARCHAR(255),
    contraseña VARCHAR(255),
    tipo VARCHAR(255)
);

-- Create carrera table
CREATE TABLE carrera (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(255),
    descripcion VARCHAR(255)
);

-- Create alumno table
CREATE TABLE alumno (
    id INTEGER PRIMARY KEY,
    carrera_id INTEGER,
    usuario_id INTEGER,
    FOREIGN KEY (carrera_id) REFERENCES carrera(id),
    FOREIGN KEY (usuario_id) REFERENCES usuario(id)
);

-- Create especialidad table
CREATE TABLE especialidad (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(255)
);

-- Create profesor table
CREATE TABLE profesor (
    id INTEGER PRIMARY KEY,
    id_especialidad INTEGER,
    activo CHAR(1),
    FOREIGN KEY (id) REFERENCES usuario(id),
    FOREIGN KEY (id_especialidad) REFERENCES especialidad(id)
);

-- Create administrador table
CREATE TABLE administrador (
    id INTEGER PRIMARY KEY,
    usuario_id INTEGER,
    fecha_contratacion DATE,
    departamento VARCHAR(255),
    FOREIGN KEY (usuario_id) REFERENCES usuario(id)
);

-- Create profesor_especialidad table
CREATE TABLE profesor_especialidad (
    id INTEGER PRIMARY KEY,
    id_profesor INTEGER,
    id_especialidad INTEGER,
    FOREIGN KEY (id_profesor) REFERENCES profesor(id),
    FOREIGN KEY (id_especialidad) REFERENCES especialidad(id)
);

-- Create periodo_academico table
CREATE TABLE periodo_academico (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(255),
    fecha_inicio DATE,
    fecha_fin DATE
);

-- Create horario table
CREATE TABLE horario (
    id INTEGER PRIMARY KEY,
    dia INTEGER,
    hora_inicio TIME,
    hora_fin TIME
);

-- Create grupo table
CREATE TABLE grupo (
    id INTEGER PRIMARY KEY,
    id_estudiante INTEGER,
    id_periodo INTEGER,
    cupo INTEGER,
    id_horario INTEGER,
    FOREIGN KEY (id_estudiante) REFERENCES alumno(id),
    FOREIGN KEY (id_periodo) REFERENCES periodo_academico(id),
    FOREIGN KEY (id_horario) REFERENCES horario(id)
);

-- Create inscripcion table
CREATE TABLE inscripcion (
    id INTEGER PRIMARY KEY,
    id_alumno INTEGER,
    id_grupo INTEGER,
    fecha_inscripcion DATE,
    estado_inscripcion VARCHAR(255),
    observaciones TEXT,
    FOREIGN KEY (id_alumno) REFERENCES alumno(id),
    FOREIGN KEY (id_grupo) REFERENCES grupo(id)
);

-- Create aula table
CREATE TABLE aula (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(255),
    capacidad INTEGER,
    tipo CHAR(1),
    activo CHAR(1)
);

-- Create calificacion table
CREATE TABLE calificacion (
    id INTEGER PRIMARY KEY,
    matricula_id INTEGER,
    nota FLOAT,
    estado CHAR(1),
    FOREIGN KEY (matricula_id) REFERENCES inscripcion(id)
);

-- Create facultad table
CREATE TABLE facultad (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(255),
    valor_decano VARCHAR(255)
);

-- Create alumno_carrera table
CREATE TABLE alumno_carrera (
    id INTEGER PRIMARY KEY,
    id_carrera INTEGER,
    id_alumno INTEGER,
    FOREIGN KEY (id_carrera) REFERENCES carrera(id),
    FOREIGN KEY (id_alumno) REFERENCES alumno(id)
);

-- Create asignatura table
CREATE TABLE asignatura (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(255),
    creditos VARCHAR(255),
    tipo CHAR(1)
);

-- Create plan_estudio table
CREATE TABLE plan_estudio (
    id INTEGER PRIMARY KEY,
    id_asignatura INTEGER,
    id_carrera INTEGER,
    horasTotales INTEGER,
    FOREIGN KEY (id_asignatura) REFERENCES asignatura(id),
    FOREIGN KEY (id_carrera) REFERENCES carrera(id)
);
-- privilegios y creacion de usuarios base de datos 
-- Crear el usuario 'admin' con contraseña 'admin_password'
CREATE USER 'diego'@'localhost' IDENTIFIED BY '123456789';

-- Conceder todos los privilegios sobre la base de datos 'universidad2' al usuario 'admin'
GRANT ALL PRIVILEGES ON universidad.* TO 'admin'@'localhost';

-- Crear el usuario 'read_only_user' con contraseña 'read_only_password'
CREATE USER 'bruno'@'localhost' IDENTIFIED BY 'read_only_password';

-- Conceder privilegios de solo lectura a la tabla 'alumno' en la base de datos 'universidad2' al usuario 'read_only_user'
GRANT SELECT ON universidad.alumno TO 'read_only_user'@'localhost';

-- Actualizar los permisos para que los cambios surtan efecto
FLUSH PRIVILEGES;

-- Procedimientos almacenados...
DELIMITER //

-- Insertar un nuevo usuario
CREATE PROCEDURE sp_insert_usuario(
    IN p_nombre VARCHAR(255),
    IN p_apellido VARCHAR(255),
    IN p_newAttr INTEGER,
    IN p_email VARCHAR(255),
    IN p_contraseña VARCHAR(255),
    IN p_tipo VARCHAR(255)
)
BEGIN
    INSERT INTO usuario (nombre, apellido, newAttr, email, contraseña, tipo)
    VALUES (p_nombre, p_apellido, p_newAttr, p_email, p_contraseña, p_tipo);
END //

-- Actualizar un usuario existente
CREATE PROCEDURE sp_update_usuario(
    IN p_id INTEGER,
    IN p_nombre VARCHAR(255),
    IN p_apellido VARCHAR(255),
    IN p_newAttr INTEGER,
    IN p_email VARCHAR(255),
    IN p_contraseña VARCHAR(255),
    IN p_tipo VARCHAR(255)
)
BEGIN
    UPDATE usuario
    SET nombre = p_nombre, apellido = p_apellido, newAttr = p_newAttr, 
        email = p_email, contraseña = p_contraseña, tipo = p_tipo
    WHERE id = p_id;
END //

-- Eliminar un usuario por id
CREATE PROCEDURE sp_delete_usuario(IN p_id INTEGER)
BEGIN
    DELETE FROM usuario WHERE id = p_id;
END //

-- Consultar un usuario por id
CREATE PROCEDURE sp_get_usuario(IN p_id INTEGER)
BEGIN
    SELECT * FROM usuario WHERE id = p_id;
END //

DELIMITER ;
DELIMITER //

-- Insertar una nueva carrera
CREATE PROCEDURE sp_insert_carrera(
    IN p_nombre VARCHAR(255),
    IN p_descripcion VARCHAR(255)
)
BEGIN
    INSERT INTO carrera (nombre, descripcion)
    VALUES (p_nombre, p_descripcion);
END //

-- Actualizar una carrera existente
CREATE PROCEDURE sp_update_carrera(
    IN p_id INTEGER,
    IN p_nombre VARCHAR(255),
    IN p_descripcion VARCHAR(255)
)
BEGIN
    UPDATE carrera
    SET nombre = p_nombre, descripcion = p_descripcion
    WHERE id = p_id;
END //

-- Eliminar una carrera por id
CREATE PROCEDURE sp_delete_carrera(IN p_id INTEGER)
BEGIN
    DELETE FROM carrera WHERE id = p_id;
END //

-- Consultar una carrera por id
CREATE PROCEDURE sp_get_carrera(IN p_id INTEGER)
BEGIN
    SELECT * FROM carrera WHERE id = p_id;
END //

DELIMITER ;
DELIMITER //

-- Insertar un nuevo alumno
CREATE PROCEDURE sp_insert_alumno(
    IN p_carrera_id INTEGER,
    IN p_usuario_id INTEGER
)
BEGIN
    INSERT INTO alumno (carrera_id, usuario_id)
    VALUES (p_carrera_id, p_usuario_id);
END //

-- Actualizar un alumno existente
CREATE PROCEDURE sp_update_alumno(
    IN p_id INTEGER,
    IN p_carrera_id INTEGER,
    IN p_usuario_id INTEGER
)
BEGIN
    UPDATE alumno
    SET carrera_id = p_carrera_id, usuario_id = p_usuario_id
    WHERE id = p_id;
END //

-- Eliminar un alumno por id
CREATE PROCEDURE sp_delete_alumno(IN p_id INTEGER)
BEGIN
    DELETE FROM alumno WHERE id = p_id;
END //

-- Consultar un alumno por id
CREATE PROCEDURE sp_get_alumno(IN p_id INTEGER)
BEGIN
    SELECT * FROM alumno WHERE id = p_id;
END //

DELIMITER ;
DELIMITER //

-- Insertar una nueva especialidad
CREATE PROCEDURE sp_insert_especialidad(
    IN p_nombre VARCHAR(255)
)
BEGIN
    INSERT INTO especialidad (nombre)
    VALUES (p_nombre);
END //

-- Actualizar una especialidad existente
CREATE PROCEDURE sp_update_especialidad(
    IN p_id INTEGER,
    IN p_nombre VARCHAR(255)
)
BEGIN
    UPDATE especialidad
    SET nombre = p_nombre
    WHERE id = p_id;
END //

-- Eliminar una especialidad por id
CREATE PROCEDURE sp_delete_especialidad(IN p_id INTEGER)
BEGIN
    DELETE FROM especialidad WHERE id = p_id;
END //

-- Consultar una especialidad por id
CREATE PROCEDURE sp_get_especialidad(IN p_id INTEGER)
BEGIN
    SELECT * FROM especialidad WHERE id = p_id;
END //

DELIMITER ;

-- funciones 
DELIMITER //

CREATE FUNCTION fn_avg_notas_alumno(p_alumno_id INTEGER)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE promedio FLOAT;
    SELECT AVG(nota) INTO promedio
    FROM calificacion
    JOIN inscripcion ON calificacion.matricula_id = inscripcion.id
    WHERE inscripcion.id_alumno = p_alumno_id;
    RETURN promedio;
END //

DELIMITER ;
DELIMITER //

CREATE FUNCTION fn_avg_notas_alumno(p_alumno_id INTEGER)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE promedio FLOAT;
    SELECT AVG(nota) INTO promedio
    FROM calificacion
    JOIN inscripcion ON calificacion.matricula_id = inscripcion.id
    WHERE inscripcion.id_alumno = p_alumno_id;
    RETURN promedio;
END //

DELIMITER ;
DELIMITER //

CREATE FUNCTION fn_is_profesor_activo(p_profesor_id INTEGER)
RETURNS CHAR(1)
DETERMINISTIC
BEGIN
    DECLARE activo CHAR(1);
    SELECT activo INTO activo
    FROM profesor
    WHERE id = p_profesor_id;
    RETURN activo;
END //

DELIMITER ;
DELIMITER //

CREATE FUNCTION fn_get_nombre_completo_usuario(p_usuario_id INTEGER)
RETURNS VARCHAR(510)
DETERMINISTIC
BEGIN
    DECLARE nombre_completo VARCHAR(510);
    SELECT CONCAT(nombre, ' ', apellido) INTO nombre_completo
    FROM usuario
    WHERE id = p_usuario_id;
    RETURN nombre_completo;
END //

DELIMITER ;
DELIMITER //

CREATE FUNCTION fn_total_creditos_plan(p_carrera_id INTEGER)
RETURNS INTEGER
DETERMINISTIC
BEGIN
    DECLARE total_creditos INTEGER;
    SELECT SUM(CAST(creditos AS UNSIGNED)) INTO total_creditos
    FROM asignatura
    JOIN plan_estudio ON asignatura.id = plan_estudio.id_asignatura
    WHERE plan_estudio.id_carrera = p_carrera_id;
    RETURN total_creditos;
END //

DELIMITER ;
-- vistas 
DELIMITER //

CREATE VIEW vw_alumnos_con_carrera AS
SELECT a.id AS alumno_id, 
       a.usuario_id, 
       u.nombre AS nombre_usuario, 
       u.apellido AS apellido_usuario, 
       c.nombre AS carrera_nombre
FROM alumno a
JOIN usuario u ON a.usuario_id = u.id
JOIN carrera c ON a.carrera_id = c.id;

DELIMITER ;
DELIMITER //

CREATE VIEW vw_profesores_con_especialidad AS
SELECT p.id AS profesor_id, 
       u.nombre AS nombre_usuario, 
       u.apellido AS apellido_usuario, 
       e.nombre AS especialidad_nombre, 
       p.activo
FROM profesor p
JOIN usuario u ON p.id = u.id
JOIN especialidad e ON p.id_especialidad = e.id;

DELIMITER ;
DELIMITER //

CREATE VIEW vw_historial_inscripciones AS
SELECT i.id AS inscripcion_id, 
       a.id AS alumno_id, 
       u.nombre AS nombre_alumno, 
       u.apellido AS apellido_alumno, 
       g.id AS grupo_id, 
       g.cupo, 
       i.fecha_inscripcion, 
       i.estado_inscripcion
FROM inscripcion i
JOIN alumno a ON i.id_alumno = a.id
JOIN usuario u ON a.usuario_id = u.id
JOIN grupo g ON i.id_grupo = g.id;

DELIMITER ;
DELIMITER //

CREATE VIEW vw_plan_estudio_detalle AS
SELECT p.id AS plan_id, 
       a.nombre AS asignatura_nombre, 
       c.nombre AS carrera_nombre, 
       p.horasTotales
FROM plan_estudio p
JOIN asignatura a ON p.id_asignatura = a.id
JOIN carrera c ON p.id_carrera = c.id;

DELIMITER ;

-- triggers
DELIMITER //

CREATE TRIGGER actualizar_fecha_modificacion
BEFORE UPDATE ON alumno
FOR EACH ROW
BEGIN
    SET NEW.fecha_modificacion = NOW();
END //

DELIMITER ;
DELIMITER //

CREATE TRIGGER verificar_capacidad_grupo
BEFORE INSERT ON grupo
FOR EACH ROW
BEGIN
    DECLARE capacidad_actual INT;
    DECLARE estudiantes_actuales INT;

    -- Obtener la capacidad del grupo
    SELECT capacidad INTO capacidad_actual
    FROM grupo
    WHERE id = NEW.id;

    -- Contar el número de estudiantes en el grupo
    SELECT COUNT(*) INTO estudiantes_actuales
    FROM grupo
    WHERE id = NEW.id;

    -- Verificar si la capacidad se ha excedido
    IF estudiantes_actuales >= capacidad_actual THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La capacidad del grupo se ha excedido.';
    END IF;
END //

DELIMITER ;
DELIMITER //

CREATE TRIGGER ajustar_estado_inscripcion
BEFORE UPDATE ON inscripcion
FOR EACH ROW
BEGIN
    -- Cambiar el estado a 'Cancelado' si el estado es 'Pendiente' después de cierto tiempo
    IF OLD.estado_inscripcion = 'Pendiente' AND DATEDIFF(NOW(), OLD.fecha_inscripcion) > 30 THEN
        SET NEW.estado_inscripcion = 'Cancelado';
    END IF;
END //

DELIMITER ;
DELIMITER //

CREATE TRIGGER registrar_cambio_aula
AFTER UPDATE ON aula
FOR EACH ROW
BEGIN
    INSERT INTO historial_cambios (tabla, id_registro, campo_modificado, valor_anterior, valor_nuevo, fecha_modificacion)
    VALUES ('aula', OLD.id, 'nombre', OLD.nombre, NEW.nombre, NOW());
    -- Puedes agregar más campos según sea necesario
END //

DELIMITER ;
DELIMITER //

CREATE TRIGGER eliminar_calificaciones
AFTER DELETE ON alumno
FOR EACH ROW
BEGIN
    DELETE FROM calificacion
    WHERE matricula_id IN (SELECT id FROM inscripcion WHERE id_alumno = OLD.id);
END //

DELIMITER ;
