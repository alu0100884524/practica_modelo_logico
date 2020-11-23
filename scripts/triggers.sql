-- -----------------------------------------------------
-- Procedimiento crear_email`
-- -----------------------------------------------------

DELIMITER //

CREATE PROCEDURE crear_email(IN nombre VARCHAR(45), IN dominio VARCHAR(45), OUT email VARCHAR(45))
BEGIN
  SELECT CONCAT(nombre, '@', dominio) INTO email;
END //

DELIMITER ;

-- -----------------------------------------------------
-- Trigger 
-- -----------------------------------------------------

DELIMITER $$
USE `viveros`$$
CREATE DEFINER = CURRENT_USER TRIGGER `viveros`.`CLIENTE_BEFORE_INSERT` BEFORE INSERT ON `CLIENTE` FOR EACH ROW
BEGIN
	IF NEW.email IS NULL THEN
		CALL crear_email(NEW.nombre, NEW.dominio, @email);
		SET NEW.email = @email;
	END IF;
    
END$$


DELIMITER ;

-- -----------------------------------------------------
-- Trigger 
-- -----------------------------------------------------
DELIMITER $$
USE `viveros`$$
CREATE DEFINER = CURRENT_USER TRIGGER `viveros`.`PRODUCTO_EN_PEDIDO_AFTER_INSERT` AFTER INSERT ON `PRODUCTO_EN_PEDIDO` FOR EACH ROW
BEGIN
  UPDATE PRODUCTO SET stock = stock - NEW.cantidad WHERE cod_barras = NEW.cod_barras;
  UPDATE PRODUCTO_EN_ZONA SET stock = stock - NEW.cantidad WHERE cod_barras = NEW.cod_barras;
END$$

DELIMITER ;


-- -----------------------------------------------------
-- Trigger 
-- -----------------------------------------------------

USE `catastro`;

DELIMITER $$
USE `catastro`$$
CREATE DEFINER = CURRENT_USER TRIGGER `catastro`.`PERSONA_BEFORE_INSERT` BEFORE INSERT ON `PERSONA` FOR EACH ROW
BEGIN
IF NEW.PISO_numero IS NOT NULL AND NEW.VIVIENDA_numero IS NOT NULL THEN
		SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Una persona no puede estar en dos viviendas';
	END IF;

END$$

USE `catastro`$$
CREATE DEFINER = CURRENT_USER TRIGGER `catastro`.`PERSONA_BEFORE_UPDATE` BEFORE UPDATE ON `PERSONA` FOR EACH ROW
BEGIN
IF NEW.PISO_numero IS NOT NULL AND NEW.VIVIENDA_numero IS NOT NULL THEN
		SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Una persona no puede estar en dos viviendas';
	END IF;
END$$
