SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `home_assistant` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `home_assistant` ;

-- -----------------------------------------------------
-- Table `home_assistant`.`usuario`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `home_assistant`.`usuario` (
  `idusuario` INT NOT NULL AUTO_INCREMENT ,
  `usuario` VARCHAR(45) NULL ,
  `password` VARCHAR(45) NULL ,
  `tipo` VARCHAR(45) NULL ,
  `nombre` VARCHAR(45) NULL ,
  PRIMARY KEY (`idusuario`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `home_assistant`.`especialidad`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `home_assistant`.`especialidad` (
  `idespecialidad` INT NOT NULL AUTO_INCREMENT ,
  `descripcion` VARCHAR(45) NULL ,
  PRIMARY KEY (`idespecialidad`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `home_assistant`.`usuario_especialidad`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `home_assistant`.`usuario_especialidad` (
  `idusuario` INT NOT NULL ,
  `idespecialidad` INT NOT NULL ,
  PRIMARY KEY (`idusuario`, `idespecialidad`) ,
  INDEX `fk_usuario_has_especialidad_especialidad1_idx` (`idespecialidad` ASC) ,
  INDEX `fk_usuario_has_especialidad_usuario_idx` (`idusuario` ASC) ,
  CONSTRAINT `fk_usuario_has_especialidad_usuario`
    FOREIGN KEY (`idusuario` )
    REFERENCES `home_assistant`.`usuario` (`idusuario` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_has_especialidad_especialidad1`
    FOREIGN KEY (`idespecialidad` )
    REFERENCES `home_assistant`.`especialidad` (`idespecialidad` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `home_assistant`.`solicitud`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `home_assistant`.`solicitud` (
  `idsolicitud` INT NOT NULL AUTO_INCREMENT ,
  `idusuario` INT NOT NULL ,
  `idespecialidad` INT NOT NULL ,
  `asunto` VARCHAR(45) NULL ,
  `descripcion` VARCHAR(45) NULL ,
  `estado` VARCHAR(45) NULL ,
  PRIMARY KEY (`idsolicitud`) ,
  INDEX `fk_solicitud_usuario1_idx` (`idusuario` ASC) ,
  INDEX `fk_solicitud_especialidad1_idx` (`idespecialidad` ASC) ,
  CONSTRAINT `fk_solicitud_usuario1`
    FOREIGN KEY (`idusuario` )
    REFERENCES `home_assistant`.`usuario` (`idusuario` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_solicitud_especialidad1`
    FOREIGN KEY (`idespecialidad` )
    REFERENCES `home_assistant`.`especialidad` (`idespecialidad` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `home_assistant`.`cotizacion`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `home_assistant`.`cotizacion` (
  `idcotizacion` INT NOT NULL AUTO_INCREMENT ,
  `idsolicitud` INT NOT NULL ,
  `idespecialista` INT NOT NULL ,
  `cotizado` VARCHAR(45) NULL ,
  `precio` VARCHAR(45) NULL ,
  PRIMARY KEY (`idcotizacion`) ,
  INDEX `fk_cotizacion_solicitud1_idx` (`idsolicitud` ASC) ,
  INDEX `fk_cotizacion_usuario1_idx` (`idespecialista` ASC) ,
  CONSTRAINT `fk_cotizacion_solicitud1`
    FOREIGN KEY (`idsolicitud` )
    REFERENCES `home_assistant`.`solicitud` (`idsolicitud` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cotizacion_usuario1`
    FOREIGN KEY (`idespecialista` )
    REFERENCES `home_assistant`.`usuario` (`idusuario` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `home_assistant` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
