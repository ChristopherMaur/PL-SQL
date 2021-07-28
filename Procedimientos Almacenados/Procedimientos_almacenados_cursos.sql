//////////////////// respuesta 1 /////////////////////////////////

CREATE OR REPLACE TRIGGER Fecha_Erronea
BEFORE INSERT ON Alumnos FOR EACH ROW 
BEGIN
	IF :new.fecha_nacimiento >  sysdate THEN
		RAISE_APPLICATION_ERROR ( -20300, 'fecha Erronea');
	END IF;
END;

//////////////////// respuesta 2 /////////////////////////////////

CREATE OR REPLACE TRIGGER Fecha_Matricula
BEFORE INSERT ON Matriculas FOR EACH ROW
DECLARE
  fecha_sistema DATE;
  contador number;
BEGIN
	fecha_sistema := SYSDATE;

	SELECT COUNT(*) INTO contador
	FROM Matriculas
	WHERE dn_a = :new.dn_a and dn_c = :new.dn_c;

IF contador = 0 THEN
	INSERT INTO Matriculas (dn_a, dn_c, nota, fecha)
	VALUES (:NEW.dn_a, :NEW.dn_c,null, fecha_sistema);
END IF;
END;

//////////////////// respuesta 3 /////////////////////////////////


CREATE OR REPLACE TRIGGER cursos_Maximos
BEFORE INSERT ON Matriculas FOR EACH ROW
DECLARE
  contador number;
BEGIN
	SELECT  COUNT(*) INTO contador
	FROM Matriculas
	WHERE 
	dn_a = (SELECT MAX(dn_c)  
	 FROM Matriculas
	 WHERE dn_c = :new.dn_c 
	)
IF contador > 3 THEN
	RAISE_APPLICATION_ERROR ( -20300, 'Exceso de inscripciones');
END IF;
END;










