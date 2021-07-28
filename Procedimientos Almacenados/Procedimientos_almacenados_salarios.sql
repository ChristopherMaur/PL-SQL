///////////////////////////ejercicio 3//////////////////////////////////////////////

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
/////////////////////////////////ejercicio 2////////////////////////////////////////

SET SERVEROUTPUT ON;
DECLARE 
  CURSOR EMPLEADO IS 
    Select E.SUELDO  From Empleados E;
 
empleado_s varchar2(20);
empleado_A integer;
empleado_B integer;
empleado_C integer;
BEGIN
    empleado_A :=0;
    empleado_B :=0;
    empleado_C :=0;
    OPEN EMPLEADO;
    LOOP
        FETCH EMPLEADO INTO empleado_s;
        EXIT WHEN EMPLEADO%NOTFOUND;
        
        if empleado_s>350000 then
        empleado_A:=empleado_A+1;
       /* DBMS_OUTPUT.PUT_LINE('Categoria A sueldo mayor a $350.000 '||empleado_s);*/
        elsif empleado_s<250000 then
        empleado_C:=empleado_C+1;
        /*DBMS_OUTPUT.PUT_LINE('Categoria C sueldo menor a $250.000 '||empleado_s);*/
        else
        empleado_B:=empleado_B+1;
        /*DBMS_OUTPUT.PUT_LINE('Categoria B sueldo entre $350.000 y $250.000 '||empleado_s);*/
        end if;
    END LOOP;
    CLOSE EMPLEADO;
    DBMS_OUTPUT.PUT_LINE('CATEGORIA A  cantidad = '||empleado_A );
    DBMS_OUTPUT.PUT_LINE('CATEGORIA B  cantidad = '||empleado_B );
    DBMS_OUTPUT.PUT_LINE('CATEGORIA C  cantidad = '||empleado_C );
    
    EXCEPTION
      WHEN OTHERS
        THEN
          DBMS_OUTPUT.put_line(SQLERRM);
END;

//////////////////////////////////////////////////////////////////////////