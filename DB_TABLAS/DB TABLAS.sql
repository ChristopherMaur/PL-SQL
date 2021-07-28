CREATE TABLE Carrera(
    car_codigo integer PRIMARY KEY,
    car_nombre varchar(20)
);

CREATE TABLE Alumno (
    al_rut varchar(12) PRIMARY KEY,
    al_nombre varchar(20) NOT NULL,
    car_codigo integer REFERENCES CArrera,
    al_fecha_nac DATE,

);

CREATE TABLE Profesor (
    pro_rut varchar(12) PRIMARY KEY,
    pro_nombre varchar(20) NOT NULL,
    dep_id integer
);

CREATE TABLE Curso (
    cu_codigo integer PRIMARY KEY,
    cu_nombre varchar(20) NOT NULL,
    cu_impartido varchar(20) NOT NULL,
    cu_aula varchar(20) NOT NULL,
    pro_rut varchar(12) REFERENCES Profesor
);

CREATE TABLE  Matriculado(
    al_rut varchar(12) not null,
    cu_codigo integer,
    ma_nota integer,
    CONSTRAINT pk_p_p1 PRIMARY KEY (al_rut,cu_codigo)
);

ALTER TABLE Alumno MODIFY (car_codigo integer REFERENCES Carrera);
INSERT INTO  CARRERA (CAR_CODIGO,CAR_NOMBRE)VALUES(01,'IECI');
INSERT INTO  Alumno (al_rut,al_nombre,car_codigo)VALUES()

Select * From Carrera;

Confesión 4423
////////////////////////////////////////////////////////////////////


   CREATE OR REPLACE PROCEDURE 
      procedimiento1 (a IN NUMBER, b IN OUT NUMBER) IS
         vmax NUMBER;
         BEGIN
            SELECT salario, maximo 
            INTO b, vmax
            FROM empleados
            WHERE empleado_id=a;
            IF b < vmax THEN
               b:=b+100;
            END IF;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
               b:=-1;
               RETURN;
            WHEN OTHERS THEN
               RAISE;
         END;

/////////////////////////////////////////////////////////////////////////

SET SERVEROUTPUT ON;
 create or replace procedure consulta_Proyecto(variable_1 in integer)
 as
  CURSOR HORAS IS 
	Select T.horas  From Trabaja T, Proyectos P
	Where T.cod_p=P.cod_p
    and T.cod_p=variable_1;
    
  CURSOR SUELDO IS 
	Select E.SUELDO  From Trabaja T, Proyectos P,Empleados E
	Where T.cod_p=P.cod_p
    and T.COD_E=E.COD_E
    and T.cod_p=variable_1;
    
  CURSOR EMPLEADO IS 
	Select E.nombre_e  From Trabaja T, Proyectos P,Empleados E
	Where T.cod_p=P.cod_p
    and T.COD_E=E.COD_E
    and T.cod_p=variable_1;

    
horas_P integer; 
horas_cantidad integer;
horas_total integer;
horas_promedio integer;

sueldo_p integer;
sueldo_cantidad integer;
sueldo_total integer;
sueldo_promedio integer;

empleado_p varchar2(20);
empleado_cantidad integer;
BEGIN
    horas_cantidad :=0;
    horas_total:=0;
    OPEN HORAS;
	LOOP
        FETCH HORAS INTO horas_P;
        EXIT WHEN HORAS%NOTFOUND;
		 /*DBMS_OUTPUT.PUT_LINE('horas '||horas_P);*/
        horas_cantidad:=horas_cantidad+1;
        horas_total:=horas_total+horas_P;
       
	END LOOP;
	CLOSE HORAS;
    /*
    DBMS_OUTPUT.PUT_LINE('horas cantidad '||horas_cantidad);
    DBMS_OUTPUT.PUT_LINE('horas total '||horas_total);
     */
    horas_promedio:= horas_total / horas_cantidad;
    DBMS_OUTPUT.PUT_LINE('horas Promedio '||horas_promedio);
    
    sueldo_cantidad :=0;
    sueldo_total:=0;
    OPEN SUELDO;
	LOOP
        FETCH SUELDO INTO sueldo_p;
        EXIT WHEN SUELDO%NOTFOUND;
		/*DBMS_OUTPUT.PUT_LINE('sueldo '||sueldo_p);*/
        sueldo_cantidad:=sueldo_cantidad+1;
        sueldo_total:=sueldo_total+sueldo_P;
	END LOOP;
	CLOSE SUELDO;
    /*
    DBMS_OUTPUT.PUT_LINE('sueldo cantidad '||sueldo_cantidad);
    DBMS_OUTPUT.PUT_LINE('sueldo total '||sueldo_total);
    */
    sueldo_promedio:= sueldo_total / sueldo_cantidad;
    DBMS_OUTPUT.PUT_LINE('sueldo Promedio '||sueldo_promedio);
    
    empleado_cantidad :=0;
    OPEN EMPLEADO;
	LOOP
        FETCH EMPLEADO INTO empleado_p;
        EXIT WHEN EMPLEADO%NOTFOUND;
		/*DBMS_OUTPUT.PUT_LINE('empleado '||empleado_p);*/
        empleado_cantidad:=empleado_cantidad+1;
	END LOOP;
	CLOSE EMPLEADO;
    DBMS_OUTPUT.PUT_LINE('empleado cantidad '||empleado_cantidad);

  EXCEPTION
  WHEN OTHERS
    THEN
      DBMS_OUTPUT.put_line(SQLERRM);
END consulta_Proyecto;

 execute consulta_Proyecto(104);
/////////////////////////////////////////////////////////////////////////

CREATE TABLE Proyectos(
	cod_p integer PRIMARY KEY,
	nombre_p varchar(22) NOT NULL,
	inicio DATE DEFAULT (sysdate),
	fin DATE DEFAULT (sysdate)
);

CREATE TABLE Empleados(
	cod_e integer PRIMARY KEY,
	nombre_e varchar(22) NOT NULL,
	sexo varchar(22) NOT NULL,
	sueldo  number(7) NOT NULL	
);

CREATE TABLE Trabaja(
	horas integer NOT NULL,
	cod_e integer REFERENCES Empleados,
	cod_p integer REFERENCES Proyectos
);


INSERT INTO "SYSTEM"."PROYECTOS" (COD_P, NOMBRE_P, INICIO, FIN) 
VALUES ('101', 're-ingenieria',
TO_DATE('2015-11-01 22:57:36', 'YYYY-MM-DD HH24:MI:SS'), 
TO_DATE('2016-01-01 22:57:55', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO "SYSTEM"."PROYECTOS" (COD_P, NOMBRE_P, INICIO, FIN) 
VALUES ('102', 'mantencion',
TO_DATE('2015-01-01 22:57:36', 'YYYY-MM-DD HH24:MI:SS'), 
TO_DATE('2015-02-01 22:57:55', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO "SYSTEM"."PROYECTOS" (COD_P, NOMBRE_P, INICIO, FIN) 
VALUES ('103', 'diseño',
TO_DATE('2017-05-03 22:57:36', 'YYYY-MM-DD HH24:MI:SS'), 
TO_DATE('2017-06-03 22:57:55', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO "SYSTEM"."PROYECTOS" (COD_P, NOMBRE_P, INICIO, FIN) 
VALUES ('104', 'SAP',
TO_DATE('2016-12-05 22:57:36', 'YYYY-MM-DD HH24:MI:SS'), 
TO_DATE('2017-12-05 22:57:55', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO "SYSTEM"."PROYECTOS" (COD_P, NOMBRE_P, INICIO, FIN) 
VALUES ('105', 'ERP',
TO_DATE('2015-12-05 22:57:36', 'YYYY-MM-DD HH24:MI:SS'), 
TO_DATE('2016-06-05 22:57:55', 'YYYY-MM-DD HH24:MI:SS'));


INSERT INTO  Trabaja (horas,cod_p,cod_e)VALUES(33,103,02);
INSERT INTO  Trabaja (horas,cod_p,cod_e)VALUES(20,104,03);
INSERT INTO  Trabaja (horas,cod_p,cod_e)VALUES(40,104,04);
INSERT INTO  Trabaja (horas,cod_p,cod_e)VALUES(35,101,01);
INSERT INTO  Trabaja (horas,cod_p,cod_e)VALUES(10,104,02);
INSERT INTO  Trabaja (horas,cod_p,cod_e)VALUES(10,102,02);
INSERT INTO  Trabaja (horas,cod_p,cod_e)VALUES(5,105,04);


INSERT INTO  Empleados (cod_e,nombre_e,sexo,sueldo)VALUES(01,'pedro','m','300000');
INSERT INTO  Empleados (cod_e,nombre_e,sexo,sueldo)VALUES(02,'andres','m',400000);
INSERT INTO  Empleados (cod_e,nombre_e,sexo,sueldo)VALUES(03,'juan','m',380000);
INSERT INTO  Empleados (cod_e,nombre_e,sexo,sueldo)VALUES(04,'loreto','f',500000);
INSERT INTO  Empleados (cod_e,nombre_e,sexo,sueldo)VALUES(05,'natalia','f',280000);
INSERT INTO  Empleados (cod_e,nombre_e,sexo,sueldo)VALUES(06,'esteban','m',250000);
INSERT INTO  Empleados (cod_e,nombre_e,sexo,sueldo)VALUES(07,'domingo','m',200000);
INSERT INTO  Empleados (cod_e,nombre_e,sexo,sueldo)VALUES(08,'maria','f',300000);
 








///////////////////////////////////////////////////////////////7

Select * From Departamento;
INSERT INTO  Departamento (cod_dep,nombre_dep)VALUES(100,'informatica');
INSERT INTO  Departamento (cod_dep,nombre_dep)VALUES(101,'robotica');
INSERT INTO  Departamento (cod_dep,nombre_dep)VALUES(102,'biologia');
INSERT INTO  Departamento (cod_dep,nombre_dep)VALUES(103,'social');
INSERT INTO  Departamento (cod_dep,nombre_dep)VALUES(104,'agricultura');
INSERT INTO  Departamento (cod_dep,nombre_dep)VALUES(105,'tiempo');
INSERT INTO  Departamento (cod_dep,nombre_dep)VALUES(106,'trasporte');
INSERT INTO  Departamento (cod_dep,nombre_dep)VALUES(107,'logica');
INSERT INTO  Departamento (cod_dep,nombre_dep)VALUES(108,'seguridad');
INSERT INTO  Departamento (cod_dep,nombre_dep)VALUES(109,'economia');


INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(01,'oso',200000,100);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(02,'lazaro',300000,100);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(03,'francisco',400000,100);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(04,'mojamed',500000,100);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(05,'luigui',200200,100);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(06,'mario',300300,100);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(07,'gato',400400,100);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(08,'esteban',500500,100);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(09,'luis',600600,100);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(10,'kirby',100100,100);

INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(11,'EDGARDO',200000,101);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(12,'EDITH',300000,101);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(13,'EDMUNDO',400000,101);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(14,'EFRAIN	',500000,101);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(15,'EFRÉN',200200,101);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(16,'ELENA',300300,101);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(17,'ELEONOR',400400,101);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(18,'ELIAS',500500,101);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(19,'ELISABETH',600600,101);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(20,'ELOISA',100100,101);

INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(21,'ELOY',200000,102);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(22,'ELVIRA',300000,102);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(23,'EMILIA',400000,102);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(24,'EMILIO	',500000,102);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(25,'EMANUEL',200200,102);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(26,'ENCARNACIÓN',300300,102);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(27,'ENGRACIA',400400,102);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(28,'ENRIQUE',500500,102);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(29,'ERASMO',600600,102);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(30,'ERICO',100100,102);

INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(31,'ERIC',200000,103);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(32,'ERICA',300000,103);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(33,'ERNESTO',400000,103);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(34,'ESMERALDA',500000,103);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(35,'ESPERANZA',200200,103);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(36,'ENCARNACIÓN',300300,103);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(37,'ESTEBAN',400400,103);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(38,'ESTEFANIA',500500,103);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(39,'ESTELA',600600,103);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(40,'ESTER',100100,103);

INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(41,'ETEL',200000,104);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(42,'EUCLIDES',300000,104);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(43,'EUDOSIA',400000,104);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(44,'EUDOXIO',500000,104);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(45,'EUFEMIO',200200,104);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(46,'EUFEMIA',300300,104);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(47,'EUFRASIO',400400,104);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(48,'EUFRASIA',500500,104);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(49,'EUGENIO',600600,104);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(50,'EUGENIA',100100,104);

INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(51,'EULALIO',200000,105);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(52,'EULALIA',300000,105);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(53,'EUSEBIO',400000,105);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(54,'EUSTAQUIO',500000,105);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(55,'EVANGELINA',200200,105);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(56,'EZEQUIEL',300300,105);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(57,'FABIAN',400400,105);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(58,'FABIOLA',500500,105);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(59,'FANNY',600600,105);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(60,'FÁTIMA',100100,105);

INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(61,'FAUSTINO',200000,106);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(62,'FAUSTO',300000,106);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(63,'FEDERICO',400000,106);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(64,'FEDOR',500000,106);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(65,'FELIX',200200,106);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(66,'FELIPE',300300,106);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(67,'FERMIN',400400,106);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(68,'FERNANDO',500500,106);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(69,'FIDEL',600600,106);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(70,'FLORA',100100,106);

INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(71,'FLORENCIO',200000,107);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(72,'FLORENCIA',300000,107);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(73,'FLORIDA',400000,107);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(74,'FLORINDA',500000,107);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(75,'FLORIÁN',200200,107);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(76,'FRANCO',300300,107);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(77,'FRIDA',400400,107);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(78,'FROILAN',500500,107);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(79,'FULVIO',600600,107);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(80,'GABRIEL',100100,107);

INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(81,'GEMA',200000,108);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(82,'GASPAR',300000,108);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(83,'GEDEÓN',400000,108);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(84,'GENOVEVA',500000,108);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(85,'GERARDO',200200,108);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(86,'GERTRUDIS',300300,108);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(87,'GILBERTO',400400,108);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(88,'GLADIS',500500,108);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(89,'GLORIA',600600,108);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(90,'GODOFREDO',100100,108);

INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(91,'GRACIA',200000,109);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(92,'GRACIELA',300000,109);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(93,'GREGORIO',400000,109);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(94,'GRISEL',500000,109);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(95,'GABRIELA',200200,109);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(96,'GORKA',300300,109);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(97,'GUIDO',400400,109);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(98,'URRU',500500,109);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(99,'MARRU',600600,109);
INSERT INTO  Empleado (cod_emp,nombre,salario,cod_dep)VALUES(100,'JORRO',100100,109);



///////////////////////////////////////////////////////////////////////////////////////////
SET SERVEROUTPUT ON;
DECLARE
TYPE EmployeeTypee IS RECORD (
id_emp Empleado.cod_emp%type,
nombre_emp Empleado.nombre%type,
salario_emp Empleado.salario%type
);
emp EmployeeTypee;
BEGIN
SELECT cod_emp, nombre, salario INTO emp
FROM Empleado
WHERE cod_emp = 70;

DBMS_OUTPUT.PUT_LINE('emp_record.id: ' || emp.id_emp);
DBMS_OUTPUT.PUT_LINE('emp_record.nombre: ' || emp.nombre_emp);
DBMS_OUTPUT.PUT_LINE('emp_record.salario: ' || emp.salario_emp);
END;
///////////////////////////////////////////////////////////////////////////////////////////



Select D.nombre_dep,E.nombre,MAX(E.SALARIO) as salario From Departamento D, Empleado E
Where D.COD_DEP=E.COD_DEP
GROUP BY D.nombre_dep,E.nombre
ORDER BY MAX(E.SALARIO) DESC;

Select D.nombre_dep,E.nombre,E.salario From Departamento D, Empleado E
Where D.COD_DEP=E.COD_DEP
AND
	E.salario=(
				Select MAX(salario) From Empleado
	);


//////////////////////////////////////////////////////////////////////
SET SERVEROUTPUT ON;
DECLARE 
CURSOR SELECCION IS 
	Select E.nombre,D.nombre_dep,E.salario From Departamento D, Empleado E
	Where D.COD_DEP=E.COD_DEP
	AND
		E.salario=(
					Select MAX(salario) From Empleado
		);
nombre varchar2(20);
departamento varchar2(20);
salario integer;
BEGIN
	OPEN SELECCION;
	LOOP
		DBMS_OUTPUT.PUT_LINE(' el empleado '||nombre|| ' del departamento ' ||departamento);
		FETCH SELECCION INTO nombre,departamento,salario;
		EXIT WHEN SELECCION%NOTFOUND;
	END LOOP;
	CLOSE SELECCION;
END;
/////////////////////////////////////////////////////////////////////

DECLARE
CURSOR MOSTRAR  IS
	Select E.cod_e, E.nombre_e From Empleado E, Trabaja T
	where E.cod_e=T.cod_e
	AND
		T.cod_p='102';
	AND
		T.horas>5;
codigo varchar(20);
nombre_empleados varchar(20);
BEGIN
	OPEN MOSTRAR;
		LOOP
			DBMS_OUTPUT.PUT_LINE(codigo||nombre_empleado);
			FETCH MOSTRAR INTO codigo,nombre_empleados;
			EXIT WHEN MOSTRAR%NOTFOUND;
		END LOOP;
		CLOSE MOSTRAR;
END;

//////////////////////////////////////////////////////////////////////











SELECT COUNT(*)  
FROM Empleado E
WHERE E.salario > 180000;


DECLARE
CURSOR SELECCION IS


////////////////////////////////////////////////////////////////
exceptions
////////////////////////////////////////////////////////////////

SET SERVEROUTPUT ON;
DECLARE
v_emp_nombre      VARCHAR2(20);
BEGIN
SELECT cod_emp into v_emp_nombre  from Empleado WHERE nombre = 'MARRU';
DBMS_OUTPUT.PUT_LINE(' el empleado '||v_emp_nombre);
exception
when no_data_found THEN
v_emp_nombre  := '999';
when too_many_rows THEN
v_emp_nombre  := '2';
END;
////////////////////////////////////////////////////////////////





SET SERVEROUTPUT ON;
DECLARE
TYPE EmployeeTypee IS RECORD (
id_emp Empleado.cod_emp%type,
nombre_emp Empleado.nombre%type,
salario_emp Empleado.salario%type
);
emp EmployeeTypee;
BEGIN
SELECT cod_emp, nombre, salario INTO emp
FROM Empleado
WHERE cod_emp = 70;

DBMS_OUTPUT.PUT_LINE('emp_record.id: ' || emp.id_emp);
DBMS_OUTPUT.PUT_LINE('emp_record.nombre: ' || emp.nombre_emp);
DBMS_OUTPUT.PUT_LINE('emp_record.salario: ' || emp.salario_emp);
END;


















