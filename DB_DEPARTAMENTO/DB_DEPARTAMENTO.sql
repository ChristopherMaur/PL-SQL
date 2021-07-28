CREATE TABLE departamento(
cod_depto integer PRIMARY KEY,
nombre_depto varchar(50)
);

CREATE TABLE empleado(
cod_emp integer PRIMARY KEY,
nombre_emp varchar(50),
salario integer,
cod_depto integer,
ano_ing integer,
sexo varchar(20),
FOREIGN KEY (cod_depto) REFERENCES departamento(cod_depto)
);


INSERT INTO departamento(cod_depto,nombre_depto) VALUES(01,'Inteligencia');
INSERT INTO departamento(cod_depto,nombre_depto) VALUES(02,'Software');
INSERT INTO empleado(cod_emp,nombre_emp,salario,cod_depto,ano_ing,sexo) VALUES(001,'Enzo Molina',999990,01,1991,'Desconocido');
INSERT INTO empleado(cod_emp,nombre_emp,salario,cod_depto,ano_ing,sexo) VALUES(002,'Felipe Gonzalez',999990,02,1991,'Masculino');
INSERT INTO empleado(cod_emp,nombre_emp,salario,cod_depto,ano_ing,sexo) VALUES(003,'Felipe Retamal',899990,01,1994,'Masculino');
INSERT INTO empleado(cod_emp,nombre_emp,salario,cod_depto,ano_ing,sexo) VALUES(004,'Jorge Weisser',699980,02,1989,'Masculino');


CREATE OR REPLACE
PROCEDURE
Actualiza_Salario(sal_min number)IS

BEGIN
UPDATE empleado
SET salario =  salario*1.15
WHERE salario <= sal_min;
END Actualiza_Salario;

--PRIMERA PREGUNTA
CREATE OR REPLACE
PROCEDURE Años_trabajados(cod_emp IN NUMBER)

IS
ano_trabajado integer;


BEGIN

SELECT ano_ing into ano_trabajado
FROM empleado
WHERE cod_emp=cod_emple;

ano := 2017-ano_trabajado;
DBMS_OUTPUT.PUT_LINE(TO_CHAR(ano));

END Años_trabajados;

CREATE OR REPLACE
PROCEDURE REGISTRO(cod_departament IN INTEGER,nombre_departament IN VARCHAR)

IS
NOMBRE_DEPART VARCHAR;
CODIGO_DEPART INTEGER;

BEGIN
SELECT cod_depto into CODIGO_DEPART, nombre_depto into NOMBRE_DEPART,
FROM departamento
WHERE cod_depto = cod_departament and nombre_depto = nombre_departmanet;

END REGISTRO;