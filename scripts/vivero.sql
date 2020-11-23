-- MySQL Script generated by MySQL Workbench
-- Sun Nov 22 20:22:10 2020
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema viveros
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema viveros
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `viveros` DEFAULT CHARACTER SET utf8 ;
USE `viveros` ;

-- -----------------------------------------------------
-- Table `viveros`.`VIVERO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `viveros`.`VIVERO` (
  `nombre` VARCHAR(45) NOT NULL,
  `hora_apertura` VARCHAR(45) NULL,
  `hora_cierre` VARCHAR(45) NULL,
  PRIMARY KEY (`nombre`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `viveros`.`ZONAS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `viveros`.`ZONAS` (
  `nombre_zona` VARCHAR(45) NOT NULL,
  `nombre_vivero` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`nombre_zona`, `nombre_vivero`),
  INDEX `fk_ZONAS_VIVERO_idx` (`nombre_vivero` ASC),
  CONSTRAINT `fk_ZONAS_VIVERO`
    FOREIGN KEY (`nombre_vivero`)
    REFERENCES `viveros`.`VIVERO` (`nombre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `viveros`.`PRODUCTO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `viveros`.`PRODUCTO` (
  `cod_barras` INT NOT NULL,
  `precio` DECIMAL NULL,
  `stock` INT NULL,
  `tipo` VARCHAR(45) NULL,
  `caducidad` VARCHAR(45) NULL,
  `nombre` VARCHAR(45) NULL,
  PRIMARY KEY (`cod_barras`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `viveros`.`CLIENTE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `viveros`.`CLIENTE` (
  `dni` VARCHAR(45) NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `num_cliente` INT NOT NULL,
  `num_tarjeta` VARCHAR(45) NULL,
  `gasto_mensual` DECIMAL NULL,
  `bonificacion` DECIMAL NULL,
  `dominio` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NULL,
  PRIMARY KEY (`dni`),
  UNIQUE INDEX `num_cliente_UNIQUE` (`num_cliente` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `viveros`.`EMPLEADO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `viveros`.`EMPLEADO` (
  `dni` VARCHAR(45) NOT NULL,
  `tarjeta_ss` VARCHAR(45) NOT NULL,
  `nombre` VARCHAR(45) NULL,
  `horario` VARCHAR(45) NULL,
  PRIMARY KEY (`dni`),
  UNIQUE INDEX `tarjeta_ss_UNIQUE` (`tarjeta_ss` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `viveros`.`PEDIDO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `viveros`.`PEDIDO` (
  `num_pedido` INT NOT NULL,
  `fecha` VARCHAR(45) NULL,
  `importe` DECIMAL NULL,
  `CLIENTE_dni` VARCHAR(45) NOT NULL,
  `EMPLEADO_dni` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`num_pedido`),
  INDEX `fk_PEDIDO_CLIENTE1_idx` (`CLIENTE_dni` ASC),
  INDEX `fk_PEDIDO_EMPLEADO1_idx` (`EMPLEADO_dni` ASC),
  CONSTRAINT `fk_PEDIDO_CLIENTE1`
    FOREIGN KEY (`CLIENTE_dni`)
    REFERENCES `viveros`.`CLIENTE` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PEDIDO_EMPLEADO1`
    FOREIGN KEY (`EMPLEADO_dni`)
    REFERENCES `viveros`.`EMPLEADO` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `viveros`.`EMPLEADO_EN_ZONA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `viveros`.`EMPLEADO_EN_ZONA` (
  `nombre_zona` VARCHAR(45) NOT NULL,
  `nombre_vivero` VARCHAR(45) NOT NULL,
  `EMPLEADO_dni` VARCHAR(45) NOT NULL,
  `fecha_inicio` VARCHAR(45) NULL,
  `fecha_fin` VARCHAR(45) NULL,
  PRIMARY KEY (`nombre_zona`, `nombre_vivero`, `EMPLEADO_dni`),
  INDEX `fk_ZONAS_has_EMPLEADO_EMPLEADO1_idx` (`EMPLEADO_dni` ASC),
  INDEX `fk_ZONAS_has_EMPLEADO_ZONAS1_idx` (`nombre_zona` ASC, `nombre_vivero` ASC),
  CONSTRAINT `fk_ZONAS_has_EMPLEADO_ZONAS1`
    FOREIGN KEY (`nombre_zona` , `nombre_vivero`)
    REFERENCES `viveros`.`ZONAS` (`nombre_zona` , `nombre_vivero`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ZONAS_has_EMPLEADO_EMPLEADO1`
    FOREIGN KEY (`EMPLEADO_dni`)
    REFERENCES `viveros`.`EMPLEADO` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `viveros`.`PRODUCTO_EN_ZONA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `viveros`.`PRODUCTO_EN_ZONA` (
  `nombre_zona` VARCHAR(45) NOT NULL,
  `nombre_vivero` VARCHAR(45) NOT NULL,
  `cod_barras` INT NOT NULL,
  `stock` INT NULL,
  PRIMARY KEY (`nombre_zona`, `nombre_vivero`, `cod_barras`),
  INDEX `fk_ZONAS_has_PRODUCTO_PRODUCTO1_idx` (`cod_barras` ASC),
  INDEX `fk_ZONAS_has_PRODUCTO_ZONAS1_idx` (`nombre_zona` ASC, `nombre_vivero` ASC),
  CONSTRAINT `fk_ZONAS_has_PRODUCTO_ZONAS1`
    FOREIGN KEY (`nombre_zona` , `nombre_vivero`)
    REFERENCES `viveros`.`ZONAS` (`nombre_zona` , `nombre_vivero`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ZONAS_has_PRODUCTO_PRODUCTO1`
    FOREIGN KEY (`cod_barras`)
    REFERENCES `viveros`.`PRODUCTO` (`cod_barras`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `viveros`.`PRODUCTO_EN_PEDIDO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `viveros`.`PRODUCTO_EN_PEDIDO` (
  `cod_barras` INT NOT NULL,
  `num_pedido` INT NOT NULL,
  `cantidad` INT NULL,
  PRIMARY KEY (`cod_barras`, `num_pedido`),
  INDEX `fk_PRODUCTO_has_PEDIDO_PEDIDO1_idx` (`num_pedido` ASC),
  INDEX `fk_PRODUCTO_has_PEDIDO_PRODUCTO1_idx` (`cod_barras` ASC),
  CONSTRAINT `fk_PRODUCTO_has_PEDIDO_PRODUCTO1`
    FOREIGN KEY (`cod_barras`)
    REFERENCES `viveros`.`PRODUCTO` (`cod_barras`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PRODUCTO_has_PEDIDO_PEDIDO1`
    FOREIGN KEY (`num_pedido`)
    REFERENCES `viveros`.`PEDIDO` (`num_pedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `viveros` ;

-- -----------------------------------------------------
-- procedure crear_email
-- -----------------------------------------------------

DELIMITER $$
USE `viveros`$$
CREATE PROCEDURE crear_email(IN nombre VARCHAR(45), IN dominio VARCHAR(45), OUT email VARCHAR(45))
BEGIN
  SELECT CONCAT(nombre, '@', dominio) INTO email;
END$$

DELIMITER ;
USE `viveros`;

DELIMITER $$
USE `viveros`$$
CREATE DEFINER = CURRENT_USER TRIGGER `viveros`.`CLIENTE_BEFORE_INSERT` BEFORE INSERT ON `CLIENTE` FOR EACH ROW
BEGIN
	IF NEW.email IS NULL THEN
		CALL crear_email(NEW.nombre, NEW.dominio, @email);
		SET NEW.email = @email;
	END IF;
    
END$$

USE `viveros`$$
CREATE DEFINER = CURRENT_USER TRIGGER `viveros`.`PRODUCTO_EN_PEDIDO_AFTER_INSERT` AFTER INSERT ON `PRODUCTO_EN_PEDIDO` FOR EACH ROW
BEGIN
	UPDATE PRODUCTO SET stock = stock - NEW.cantidad WHERE cod_barras = NEW.cod_barras;
  UPDATE PRODUCTO_EN_ZONA SET stock = stock - NEW.cantidad WHERE cod_barras = NEW.cod_barras;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `viveros`.`VIVERO`
-- -----------------------------------------------------
START TRANSACTION;
USE `viveros`;
INSERT INTO `viveros`.`VIVERO` (`nombre`, `hora_apertura`, `hora_cierre`) VALUES ('Güimar', '08:00', '22:00');
INSERT INTO `viveros`.`VIVERO` (`nombre`, `hora_apertura`, `hora_cierre`) VALUES ('La Laguna', '10:00', '20:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `viveros`.`ZONAS`
-- -----------------------------------------------------
START TRANSACTION;
USE `viveros`;
INSERT INTO `viveros`.`ZONAS` (`nombre_zona`, `nombre_vivero`) VALUES ('Almacén', 'Güimar');
INSERT INTO `viveros`.`ZONAS` (`nombre_zona`, `nombre_vivero`) VALUES ('Cajas', 'Güimar');
INSERT INTO `viveros`.`ZONAS` (`nombre_zona`, `nombre_vivero`) VALUES ('Almacén', 'La Laguna');
INSERT INTO `viveros`.`ZONAS` (`nombre_zona`, `nombre_vivero`) VALUES ('Cajas', 'La Laguna');

COMMIT;


-- -----------------------------------------------------
-- Data for table `viveros`.`PRODUCTO`
-- -----------------------------------------------------
START TRANSACTION;
USE `viveros`;
INSERT INTO `viveros`.`PRODUCTO` (`cod_barras`, `precio`, `stock`, `tipo`, `caducidad`, `nombre`) VALUES (0101, 2.5, 50, 'Flor', '2023-10-05', 'Violeta');
INSERT INTO `viveros`.`PRODUCTO` (`cod_barras`, `precio`, `stock`, `tipo`, `caducidad`, `nombre`) VALUES (0202, 50, 15, 'Árbol', '2020-12-12', 'Pino');

COMMIT;


-- -----------------------------------------------------
-- Data for table `viveros`.`CLIENTE`
-- -----------------------------------------------------
START TRANSACTION;
USE `viveros`;
INSERT INTO `viveros`.`CLIENTE` (`dni`, `nombre`, `num_cliente`, `num_tarjeta`, `gasto_mensual`, `bonificacion`, `dominio`, `email`) VALUES ('1111', 'Pedro', 1, '11111', NULL, 0.25, 'gmail.com', NULL);
INSERT INTO `viveros`.`CLIENTE` (`dni`, `nombre`, `num_cliente`, `num_tarjeta`, `gasto_mensual`, `bonificacion`, `dominio`, `email`) VALUES ('2222', 'Julia', 2, '22222', NULL, 0.30, 'hotmail.com', NULL);
INSERT INTO `viveros`.`CLIENTE` (`dni`, `nombre`, `num_cliente`, `num_tarjeta`, `gasto_mensual`, `bonificacion`, `dominio`, `email`) VALUES ('3333', 'Cat', 3, '33333', NULL, 0.78, 'ull.edu.es', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `viveros`.`EMPLEADO`
-- -----------------------------------------------------
START TRANSACTION;
USE `viveros`;
INSERT INTO `viveros`.`EMPLEADO` (`dni`, `tarjeta_ss`, `nombre`, `horario`) VALUES ('3333', '3333C', 'Cat Mouse', '08:00 - 16:00');
INSERT INTO `viveros`.`EMPLEADO` (`dni`, `tarjeta_ss`, `nombre`, `horario`) VALUES ('4444', '4444D', 'Jaime Rosa', '09:50 - 17:50');
INSERT INTO `viveros`.`EMPLEADO` (`dni`, `tarjeta_ss`, `nombre`, `horario`) VALUES ('5555', '5555E', 'Alex Smith', '16:00 - 00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `viveros`.`PEDIDO`
-- -----------------------------------------------------
START TRANSACTION;
USE `viveros`;
INSERT INTO `viveros`.`PEDIDO` (`num_pedido`, `fecha`, `importe`, `CLIENTE_dni`, `EMPLEADO_dni`) VALUES (01, '10-11-2016', 10, '2222', '3333');
INSERT INTO `viveros`.`PEDIDO` (`num_pedido`, `fecha`, `importe`, `CLIENTE_dni`, `EMPLEADO_dni`) VALUES (02, '09-12-2019', 5, '1111', '4444');

COMMIT;


-- -----------------------------------------------------
-- Data for table `viveros`.`PRODUCTO_EN_ZONA`
-- -----------------------------------------------------
START TRANSACTION;
USE `viveros`;
INSERT INTO `viveros`.`PRODUCTO_EN_ZONA` (`nombre_zona`, `nombre_vivero`, `cod_barras`, `stock`) VALUES ('Almacén', 'Güimar', 0101, 50);

COMMIT;

