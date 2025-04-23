-- EVALUACION PRACTICA

-- ALUMNO : (Andrés Díaz)
-- FECHA : 23-04-2025

/*
Los ejercicios se organizan en dos bloques, segun su dificultad.
Hay por tanto dos niveles de puntuacion: 0.50 y 1.00 puntos.
La resolucion de cada ejercicio se valora siguiendo este criterio:

* Ejercicio perfectamente resuelto o con algun error no relevante: 100%.
* Ejercicio bien planteado pero no resuelto, con algun error importante 
o varios errores leves, pero que no afecten a la comprension global del tema: 50%.
* Ejercicio no resuelto o con errores graves, que muestren falta de comprension
del tema : 0%.

Por tanto:

* un ejercicio bien resuelto del bloque 1 valdra : 0.50 x 100% = 0.50 puntos
* un ejercicio con algun error importante del bloque 2 valdra : 1.00 x 50% = 0.50 puntos

NOTA IMPORTANTE #1: No debes 'hardcodear' los ids, es decir, introducirlos a mano después de mirar las tablas. 
Si los necesitas, han de ser el resultado de alguna consulta.

NOTA IMPORTANTE #2 : Debe entregarse solo este fichero sin la base de datos y sin comprimir,
de este modo :  UF_1845_AP_TuNombre_TuAPellido.sql

*/

/*
EJERCICIO #1 : 0.50 puntos
Crea una tabla llamada 'genero'.
Debe tener una columna llamada 'id' de tipo entero, que sea la clave primaria y autoincremental.
Debe tener otra columna llamada 'genero' de tipo varchar(10) que no puede ser nula.
*/
-- Realizamos un DROP de la BBDD por un error en el fichero de importación
-- DROP DATABASE cine;

-- Realizado
-- Utilizamos CREATE TABLE con las especificaciones
USE genero;
CREATE TABLE IF NOT EXISTS genero (
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
genero varchar(10) NOT NULL
);

/*
EJERCICIO #2 : 0.50 puntos
Introduce en la tabla genero los siguientes datos:
1. 'mujer'
2. 'hombre'
3. 'otro'
4. 'no especificado'
*/
-- Realizado
-- Realizamos un Insert de los datos suministrados
INSERT INTO genero (genero)
VALUES 
('mujer'),
('hombre'),
('otro'),
('no especificado')
;

-- El último dato queda truncado por exceder el tamaño máximo del campo, procedemos a ampliarlo y a reparar el dato
-- ALTER TABLE genero MODIFY COLUMN genero varchar(20) NOT NULL;
-- UPDATE genero SET genero = "no especificado" WHERE genero LIKE "no%";
-- DESCRIBE genero;
-- SELECT genero FROM genero; 


/*
EJERCICIO #3 : 0.50 puntos
Crea una constraint entre la tabla 'personajes' y la tabla 'genero'.
La constraint se llamará 'fk_genero' y será de tipo foranea.
La columna de la tabla 'personajes' que se relaciona con la tabla 'genero' es 'genero'.
La columna de la tabla 'genero' que se relaciona con la tabla 'personajes' es 'id'.
En caso de borrado en cascada de la tabla 'genero', se no borrarán los personajes que tengan ese género. 
La relación es de uno a muchos, es decir, un género puede tener varios personajes, pero un personaje solo puede tener un género.
*/
-- Realizado
-- Procedemos a crear la constraint tal como se nos pide
ALTER TABLE people
ADD CONSTRAINT fk_genero
FOREIGN KEY (genero)
REFERENCES genero (id)
ON DELETE RESTRICT
ON UPDATE RESTRICT
;

/*
EJERCICIO #4 : 0.50 puntos
Muestra solo las actrices.
Ha de aparecer apellido, nombre, fecha_nacimiento
Ordenadas por apellido y nombre, descendente 
*/
-- Realizado
-- Utilizamos un JOIN para poder obtener la profesión "actuacion" y un select anidado para obtener el id de "mujer"
-- después ordenamos y mostramos los resultados tal como se solicita
SELECT pe.apellido, pe.nombre, pe.fecha_nacimiento 
FROM people pe
JOIN profesion pr
ON pe.profesion = pr.id_profesion
WHERE genero =
(SELECT id FROM genero WHERE genero = 'mujer') AND pr.profesion = 'actuacion'
ORDER BY apellido, nombre DESC;
-- SELECT apellido, nombre, fecha_nacimiento  FROM cine.people WHERE profesion = 2 AND genero = 1 order by apellido desc;

/*
EJERCICIO #5 : 0.50 puntos
Muestra solo los personajes nacidos en el siglo XIX (piensa entre qué años).
Debe aparecer : nombre y apellido juntos como 'personajes nacidos en el siglo XIX'
ordenados por profesión y nombre ascendente.
*/
-- Realizado
-- Realizamos la consulta utilizando concat_ws para "unir" los nombres tal como nos solicitan e indicamos el nombre que queremos en dicha columna
-- unimos con la tabla profesión para obtener el nombre de la misma y poder ordenar alfabéticamente tal como nos piden
SELECT concat_ws(" ", pe.nombre, pe.apellido) AS 'Personajes nacidos en el siglo XIX' -- , pr.profesion
FROM people pe
JOIN profesion pr
ON pe.profesion = pr.id_profesion
WHERE fecha_nacimiento 
BETWEEN 1800 AND 1899
ORDER BY pr.profesion, pe.nombre ASC;
-- SELECT * FROM cine.people ORDER BY fecha_nacimiento ASC;

/*
EJERCICIO #6 : 0.50 puntos
Muestro solo la información del personaje dedicado a la música con la 
fecha de nacimiento más reciente. Todos los datos, excepto el id.
*/
-- Realizado
-- 
SELECT pe.nombre, pe.apellido, pr.profesion, ge.genero, pe.oscars, pe.fecha_nacimiento
FROM people pe
JOIN genero ge
ON pe.genero = ge.id
JOIN profesion pr
ON pe.profesion = pr.id_profesion
WHERE pe.profesion = (SELECT id_profesion FROM profesion WHERE profesion = 'musica')
AND pe.fecha_nacimiento = (SELECT fecha_nacimiento FROM people WHERE profesion = (SELECT id_profesion FROM profesion WHERE profesion = 'musica') ORDER BY fecha_nacimiento DESC LIMIT 1)
;

-- SELECT id_profesion FROM profesion WHERE profesion = 'musica';
-- SELECT fecha_nacimiento FROM people ORDER BY fecha_nacimiento DESC LIMIT 1;
-- SELECT fecha_nacimiento FROM people WHERE profesion = (SELECT id_profesion FROM profesion WHERE profesion = 'musica') ORDER BY fecha_nacimiento DESC LIMIT 1;
-- SELECT nombre, apellido, profesion, genero, oscars, fecha_nacimiento FROM people WHERE profesion = (SELECT id_profesion FROM profesion WHERE profesion = 'musica') ORDER BY fecha_nacimiento DESC;

/*
EJERCICIO #7 : 0.50 puntos
Personas dedicadas a la interpretación (de cualquier género) que únicamente han ganado un Óscar.
Ha de aparecer el nombre y el apellido combinados como 'actores que solo han ganado un oscar' y el género
Ordenados por apellido en forma ascendente.
*/
-- Realizado
-- Ralizamos la concatenación del nombre y el apellido, unimos con la tabla genero
-- filtramos por los que tengan 1 oscar, con un select anidado filtramos por los que son actores
-- finalmente ordenamos por el apellidos ascendentemente
SELECT concat_ws(" ", pe.nombre, pe.apellido) AS 'Actores que solo han ganado un oscar', ge.genero
FROM people pe
JOIN genero ge 
ON pe.genero = ge.id 
WHERE oscars = 1 
AND pe.profesion = (SELECT id_profesion FROM profesion WHERE profesion = 'actuacion')
ORDER BY apellido ASC ;

/*
EJERCICIO #8 : 0.50 puntos
Muestra cuántos personajes no han ganado nunca un Óscar. 
Debe aparecer solo la cantidad de personajes.
*/
-- Realizado
-- Realizamos un select que cuenta los id que filtramos por los que tienen oscar = 0
-- Lo mostramos como Cantidad de personajes
SELECT count(id_people) AS 'Cantidad de personajes' FROM people WHERE oscars = 0 ;

/*
EJERCICIO #9 : 0.50 puntos
Borra de la lista el personaje:  "Arthur Rubinstein"
*/
-- Realizado
-- Borramos utilizando una concatenación en el filtro del nombre y el apellido
DELETE FROM people WHERE concat_ws(" ", nombre, apellido) = "Arthur Rubinstein";
-- SELECT * FROM people WHERE concat_ws(" ", nombre, apellido) = "Arthur Rubinstein";

/*
EJERCICIO #10 : 0.50 puntos
La fecha de nacimiento de "John Williams" está mal, ya que debe ser 1932. Cámbiala.
*/
-- Realizado
-- Actualizamos la fecha utilizando una concatenacion de nombre y apellido
UPDATE people
SET fecha_nacimiento = 1932
WHERE concat_ws(" ", nombre, apellido) = "John Williams";
-- SELECT * FROM people WHERE concat_ws(" ", nombre, apellido) = "John Williams";

/*
EJERCICIO #11 : 0.50 puntos
Muestra que director que no ha ganado ningún Óscar es el que tiene la fecha de nacimiento más antigua.
Debe aparecer el nombre completo del director y su profesión
*/
-- Realizado
-- Unimos las tablas con un join para poder sacar el nombre de la profesión
-- Seleccionamos la profesión a través de un select anidado para poder comparar con el id
-- Seleccionamos la fecha más antigua a través de un select anidado para poder comparar
SELECT concat_ws(" ", nombre, apellido) AS 'Nombre director', pr.profesion -- , pe.oscars, pe.fecha_nacimiento
FROM people pe
JOIN profesion pr
ON pe.profesion = pr.id_profesion
WHERE pe.profesion = (SELECT id_profesion FROM profesion WHERE profesion = 'direccion')
AND oscars = 0 
AND fecha_nacimiento = (SELECT fecha_nacimiento FROM people WHERE profesion = 1 AND oscars = 0 ORDER BY fecha_nacimiento ASC LIMIT 1)
;
-- SELECT id_profesion FROM profesion WHERE profesion = 'direccion';
-- SELECT fecha_nacimiento FROM people WHERE profesion = 1 AND oscars = 0 ORDER BY fecha_nacimiento ASC LIMIT 1;
-- SELECT nombre, apellido, profesion, oscars, fecha_nacimiento FROM people WHERE profesion = 1 AND oscars = 0 ORDER BY fecha_nacimiento ASC;

/*
EJERCICIO #12 : 0.50 puntos
Muestra sólo las personas dedicadas a la interpretación de género masculino nacidas entre 1920 y 1940
Ha de aparecer : nombre, apellido, profesión y la fecha de nacimiento como 'nacimiento'
Ordenado por la fecha de nacimiento en forma descendente.
*/
-- Realizado
-- Unimos las tablas de people y profesion para poder tener el literal de la profesión
-- luego filtramos con unos select anidados para obtener los resultados solicitados
-- finalmente ordenamos por la fecha de nacimiento descendentemente
SELECT pe.nombre, pe.apellido, pr.profesion, pe.fecha_nacimiento AS Nacimiento
FROM people pe
JOIN profesion pr
ON pe.profesion = pr.id_profesion
WHERE pe.profesion = (SELECT id_profesion FROM profesion WHERE profesion = 'actuacion') 
AND pe.genero = (SELECT id FROM genero WHERE genero = 'hombre')
AND fecha_nacimiento 
BETWEEN 1920 AND 1940 
ORDER BY fecha_nacimiento DESC;

-- SELECT id FROM genero WHERE genero = 'hombre';
-- SELECT id_profesion FROM profesion WHERE profesion = 'actuacion';
-- SELECT * FROM people WHERE profesion = 2 AND genero = 2 AND fecha_nacimiento BETWEEN 1920 AND 1940 ORDER BY fecha_nacimiento DESC;
/*
EJERCICIO #13 : 1.00 puntos
Muestra los personajes que han ganado más Óscars, pero sólo los que están en primera posición.
Debe aparecer nombre, apellido y profesión
Ordenados por apellido descendente
*/
-- Realizado
-- Unimos las tablas people y profesion para obtener el literal de profesion
-- filtramos con una querie anidada por los personajes con más oscars
-- ordenamos por apellido descendentemente
SELECT pe.nombre, pe.apellido, pr.profesion -- , pe.oscars
FROM people pe
JOIN profesion pr
ON pe.profesion = pr.id_profesion
WHERE oscars = (SELECT oscars FROM people ORDER BY oscars DESC LIMIT 1)
ORDER BY apellido DESC;

-- SELECT oscars FROM people ORDER BY oscars DESC LIMIT 1;
-- SELECT nombre, apellido, profesion, oscars FROM people ORDER BY oscars DESC;
/*
EJERCICIO #14 : 1.00 puntos
¿Cuántos personajes hay de cada género?
La respuesta debe ser : 'Hay X mujeres, Y hombres y Z otros' como 'Genero de los personajes'
*/
-- Realizado
-- Procedemos a concatenar distintas queries y literales, después especificamos un nombre de campo
SELECT concat(
"Hay", " ",
(SELECT count(pe.id_people) FROM people pe JOIN genero ge ON pe.genero = ge.id WHERE ge.genero = 'mujer'), " ",
 "mujeres,", " ", 
 (SELECT count(pe.id_people) AS hombres FROM people pe JOIN genero ge ON pe.genero = ge.id WHERE ge.genero = 'hombre'), " ",
 "hombres,", " y ",
 (SELECT count(pe.id_people) AS otros FROM people pe JOIN genero ge ON pe.genero = ge.id WHERE ge.genero = 'otro'), " ",
 "otros"
 ) AS 'Genero de los personajes'
 ;
-- SELECT count(pe.id_people) AS mujeres FROM people pe JOIN genero ge ON pe.genero = ge.id WHERE ge.genero = 'mujer';
-- SELECT count(pe.id_people) AS hombres FROM people pe JOIN genero ge ON pe.genero = ge.id WHERE ge.genero = 'hombre';
-- SELECT count(pe.id_people) AS otros FROM people pe JOIN genero ge ON pe.genero = ge.id WHERE ge.genero = 'otro';

-- SELECT count(id_people) FROM people WHERE genero = 1; -- (9)
-- SELECT count(id_people) FROM people WHERE genero = 2; -- (12)
-- SELECT count(id_people) FROM people WHERE genero = 3; -- (2)
/*
EJERCICIO #15 : 1.00 puntos
Crea un procedimiento almacenado para añadir personajes a la base de datos.
Se llamará st_poblar_bd 
Los parámetros serán : nombre, apellido, profesion, genero, oscars y fecha de nacimiento

Pruébalo con estos ejemplos:
st_poblar_bd('Groucho', 'Marx', 'actuacion', 'hombre', 1, 1980);
st_poblar_bd('Howard', 'Shore', 'musica', 'hombre', 1, 1946);

nombre collate utf8mb4_general_ci = sp_nombre

*/

/*
REALIZAR CORRECTAMENTE LA ENTREGA DE LOS EJERCICIOS
SEGÚN LAS INSTRUCCIONES INDICADAS : 0.50 puntos
*/








