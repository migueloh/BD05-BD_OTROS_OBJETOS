/*
Tareas_a_realizar_otros_objetos_practica

POR MIGUEL OLMO HERNANDO

*/

-- 2�.- Crea una tabla que sea igual que la tabla DEPART denominada DEPARTSEQ

-- CAMBIO TAMBIEN EL NOMBRE DE LAS CONSTRAINTS PARA QUE NO ME DEN PROBLEMAS
REM ******** TABLA DEPART: *********** 

DROP TABLE DEPARTSEQ CASCADE CONSTRAINTS; 

CREATE TABLE DEPARTSEQ (
 	DEPT_NO  NUMBER(2),
	DNOMBRE  VARCHAR2(14), 
 	LOC      VARCHAR2(14),
CONSTRAINT DEPSEQ_PK PRIMARY KEY (DEPT_NO)
  );


/*
3�.- Crea una secuencia para utilizarla con la columna de clave primaria de la tabla DEPARTSEQ. 
La secuencia debe comenzar en 200 y tener un valor m�ximo de 1000. Haz que la secuencia aumente 
en diez n�meros cada vez. Asigna a la secuencia el nombre DEPT_ID_SEQ. Comprueba en el diccionario 
de datos que el objeto se ha creado correctamente.
*/

CREATE SEQUENCE DEPT_ID_SEQ
  START WITH 200
  INCREMENT BY 10 
  MAXVALUE 1000 
  --MINVALUE 200
  NOCYCLE; 
  
DROP SEQUENCE DEPT_ID_SEQ;
--NO SE SI HAY QUE INICIAR LA SECUENCIA PERO POR SI ACASO:
SELECT DEPT_ID_SEQ.NEXTVAL 
  FROM DUAL;
  
--COMPRUEBO SI SE HA INICIADO LA SECUENCIA HACIENDO QUE RETORNE SU VALOR
SELECT DEPT_ID_SEQ.CURRVAL
  FROM DUAL;

-- COMPRUEBO EN EL DICCIONARIO DE DATOS 
SELECT * FROM ALL_SEQUENCES
  WHERE SEQUENCE_NAME='DEPT_ID_SEQ';
  
-- POR SI QUIERO BORRAR LA SECUENCIA
DROP SEQUENCE DEPT_ID_SEQ;
  
/*
CREATE SEQUENCE nombre_secuencia 
[INCREMENT BY n] [START WITH n] 
[ { MAXVALUE n] | NOMAXVALUE} ] 
[ { MINVALUE n] | NOMINVALUE } ] 
[ { CYCLE] | NOCYCLE } ] 
[ { CACHE n] | NOCACHE } ]
*/


/*
4�.- Consulta en el diccionario de datos acerca de tus secuencias. Obt�n la siguiente informaci�n: 
nombre de secuencia, valor m�ximo, tama�o de aumento y �ltimo n�mero. 
*/

SELECT SEQUENCE_NAME, MAX_VALUE, INCREMENT_BY, LAST_NUMBER 
  FROM USER_SEQUENCES;

/*
5�.- Escribe un archivo de comandos para insertar dos filas en la tabla DEPARTASEQ. 
Asigna al archivo de comandos el nombre lab9_4.sql. Aseg�rate de utilizar la secuencia 
que creaste anteriormente para la columna ID. 
Agrega dos departamentos llamados Educacion y Administracion. 

Ejecuta el script. Confirma las inserciones. 
*/

-- ALTERAMOS EL VALOR DE LA COLUMNA, DADO QUE LA LA ID AUTOINCREMENTAL ES DE 4 DIGITOS.

DESC DEPART

ALTER TABLE DEPARTSEQ MODIFY (
  DEPT_NO  NUMBER(4)
);

-- REALIZO LAS INSERT
INSERT INTO DEPARTSEQ VALUES (DEPT_ID_SEQ.NEXTVAL ,  'EDUCACION', 'BILBAO');
INSERT INTO DEPARTSEQ VALUES (DEPT_ID_SEQ.NEXTVAL ,  'ADMINISTRACION', 'VITORIA');
INSERT INTO DEPARTSEQ VALUES (DEPT_ID_SEQ.NEXTVAL ,  'TURISMO', 'SAN SEBASTIAN');

-- COMPRUEBO
SELECT * FROM DEPARTSEQ;

/*
6�.- Comprueba cual ser� el siguiente n�mero de departamento, que dar� la 
secuencia que has creado, al realizar la siguiente inserci�n.
*/
SELECT DEPT_ID_SEQ.CURRVAL
  FROM DUAL;


SELECT DEPT_ID_SEQ.NEXTVAL
  FROM DUAL;

  
SELECT SEQUENCE_NAME, LAST_NUMBER 
  FROM USER_SEQUENCES
  WHERE UPPER(SEQUENCE_NAME) = 'DEPT_ID_SEQ';
  
/*
7�.- Crear la tabla CENTROS teniendo en cuenta este modelo y que el modelo 
f�sico se va a implementar en un SGBD Oracle 12c: donde id ser� autoincremental  
y  constituye la clave de la tabla (utiliza GENERATED ALWAYS).

NOTA: 
Un * delante del nombre de una columna indica que el obligatorio que tenga valor. 
*/

-- PRIMERO COMPRUEBO SI EXITE EN EL DICCIONARIO ALGUNA TABLA CON EL MISMO NOMBRE CENTROS
SELECT  * 
  FROM USER_TABLES 
  WHERE UPPER(TABLE_NAME) = 'CENTROS';

-- EL ERROR QUE DA EN EL MINVALUE NO AFECTA PARA NADA A LA CREATE CON EL ID AUTOINCREMENTAL
CREATE TABLE  CENTROS (
  ID NUMBER(2) GENERATED  ALWAYS AS IDENTITY MINVALUE 1 
  MAXVALUE 99
  INCREMENT BY 1 
  START WITH 1 
  CACHE 20  
  NOORDER  
  NOCYCLE  
  NOT NULL ENABLE
  CONSTRAINT CEN_ID_PK PRIMARY KEY,
  NOMBRE VARCHAR2 (30),
  CALLE VARCHAR2 (30),
  NUMERO NUMBER (2),
  CP VARCHAR2 (5),
  CIUDAD VARCHAR2(15) CONSTRAINT CEN_CI_CK CHECK (UPPER(CIUDAD) = CIUDAD AND CIUDAD != 'TOLEDO'),
  PROVINCIA VARCHAR2(40),
  TELEFONO VARCHAR2 (9)
 );
 
 -- V2
 
 CREATE TABLE  CENTROS2 (
  ID NUMBER(2) GENERATED  ALWAYS AS IDENTITY MINVALUE 1 
  MAXVALUE 99
  INCREMENT BY 1 
  START WITH 1 
  CACHE 20  
  NOORDER  
  NOCYCLE  
  NOT NULL ENABLE,
  NOMBRE VARCHAR2 (30),
  CALLE VARCHAR2 (30),
  NUMERO NUMBER (2),
  CP VARCHAR2 (5),
  CIUDAD VARCHAR2(15),
  PROVINCIA VARCHAR2(40),
  TELEFONO VARCHAR2 (9),
CONSTRAINT CEN2_ID_PK PRIMARY KEY (ID),
CONSTRAINT CEN2_CI_CK CHECK (UPPER(CIUDAD) = CIUDAD AND CIUDAD != 'TOLEDO')
 );
 
 SELECT  * 
  FROM SYS.USER_CONSTRAINTS
  WHERE UPPER(TABLE_NAME) = 'CENTROS2';
 
 ------------------------

SELECT  * 
  FROM SYS.USER_CONSTRAINTS
  WHERE UPPER(TABLE_NAME) = 'CENTROS';

-- POR SI QUIERO ELIMINAR
DROP TABLE CENTROS CASCADE CONSTRAINTS; 
DROP TABLE CENTROS2 CASCADE CONSTRAINTS; 
 

-- 8�.- Realiza la inserci�n de un centro. Inventa los datos.

INSERT INTO CENTROS (NOMBRE, CALLE, NUMERO, CP, CIUDAD, PROVINCIA, TELEFONO )
  VALUES ('EGIBIDE ARRIAGA' , 'POZO' , 1, '01013', 'VITORIA-GASTEIZ', 'ALAVA', 945010110);

-- COMPROBACION DE LA INSERT ANTERIOR  
SELECT * FROM CENTROS;

-- 9�.- Crear un �ndice no �nico en la columna de claves ajenas (DEPT_NO) en la tabla EMPLE.

CREATE INDEX INDICE_NU ON EMPLE(DEPT_NO);


-- 10�.- Mostrar los �ndices y la unicidad que existen en el diccionario de datos para la tabla EMPLE.

-- PARA SABER LA UNICIDAD DEL INDICE UNIQUENESS

 SELECT INDEX_NAME, UNIQUENESS, COLUMN_POSITION
  FROM USER_IND_COLUMNS, USER_IND_COLUMNS, 
  WHERE INDEX_NAME = INDEX_NAME
  AND UPPER(TABLE_NAME) = 'EMPLE';
 
-- USER_INDEXES

-- 11 �.- Borra el indice creado anteriormente.

DROP INDEX INDICE_NU;

-- 12�.- Crea un indice para las b�squedas por nombre de departamento en mayusculas. Llama al indice IND_DEPT_DNOMBRE.

CREATE INDEX IND_DEPT_DNOMBRE ON DEPARTSEQ UPPER(DEPART(DNOMBRE));

-- 13�.- Activa la monitorizaci�n del indice  IND_DEPT_DNOMBRE
 
ALTER INDEX IND_DEPT_DNOMBRE MONITORING USAGE;
 
/*
14�.- Realiza dos consultas una en la Oracle use el indice  IND_DEPT_DNOMBRE 
y otra que no la use, y compru�balo para ambos casos. DESACTIVAR LA MONITORIZACION
*/

SELECT *
  FROM DEPARTSEQ
  WHERE UPPER(NOMBRE) = 'VENTAS'
  
ALTER INDEX IND_DEPT_DNOMBRE NOMONITORING USAGE;

--NO USA

SELECT E.*
  FROM EMPKE E
  WHERE UPPER(LOC)='BARCELONA';
  
  
ALTER INDEX IND_DEPT_DNOMBRE NOMONITORING USAGE;

/*
INDEX_NAME: nombre del �ndice usado.
TABLE_NAME: nombre de la tabla a la que pertenece el �ndice usado.
MONITORING: estado de monitorizaci�n, si est� activa mostrar� "YES".
USED: mostrar� "NO" si a�n no ha sido usado.
START_MONITORING: fecha y hora de inicio de monitorizaci�n.
END_MONITORING: fecha y hora de fin de monitorizaci�n.
*/

/* 
15�.- Crear un sin�nimo para la tabla DEPART llamado DEP. 
Cambiar el nombre de la tabla DEPART a DEPARTAMENTOS. 
Comprobar si es v�lido el sin�nimo.
*/

CREATE PUBLIC SYNONYM DEPART.DEP
      FOR DEPART.DEPARTAMENTOS;

-- COMPROBACION
DESC DEP
SELECT * FROM DEP;
      
 -- PARA CREAR SINONIMOS O VISTAS EN USUARIO VAGRANT     

-- 16�.- Comprueba los sin�nimos que tienes creados. Una vez comprobado, borra el sin�nimo.

SELECT * 
  FROM ALL_SYNONYMS
  WHERE UPPER(SYNONYM_NAME) = 'DEP';

DROP PUBLIC SYNONYM DEPART.DEP ;
