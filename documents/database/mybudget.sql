SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';


-- -----------------------------------------------------
-- Table `ci_sessions`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `ci_sessions` (
  `session_id` VARCHAR(40) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL DEFAULT '0' ,
  `ip_address` VARCHAR(16) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL DEFAULT '0' ,
  `user_agent` VARCHAR(150) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL ,
  `last_activity` INT(10) UNSIGNED NOT NULL DEFAULT '0' ,
  `user_data` TEXT CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL ,
  PRIMARY KEY (`session_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin;


-- -----------------------------------------------------
-- Table `login_attempts`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `login_attempts` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `ip_address` VARCHAR(40) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL ,
  `login` VARCHAR(50) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL ,
  `time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin;


-- -----------------------------------------------------
-- Table `users`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `users` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `username` VARCHAR(50) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL ,
  `password` VARCHAR(255) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL ,
  `email` VARCHAR(100) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL ,
  `activated` TINYINT(1) NOT NULL DEFAULT '1' ,
  `banned` TINYINT(1) NOT NULL DEFAULT '0' ,
  `ban_reason` VARCHAR(255) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NULL DEFAULT NULL ,
  `new_password_key` VARCHAR(50) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NULL DEFAULT NULL ,
  `new_password_requested` DATETIME NULL DEFAULT NULL ,
  `new_email` VARCHAR(100) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NULL DEFAULT NULL ,
  `new_email_key` VARCHAR(50) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NULL DEFAULT NULL ,
  `last_ip` VARCHAR(40) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL ,
  `last_login` DATETIME NOT NULL ,
  `created` DATETIME NOT NULL ,
  `modified` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin;


-- -----------------------------------------------------
-- Table `user_autologin`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `user_autologin` (
  `key_id` CHAR(32) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL ,
  `user_id` INT(11) NOT NULL DEFAULT '0' ,
  `user_agent` VARCHAR(150) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL ,
  `last_ip` VARCHAR(40) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NOT NULL ,
  `last_login` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`key_id`, `user_id`) ,
  INDEX `user_autologin_users_idx` (`user_id` ASC) ,
  CONSTRAINT `fk_user_autologin_users`
    FOREIGN KEY (`user_id` )
    REFERENCES `users` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin;


-- -----------------------------------------------------
-- Table `user_profiles`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `user_profiles` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `user_id` INT(11) NOT NULL ,
  `country` VARCHAR(20) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NULL DEFAULT NULL ,
  `website` VARCHAR(255) CHARACTER SET 'utf8' COLLATE 'utf8_bin' NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_user_profiles_users_idx` (`user_id` ASC) ,
  CONSTRAINT `fk_user_profiles_users`
    FOREIGN KEY (`user_id` )
    REFERENCES `users` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_bin;


-- -----------------------------------------------------
-- Table `category`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `category` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `category_name` VARCHAR(45) NOT NULL ,
  `user_id` INT(11) NOT NULL COMMENT 'Use admin userid for default categories.' ,
  `created_at` DATETIME NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_category_users_idx` (`user_id` ASC) ,
  CONSTRAINT `fk_category_users`
    FOREIGN KEY (`user_id` )
    REFERENCES `users` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `subcategory`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `subcategory` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `category_id` INT(11) NOT NULL ,
  `subcategory_name` VARCHAR(45) NOT NULL ,
  `created_at` DATETIME NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_subcategory_category_idx` (`category_id` ASC) ,
  CONSTRAINT `fk_subcategory_category`
    FOREIGN KEY (`category_id` )
    REFERENCES `category` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `account_type`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `account_type` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `type` VARCHAR(15) NOT NULL ,
  `description` TEXT NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `account`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `account` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `account_name` VARCHAR(45) NOT NULL ,
  `account_type_id` INT(11) NOT NULL ,
  `user_id` INT(11) NOT NULL ,
  `opening_balance` INT(11) NOT NULL DEFAULT 0 ,
  `current_balance` INT(11) NOT NULL DEFAULT 0 ,
  `created_at` DATETIME NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_account_account_type_idx` (`account_type_id` ASC) ,
  INDEX `fk_account_users_idx` (`user_id` ASC) ,
  CONSTRAINT `fk_account_account_type`
    FOREIGN KEY (`account_type_id` )
    REFERENCES `account_type` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_account_users`
    FOREIGN KEY (`user_id` )
    REFERENCES `users` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `transaction_type`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `transaction_type` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `transaction_type` VARCHAR(15) NOT NULL ,
  `description` TEXT NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `register`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `register` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `quickinfo` VARCHAR(50) NOT NULL ,
  `details` VARCHAR(300) NULL ,
  `user_id` INT(11) NOT NULL ,
  `category_id` INT(11) NULL COMMENT 'Required for transaction and Child. Null for other' ,
  `account_from` INT(11) NULL COMMENT 'Required for transaction, Transfer and Parent. Null for Income and child' ,
  `account_to` INT(11) NULL COMMENT 'Required for income and transfer. Null for other.' ,
  `transaction_type_id` INT(11) NOT NULL ,
  `parent_id` INT(11) NULL COMMENT 'In case of transaction split, child will have parent id. Null otherwise' ,
  `total_child` SMALLINT NOT NULL DEFAULT 0 COMMENT 'In case of transaction split, parent need to remember total number of childs. ' ,
  `created_at` DATETIME NOT NULL ,
  `transaction_datetime` DATETIME NOT NULL COMMENT 'By default, transaction time will be the time when it added to the system. However if user forget to made some transaction of previous date, he can do so by setting transaction datetime manually.' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_register_users_idx` (`user_id` ASC) ,
  INDEX `fk_register_category_idx` (`category_id` ASC) ,
  INDEX `fk_register_account_from_idx` (`account_from` ASC) ,
  INDEX `fk_register_account_to_idx` (`account_to` ASC) ,
  INDEX `fk_register_transaction_type_idx` (`transaction_type_id` ASC) ,
  INDEX `ind_trx_datetime` (`transaction_datetime` ASC) ,
  CONSTRAINT `fk_register_users`
    FOREIGN KEY (`user_id` )
    REFERENCES `users` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_register_category`
    FOREIGN KEY (`category_id` )
    REFERENCES `subcategory` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_register_account_from`
    FOREIGN KEY (`account_from` )
    REFERENCES `account` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_register_account_to`
    FOREIGN KEY (`account_to` )
    REFERENCES `account` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_register_transaction_type`
    FOREIGN KEY (`transaction_type_id` )
    REFERENCES `transaction_type` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
