/*
Tareas_a_realizar_vistas_practica

POR MIGUEL OLMO HERNANDO

PROBLEMAS CON EL 10
*/

/*
1.  Crear una vista EMP_30 que contenga de los empleados del departamento 30 la siguiente información: 
código de empleado, apellidos, salario y departamento. Comprueba que se ha creado correctamente, y su contenido.
*/

DESC DEPART

SELECT * FROM DEPART;
SELECT * FROM EMPLE;

SELECT EMP_NO, APELLIDO, SALARIO, DEPT_NO
  FROM EMPLE
  WHERE DEPT_NO =30;
  
DESC USER_VIEWS;

CREATE OR REPLACE  VIEW EMP_30 AS (
  SELECT EMP_NO, APELLIDO, SALARIO, DEPT_NO
  FROM EMPLE
  WHERE DEPT_NO =30);
  
SELECT * 
    FROM SYS.USER_VIEWS 
    WHERE UPPER(VIEW_NAME)='EMP_30';
    
DESC USER_VIEWS;

DROP VIEW EMP_30;
  
SELECT * FROM EMP_30;

/*2. Realiza la siguiente inserción
INSERT INTO EMPLE VALUES(9999,'URRUTIA','ANALISTA',7698,NULL,200000,NULL,30); Comprueba el  contenido de la tabla. ¿Qué sucede en la vista?
*/

SELECT * FROM EMPLE;

INSERT INTO EMPLE VALUES(9999,'URRUTIA','ANALISTA',7698,NULL,200000,NULL,30); 

SELECT * FROM EMP_30;
SELECT * FROM EMPLE;
-- QUE SE ACTUALIZA PORQUE AFECTA AL CODIGO DE DEPARTAMENTO 30

/*3. Añade ahora un nuevo empleado en la vista, en el departamento 30.
INSERT INTO EMP_30 VALUES(8888,'RUIZ',280000,30);
 ¿Qué ocurre en la tabla base? ¿Y en la vista? ¿Añade otro empleado en la vista, pero en el departamento 10?  ¿Qué ocurre en la tabla base? ¿Y en la vista?
*/

INSERT INTO EMP_30 VALUES(8888,'RUIZ',280000,30);

SELECT * 
  FROM EMPLE
  WHERE UPPER(APELLIDO)='RUIZ';
  
  SELECT * FROM EMP_30;

-- QUE SE REALIZA LA INSERT EN LA TAMBLA BASE, LA VISTA SE ACTUALIZA 

INSERT INTO EMP_30 VALUES(5555,'OLMO',280000,10);

  SELECT * FROM EMPLE;

-- EN LA TABLA BASE SE INSERTA EL APELLIDO OLMO, PERO EN LA VIEW NO PORQUE LA WHERE DE LA VIEW NOS CONDICIONA QUE SEA EN EL DEPT_NO = 30


/*4. Modificar la vista creada en el ejercicio 1 de forma que nos aseguremos que las operaciones DML realizadas sobre la vista 
permanezca dentro del dominio de la misma. Comprobarlo haciendo alguna inserción:

INSERT INTO EMP_30 VALUES (1111, 'LOPEZ', 1200,30);  
INSERT INTO EMP_30 VALUES (2222, 'RUIZ', 2200,20);  

y alguna modificación: por ejemplo, modificar el departamento a 10 al empleado 7698.
*/

CREATE OR REPLACE  VIEW EMP_30 AS (
  SELECT EMP_NO, APELLIDO, SALARIO, DEPT_NO
  FROM EMPLE
  WHERE DEPT_NO = 30)
  WITH CHECK OPTION CONSTRAINT EMP_30_ERROR; -- ESTA ES LA CLAUSULA QUE HAY QUE AÑADIR

INSERT INTO EMP_30 VALUES (1111, 'LOPEZ', 1200,30);  
INSERT INTO EMP_30 VALUES (2222, 'RUIZ', 2200,20);  

SELECT * 
  FROM EMP_30 
  WHERE EMP_NO IN (1111, 2222);
  
SELECT * 
  FROM EMPLE
  WHERE EMP_NO IN (1111,2222);
  
-- LA MODIFICACION

UPDATE EMP_30
  SET DEPT_NO = 10
  WHERE DEPT_NO = 7968;
-- NO DEJARIA PORQUE SE SALDRIA DE LA VISTA, YA QUE VIOLAMOS LA CLAUSUAR WITCH CHECK OPTION


/*
5. Crear una vista SAL_20 que contenga el código del empleado con el alias ID_EMP, apellidos con el alias APE_EMP
y salario anual con el alias SAL_ANUAL para cada empleado del departamento 20.*/

-- DE UNA FORMA CON EL AS
CREATE OR REPLACE  VIEW EMP_30 AS (
  SELECT EMP_NO AS ID_EMP, APELLIDO AS APE_EMP, (SALARIO*12) AS SAL_ANUAL
  FROM EMPLE
  WHERE DEPT_NO = 20);

-- DE OTRA FORMA CON LOS ALIAS ANTES DEL AS
CREATE OR REPLACE  VIEW EMP_30 (ID_EMP, APE_EMP, SAL_ANUAL) AS
  SELECT EMP_NO , APELLIDO , (SALARIO*12) 
  FROM EMPLE
  WHERE DEPT_NO = 20;
  
SELECT * 
  FROM SYS.USER_VIEWS 
  WHERE UPPER(VIEW_NAME)='EMP_30';

/*
6. Crear una vista de nombre DEPT_SUM con los nombres de departamentos, salarios mínimos, salarios máximos 
y salarios medios por departamento. Utiliza los alias DEPT_NOMBRE, SAL_MIN, SAL_MAX, SAL_MED
¿Es una vista simple o compleja?
*/

-- ES UNA VISTA COMPLEJA

DESC DEPART
DESC EMPLE

SELECT * FROM EMPLE;
SELECT * FROM DEPART;

SELECT DEPART.DNOMBRE AS DEPT_NOMBRE, MIN(EMPLE.SALARIO) AS SAL_MIN, MAX (EMPLE.SALARIO) AS SAL_MAX, ROUND(AVG(EMPLE.SALARIO)) AS SAL_MED 
  FROM DEPART, EMPLE 
  WHERE EMPLE.DEPT_NO = DEPART.DEPT_NO
  GROUP BY DEPART.DNOMBRE , EMPLE.DEPT_NO;

DESC SYS.USER_VIEWS

CREATE OR REPLACE VIEW DEPT_SUM AS (
  SELECT DEPART.DNOMBRE AS DEPT_NOMBRE, MIN(EMPLE.SALARIO) AS SAL_MIN, MAX (EMPLE.SALARIO) AS SAL_MAX, ROUND(AVG(EMPLE.SALARIO)) AS SAL_MED 
      FROM DEPART, EMPLE 
      WHERE EMPLE.DEPT_NO = DEPART.DEPT_NO
      GROUP BY DEPART.DNOMBRE , EMPLE.DEPT_NO);

SELECT * FROM DEPT_SUM;
  
SELECT * 
  FROM SYS.USER_VIEWS
  WHERE UPPER(VIEW_NAME) = 'DEPT_SUM';
  
DESC DEPT_SUM

  
-- 7.  Eliminar la vista SAL_20.

DESC SYS.USER_VIEWS

SELECT * 
  FROM SAL_20;

DROP VIEW SAL_20;

SELECT * 
  FROM SAL_20;

-- POR SI HAY QUE RECUPERARLA
ROLLBACK;

/*
8. El equipo de programadores se ha dado cuenta que realizan muchas consultas en las que intervienen el sueldo máximo 
de cada departamento, así que deciden crear una vista denominada V_DEPT_SALMAX.
*/

DESC EMPLE

-- AGRUPADO POR CODIGO DE DEPT_NO 
SELECT MAX(EMPLE.SALARIO) SALARIO, EMPLE.DEPT_NO DEPARTAMENTO
  FROM EMPLE, DEPART
  WHERE EMPLE.DEPT_NO = DEPART.DEPT_NO 
  GROUP BY  EMPLE.DEPT_NO, DEPART.DNOMBRE;


DESC EMPLE
  
CREATE OR REPLACE VIEW  V_DEPT_SALMAX AS (
SELECT DEPT_NO, MAX(SALARIO) AS SAL_MAX
  FROM EMPLE
  GROUP BY DEPT_NO);
  
SELECT * 
  FROM SYS.USER_VIEWS
  WHERE VIEW_NAME='V_DEPT_SALMAX';
  
  SELECT * FROM V_DEPT_SALMAX;
  

/*
9. Realiza una consulta que muestre el nombre del empleado, el salario del empleado, el código del departamento y el salario 
medio del departamento, para aquellos empleados cuyo salario supere la media de su departamento.
*/
DESC EMPLE
DESC DEPART

SELECT * FROM EMPLE;
SELECT * FROM DEPART;


SELECT E.APELLIDO,E.SALARIO, E.DEPT_NO, D.SAL_MAX
    FROM EMPLE E, V_DEPT_SALMAX D
    WHERE E.DEPT_NO = D.DEPT_NO 
    AND E.SLARIO > D.SAL_MAX;

/*
10. Crear la vista que muestre los apellidos de los empleados, salarios, códigos de departamentos y salarios máximos para todos 
los empleados que ganan menos que el salario máximo de su departamento. Utiliza una select en el FROM.
*/

<<<<<<< HEAD
CREATE OR REPLACE VIEW MOSTRAR_ASCS AS(
  SELECT E.APELLIDO, E.SALARIO, E.DEPT_NO, D.SALARIO "SALARIO DEPART"
    FROM EMPLE E, 
    (SELECT ROUND(MAX(E.SALARIO)) "SALARIO", E.DEPT_NO
                      FROM DEPART D, EMPLE E
                      WHERE D.DEPT_NO = E.DEPT_NO
                      GROUP BY E.DEPT_NO)
                      WHERE E.DEPT_NO = D.DEPT_NO
                  AND SALARIO > (SELECT AVG(SALARIO)  
                      FROM EMPLE, DEPART 
                      WHERE EMPLE.DEPT_NO = DEPART.DEPT_NO)
                    ); 

SELECT * FROM MOSTRAR_ASCS;

=======
CREATE OR REPLACE VIEW EJERCICIO AS (SELECT 
                                                                                                      
                                                                                                                                                                                                         
>>>>>>> master
SELECT * 
  FROM SYS.USER_VIEWS
  WHERE VIEW_NAME='MOSTRAR_ASCS';
  


--11. Acceder al diccionario de datos y mostrar las vistas que tenéis creadas y la consulta usada para su creación.

SELECT * 
  FROM SYS.USER_VIEWS ;