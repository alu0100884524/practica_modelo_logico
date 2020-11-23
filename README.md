# Prácticas ADBD

**Realizado por:** Elena M Sacramento Delgado - *alu0100884524*

## Práctica 2: Modelo lógico Relacional

En está práctica aprendimos a pasar del modelo E/R al modelo lógico. Una vez hecho esto, lo cargamos en la máquina virtual.



### Modelo E/R viveros

![viveros](https://github.com/alu0100884524/practica_modelo_logico/blob/main/images/vivero.png)

**Script**
[Script_Viveros]()

### Modelo E/R catastro

![catastro](https://github.com/alu0100884524/practica_modelo_logico/blob/main/images/catastro.png)

**Script**
[Script_Catastro]()

Mencionar que con este modelo, se nos genera el problema de la 'Gallina o el huevo'. Como vemos persona tiene una dirección en vivienda o en piso, pero a su vez vivienda o piso tienen una persona que es propietaria. Entonces al hacer un insert no se sabe que fué antes. Por ello como solución ponemos los atributos dueño, numero, piso, calle y letra con posibilidad de ser nulos, para que a la hora de insertar podamos primero insertar la vivienda y luego la persona.

**Ejemplo**



![gallina_huevo](https://github.com/alu0100884524/practica_modelo_logico/blob/main/images/gallina_huevo.png)

```mysql
START TRANSACTION;
USE `catastro`;
INSERT INTO `catastro`.`VIVIENDA` (`superficie`, `numero_habitantes`, `eficiencia`, `numero`, `calle`, `propietario`) VALUES (200, 2, 'A', 1, 'San Agustín', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `catastro`.`PERSONA`
-- -----------------------------------------------------
START TRANSACTION;
USE `catastro`;
INSERT INTO `catastro`.`PERSONA` (`dni`, `nombre`, `fecha_nacimiento`, `cabeza_dni`, `PISO_planta`, `PISO_letra`, `PISO_numero`, `PISO_calle`, `VIVIENDA_numero`, `VIVIENDA_calle`) VALUES ('1111', 'Ana García', '1975', '1111', NULL, NULL, NULL, NULL, 1, 'San Agustín');
INSERT INTO `catastro`.`PERSONA` (`dni`, `nombre`, `fecha_nacimiento`, `cabeza_dni`, `PISO_planta`, `PISO_letra`, `PISO_numero`, `PISO_calle`, `VIVIENDA_numero`, `VIVIENDA_calle`) VALUES ('2222', 'Pedro Coello', '1945', '2222', 3, 'A', 12, 'San Juan', NULL, NULL);

COMMIT;
```



## Práctica 3: Triggers

### Procedimiento crear_email (viveros)

Primero creamos un procedimiento de crear_email, en el que concatenamos el nombre del cliente con el dominio.  

```mysql
DELIMITER //

CREATE PROCEDURE crear_email(IN nombre VARCHAR(45), IN dominio VARCHAR(45), OUT email VARCHAR(45))
BEGIN
  SELECT CONCAT(nombre, '@', dominio) INTO email;
END //

DELIMITER ;
```

### Trigger crear_email_before_insert (viveros)

Nos creamos un **Trigger** que antes de insertar un nuevo cliente, compruebe si ha puesto el correo, en el caso de que no entonces llamará a la función crear_email que se encargará de crear uno nuevo.

```mysql
USE `viveros`$$
CREATE DEFINER = CURRENT_USER TRIGGER `viveros`.`CLIENTE_BEFORE_INSERT` BEFORE INSERT ON `CLIENTE` FOR EACH ROW
BEGIN
	IF NEW.email IS NULL THEN
		CALL crear_email(NEW.nombre, NEW.dominio, @email);
		SET NEW.email = @email;
	END IF;
    
END$$
```

**Ejemplo:**

![crear_email](https://github.com/alu0100884524/practica_modelo_logico/blob/main/images/crear_email.png)



### Trigger verificar que una persona solo viva en una casa (catastro)

Para verificar que una persona no vive en dos casas, en la tabla PERSONA añadimos un Trigger antes de insertar y de actualizar que compruebe si el número de la vivienda y del piso esta NOT NULL , entonces no permite añadir otra vivienda.


```mysql
USE `catastro`$$
CREATE DEFINER = CURRENT_USER TRIGGER `catastro`.`PERSONA_BEFORE_INSERT` BEFORE INSERT ON `PERSONA` FOR EACH ROW
BEGIN
IF NEW.PISO_numero IS NOT NULL AND NEW.VIVIENDA_numero IS NOT NULL THEN
		SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Una persona no puede estar en dos viviendas';
	END IF;

END$$
```

**Ejemplo before_insert:**

![before_insert](https://github.com/alu0100884524/practica_modelo_logico/blob/main/images/before_insert.png)

**Ejemplo before_update:**

![before_update](https://github.com/alu0100884524/practica_modelo_logico/blob/main/images/before_update.png)

### Trigger actualizar stock (viveros)

Para mantener el stock actualizado, creamos el siguiente **Trigger**. Después de haber insertado un nuevo producto en un pedido, entonces, reducirá la cantidad de productos en el pedido en el stock de producto y de producto en zona.


```mysql
USE `viveros`$$
CREATE DEFINER = CURRENT_USER TRIGGER `viveros`.`PRODUCTO_EN_PEDIDO_AFTER_INSERT` AFTER INSERT ON `PRODUCTO_EN_PEDIDO` FOR EACH ROW
BEGIN
  UPDATE PRODUCTO SET stock = stock - NEW.cantidad WHERE cod_barras = NEW.cod_barras;
  UPDATE PRODUCTO_EN_ZONA SET stock = stock - NEW.cantidad WHERE cod_barras = NEW.cod_barras;
END$$
```

**Ejemplo:**

![stock](https://github.com/alu0100884524/practica_modelo_logico/blob/main/images/stock.png)