
CREATE TABLE TipoDeAvion (
    numero_de_registro integer PRIMARY KEY,
    modelo varchar(20) NOT NULL,
    capacidad_de_personas integer NOT NULL,
    peso integer NOT NULL
);

CREATE TABLE Hangar (
    numero integer,
    numero_de_registro integer,
    capacidad_de_aviones integer NOT NULL,
    capacidad_disponible integer NOT NULL,
    PRIMARY KEY (numero, numero_de_registro),
    FOREIGN KEY (numero_de_registro) REFERENCES TipoDeAvion(numero_de_registro)
);

CREATE TABLE Arriendo(
	id_arriendo integer PRIMARY KEY,
	monto_pago integer NOT NULL,
	fecha_de_vencimiento_pago DATE,
	fecha_real_pago DATE
);

CREATE TABLE tipoPropietario(
    id_type integer PRIMARY KEY,
    nombre varchar(30) NOT NULL,
    direccion varchar(30) NOT NULL,
    telefono integer NOT NULL,
    type varchar2(8) not null check (type in ('Corporacion', 'person'))
);
CREATE TABLE Propietario(
    id_prop integer,
    id_type integer,
    id_arriendo integer,
    fecha_de_compra DATE,
    PRIMARY KEY (id_prop,id_type, id_arriendo),
    FOREIGN KEY (id_arriendo) REFERENCES Arriendo(id_arriendo),
    FOREIGN KEY (id_type) REFERENCES tipoPropietario(id_type)
);
CREATE TABLE Mantenimiento(
    id_mante integer PRIMARY KEY,
    fecha_de_inicio DATE,
    fecha_de_termino DATE,
    cantidad_horas_utilizadas integer NOT NULL,
    descripcion_trabajo varchar(120) NOT NULL
);
CREATE TABLE Pilotos(
    rut_piloto integer PRIMARY KEY,
    nombre varchar(120) NOT NULL
);

CREATE TABLE viajeros(
    id_viajero integer PRIMARY KEY,
    nombre varchar(120) NOT NULL,
    telefono integer NOT NULL
);

CREATE TABLE Vuelo(
    numero_vuelo integer,
    rut_piloto integer,
    id_viajero integer,
    fecha_de_salida DATE,
    fecha_de_llegada DATE,
    hora_despegue integer NOT NULL,
    hora_aterrisaje integer NOT NULL,
    origen varchar(120) NOT NULL,
    destino varchar(120) NOT NULL,
    PRIMARY KEY (numero_vuelo,rut_piloto, id_viajero),
    FOREIGN KEY (rut_piloto) REFERENCES Pilotos(rut_piloto),
    FOREIGN KEY (id_viajero) REFERENCES viajeros(id_viajero)
);

CREATE TABLE Avion(
    numero_de_registro integer,
    id_prop integer,
    id_type integer,
    id_arriendo integer,
    id_mante integer,
    numero_vuelo integer,
    rut_piloto integer,
    id_viajero  integer,
    PRIMARY KEY (numero_de_registro,id_prop,id_type, id_arriendo, id_mante,numero_vuelo,rut_piloto, id_viajero),
    constraint pk_avion_tipo FOREIGN KEY (numero_de_registro) REFERENCES TipoDeAvion(numero_de_registro),
    constraint pk_avion_propietario FOREIGN KEY (id_prop,id_type, id_arriendo) REFERENCES Propietario(id_prop,id_type, id_arriendo),
    constraint pk_avion_mantenimiento FOREIGN KEY (id_mante) REFERENCES Mantenimiento(id_mante),
    constraint pk_avion_vuelo FOREIGN KEY (numero_vuelo,rut_piloto, id_viajero) REFERENCES Vuelo(numero_vuelo,rut_piloto, id_viajero)
);

//////////////////////////////////////1////////////////////////////////////////

SELECT R.id_prop,T.nombre,T.type
from tipoPropietario T,Propietario R,Avion A,TipoDeAvion W
WHERE A.id_prop=R.id_prop
AND A.numero_de_registro=W.numero_de_registro
AND W.modelo='Airbus'
AND W.modelo != (SELECT modelo FROM TipoDeAvion new WHERE new.modelo='Boeing');

///////////////////////////////////2////////////////////////////////////////////


SET SERVEROUTPUT ON;
 create or replace procedure consulta_Vuelo(cod_vuelo in integer)
 as
	CURSOR HORAS IS 
		Select V.fecha_de_salida,V.hora_despegue,V.fecha_de_llegada,V.hora_aterrisaje 
		From Vuelo V
		Where V.numero_vuelo=cod_vuelo;

fecha_de_salida date; 
hora_despegue integer;
fecha_de_llegada date; 
hora_aterrisaje integer;
cant_pasajeros integer;
BEGIN
		OPEN HORAS;
		LOOP
	        FETCH HORAS INTO fecha_de_salida,hora_despegue,fecha_de_llegada,hora_aterrisaje;
	        EXIT WHEN HORAS%NOTFOUND;
			DBMS_OUTPUT.PUT_LINE('fecha salida :'||fecha_de_salida||'hora despegue :'||hora_despegue||'fecha llegada :'||fecha_de_llegada||'hora aterrisaje :'||hora_aterrisaje);
        END LOOP;
		CLOSE HORAS;

	   cant_pasajeros:=0;
	   SELECT count(viajeros.id_viajero) 
       INTO cant_pasajeros
       from  Vuelo V, viajeros
       where V.numero_vuelo= cod_vuelo; 

       dbms_output.put_line('La cantidad de pasajeros es: ' || cant_pasajeros);
 EXCEPTION
  when no_data_found then
	dbms_output.put_line('NO HAY DATOS');
END consulta_Vuelo;


 execute consulta_Vuelo(104);


//////////////////////////////////3////////////////////////////////////////////


SET SERVEROUTPUT ON;
 create or replace procedure listado_propietarios_morosos
 as
	CURSOR PROPI IS 
		Select T.nombre,T.direccion,T.type,A.monto_pago
		From Propietario P,Arriendo A,tipoPropietario T
		Where T.id_type=P.id_type
		AND   A.id_arriendo=P.id_arriendo
		AND   A.fecha_de_vencimiento_pago > sysdate;

nombre varchar2(20);
direccion varchar2(20);
typo varchar2(20);
monto_pago varchar2(20);
BEGIN
		OPEN PROPI;
		LOOP
	        FETCH PROPI INTO nombre,direccion,typo,monto_pago;
	        EXIT WHEN PROPI%NOTFOUND;
			DBMS_OUTPUT.PUT_LINE('Propietarios morosos :'||nombre||'direccion :'||direccion||'typo :'||typo||'deuda:'||monto_pago);
		END LOOP;
		CLOSE PROPI;
 EXCEPTION
	 when no_data_found then
	dbms_output.put_line('NO HAY DATOS');
END listado_propietarios_morosos;


 execute listado_propietarios_morosos();

////////////////////////////////4/////////////////////////////////////////

SET SERVEROUTPUT ON;
create or replace procedure clasificacion_clientes
 as
CURSOR CLIENTES IS 
    Select V.nombre,count(V.id_viajero)
    From viajeros V,Vuelo B
    WHERE V.id_viajero=B.id_viajero
    AND B.fecha_de_salida>'2017-01-01 00:00:00'
    AND B.fecha_de_llegada<'2017-12-31 23:59:59' group by V.nombre;
   
clientes_nombre varchar2(20);
clientes_cantidad integer;
BEGIN
    clientes_cantidad :=0;
    OPEN CLIENTES;
    LOOP
        FETCH CLIENTES INTO clientes_nombre,clientes_cantidad;
        EXIT WHEN CLIENTES%NOTFOUND;
        
        if clientes_cantidad>10 then
       		DBMS_OUTPUT.PUT_LINE('CLIENTE FRECUENTE   '||clientes_nombre );
        elsif clientes_cantidad<5 then
        	DBMS_OUTPUT.PUT_LINE('CLIENTE OCASIONAL   '||clientes_nombre );
        else 
        	DBMS_OUTPUT.PUT_LINE('CLIENTE COMUN       '||clientes_nombre );
        end if;
    END LOOP;
    CLOSE CLIENTES;

   EXCEPTION
	 when no_data_found then
	dbms_output.put_line('NO HAY DATOS');
END clasificacion_clientes;



execute clasificacion_clientes();



////////////////////////////////5/////////////////////////////////////////


CREATE OR REPLACE TRIGGER Update_angar
  BEFORE
    UPDATE  ON Hangar
  FOR EACH ROW

declare 

new_capacidad_disponible Hangar.capacidad_disponible%type;
new_capacidad_de_personas Hangar.capacidad_de_personas%type;
old_capacidad_disponible Hangar.capacidad_disponible%type;
old_capacidad_de_personas Hangar.capacidad_de_personas%type;
old_capacidad_de_aviones Hangar.capacidad_de_aviones%type;

new_numero Hangar.numero%type;
new_numero_de_registro Hangar.numero_de_registro%type;
new_capacidad_de_aviones Hangar.capacidad_de_aviones%type;

BEGIN
old_capacidad_disponible:=:OLD.capacidad_disponible;
old_capacidad_de_personas:=:OLD.capacidad_de_personas;
old_capacidad_de_aviones:=:OLD.capacidad_de_aviones;
new_capacidad_disponible:=:NEW.capacidad_disponible;
new_capacidad_de_personas:=:NEW.capacidad_de_personas;
new_numero:=:NEW.numero;
new_numero_de_registro:=:NEW.numero_de_registro;
new_capacidad_de_aviones:=:NEW.capacidad_de_aviones;



    IF new_capacidad_disponible>old_capacidad_disponible AND old_capacidad_disponible < old_capacidad_de_aviones THEN
      	INSERT INTO Hangar (numero, numero_de_registro, capacidad_de_aviones, capacidad_disponible)
		VALUES (new_numero,new_numero_de_registro,new_capacidad_de_aviones,old_capacidad_disponible-1);
	elsif new_capacidad_disponible<old_capacidad_disponible AND Dold_capacidad_disponible < old_capacidad_de_aviones THEN
		INSERT INTO Hangar (numero, numero_de_registro, capacidad_de_aviones, capacidad_disponible)
		VALUES (new_numero,new_numero_de_registro,new_capacidad_de_aviones,old_capacidad_disponible+1);
	END IF;
END;

////////////////////////////////5/////////////////////////////////////////

CREATE OR REPLACE TRIGGER Update_Vuelos_dobles
  BEFORE
    UPDATE  ON Vuelo
  FOR EACH ROW
  declare

  new_destino Vuelo.destino%type;
  old_destino Vuelo.destino%type;

  new_fecha_de_salida Vuelo.fecha_de_salida%type;
  new_numero_vuelo Vuelo.numero_vuelo%type;
  new_rut_piloto Vuelo.rut_piloto%type;
  new_id_viajero Vuelo.id_viajero%type;
  new_fecha_de_salida Vuelo.fecha_de_salida%type;
  new_fecha_de_llegada Vuelo.fecha_de_llegada%type;
  new_hora_despegue Vuelo.hora_despegue%type;
  new_hora_aterrisaje Vuelo.hora_aterrisaje%type;
  new_origen Vuelo.origen%type;
BEGIN
	new_destino:=:NEW.destino;
	old_destino:=:OLD.destino;

	new_fecha_de_salida:=:NEW.fecha_de_salida;
	new_numero_vuelo:=:NEW.numero_vuelo;
	new_rut_piloto:=:NEW.rut_piloto;
	new_id_viajero:=:NEW.id_viajero;
	new_fecha_de_salida:=:New.fecha_de_salida;
	new_fecha_de_llegada:=:NEW.fecha_de_llegada;
	new_hora_despegue:=:NEW.hora_despegue;
	new_hora_aterrisaje:=NEW.hora_aterrisaje;
	new_origen:=:NEW.origen;

    IF new_destino!=old_destino AND new_fecha_de_salida <> sysdate THEN
      	INSERT INTO Vuelo (numero_vuelo, rut_piloto, id_viajero, fecha_de_salida,
							fecha_de_llegada,hora_despegue,hora_aterrisaje,origen,destino)
		VALUES (new_numero_vuelo,new_rut_piloto,new_id_viajero,new_fecha_de_salida,
				new_fecha_de_llegada,new_hora_despegue,new_hora_aterrisaje,new_origen,new_destino);
	END IF;
END;

////////////////////////////////6/////////////////////////////////////////

create user consultar_junior  identified by consultar_junior
default tablespace users 
quota 20M on users
temporary tablespace temp 
quota 5M on system;

Grant SELECT ANY TABLE to consultar_junior;





