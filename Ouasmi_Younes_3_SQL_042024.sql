-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema ocpizza2
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ocpizza2
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ocpizza2` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `ocpizza2` ;

-- -----------------------------------------------------
-- Table `ocpizza2`.`Users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza2`.`Users` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NULL DEFAULT NULL,
  `email` VARCHAR(255) NULL DEFAULT NULL,
  `password` VARCHAR(255) NULL DEFAULT NULL,
  `user_type` ENUM('Visitor', 'Customer', 'Manager', 'PizzaChef', 'DeliveryPerson', 'Owner') NOT NULL,
  PRIMARY KEY (`user_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 21
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ocpizza2`.`Customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza2`.`Customer` (
  `user_id` INT NOT NULL,
  `phone_number` VARCHAR(15) NULL DEFAULT NULL,
  INDEX `user_id` (`user_id` ASC) VISIBLE,
  CONSTRAINT `customer_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `ocpizza2`.`Users` (`user_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ocpizza2`.`GPSLocation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza2`.`GPSLocation` (
  `gps_id` INT NOT NULL AUTO_INCREMENT,
  `latitude` DECIMAL(9,6) NOT NULL,
  `longitude` DECIMAL(9,6) NOT NULL,
  PRIMARY KEY (`gps_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 16
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ocpizza2`.`CustomerAddress`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza2`.`CustomerAddress` (
  `address_id` INT NOT NULL AUTO_INCREMENT,
  `customer_id` INT NOT NULL,
  `gps_id` INT NOT NULL,
  `address_type` ENUM('Home', 'Work', 'Other') NOT NULL,
  `last_used` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`address_id`),
  INDEX `customer_id_idx` (`customer_id` ASC) VISIBLE,
  INDEX `gps_id_idx` (`gps_id` ASC) VISIBLE,
  CONSTRAINT `customeraddress_ibfk_1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `ocpizza2`.`Customer` (`user_id`)
    ON DELETE CASCADE,
  CONSTRAINT `customeraddress_ibfk_2`
    FOREIGN KEY (`gps_id`)
    REFERENCES `ocpizza2`.`GPSLocation` (`gps_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ocpizza2`.`Store`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza2`.`Store` (
  `store_id` INT NOT NULL AUTO_INCREMENT,
  `location` VARCHAR(255) NULL DEFAULT NULL,
  `phone_number` VARCHAR(15) NULL DEFAULT NULL,
  `manager_id` INT NULL DEFAULT NULL,
  `gps_location_id` INT NULL DEFAULT NULL,
  PRIMARY KEY (`store_id`),
  INDEX `manager_id` (`manager_id` ASC) VISIBLE,
  INDEX `fk_store_gps_location` (`gps_location_id` ASC) VISIBLE,
  CONSTRAINT `fk_store_gps_location`
    FOREIGN KEY (`gps_location_id`)
    REFERENCES `ocpizza2`.`GPSLocation` (`gps_id`),
  CONSTRAINT `store_ibfk_1`
    FOREIGN KEY (`manager_id`)
    REFERENCES `ocpizza2`.`Users` (`user_id`)
    ON DELETE SET NULL)
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ocpizza2`.`Order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza2`.`Order` (
  `order_id` INT NOT NULL AUTO_INCREMENT,
  `customer_id` INT NOT NULL,
  `date` DATE NULL DEFAULT NULL,
  `status` ENUM('Created', 'Preparing', 'Ready', 'Paid', 'InDelivery', 'Delivered', 'Cancelled', 'Refund') NOT NULL,
  `special_instructions` TEXT NULL DEFAULT NULL,
  `receipt` TEXT NULL DEFAULT NULL,
  `delivery_address_id` INT NULL DEFAULT NULL,
  `delivery_type` ENUM('Delivery', 'Takeaway') NOT NULL DEFAULT 'Takeaway',
  `store_id` INT NULL DEFAULT NULL,
  `payment_method` ENUM('Cash', 'CreditCard', 'OnlinePayment', 'MealVoucher') NULL DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  INDEX `customer_id` (`customer_id` ASC) VISIBLE,
  INDEX `fk_order_delivery_address` (`delivery_address_id` ASC) VISIBLE,
  INDEX `fk_order_store` (`store_id` ASC) VISIBLE,
  CONSTRAINT `fk_order_delivery_address`
    FOREIGN KEY (`delivery_address_id`)
    REFERENCES `ocpizza2`.`CustomerAddress` (`address_id`),
  CONSTRAINT `fk_order_store`
    FOREIGN KEY (`store_id`)
    REFERENCES `ocpizza2`.`Store` (`store_id`),
  CONSTRAINT `order_ibfk_1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `ocpizza2`.`Customer` (`user_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 19
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ocpizza2`.`DeliveryPerson`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza2`.`DeliveryPerson` (
  `delivery_person_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `current_gps_id` INT NULL DEFAULT NULL,
  `phonenumber` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`delivery_person_id`),
  INDEX `user_id` (`user_id` ASC) VISIBLE,
  INDEX `current_gps_id` (`current_gps_id` ASC) VISIBLE,
  CONSTRAINT `deliveryperson_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `ocpizza2`.`Users` (`user_id`)
    ON DELETE CASCADE,
  CONSTRAINT `deliveryperson_ibfk_2`
    FOREIGN KEY (`current_gps_id`)
    REFERENCES `ocpizza2`.`GPSLocation` (`gps_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ocpizza2`.`Delivery`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza2`.`Delivery` (
  `delivery_id` INT NOT NULL AUTO_INCREMENT,
  `order_id` INT NOT NULL,
  `status` ENUM('Pending', 'EnRoute', 'Delivered', 'Cancelled') NOT NULL,
  `real_time_tracking` TINYINT(1) NOT NULL DEFAULT '0',
  `pickup_gps_id` INT NULL DEFAULT NULL,
  `delivery_gps_id` INT NULL DEFAULT NULL,
  `delivery_person_id` INT NULL DEFAULT NULL,
  PRIMARY KEY (`delivery_id`),
  INDEX `order_id` (`order_id` ASC) VISIBLE,
  INDEX `fk_delivery_pickup_gps` (`pickup_gps_id` ASC) VISIBLE,
  INDEX `fk_delivery_delivery_gps` (`delivery_gps_id` ASC) VISIBLE,
  INDEX `fk_delivery_deliveryperson` (`delivery_person_id` ASC) VISIBLE,
  CONSTRAINT `delivery_ibfk_1`
    FOREIGN KEY (`order_id`)
    REFERENCES `ocpizza2`.`Order` (`order_id`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_delivery_delivery_gps`
    FOREIGN KEY (`delivery_gps_id`)
    REFERENCES `ocpizza2`.`GPSLocation` (`gps_id`),
  CONSTRAINT `fk_delivery_deliveryperson`
    FOREIGN KEY (`delivery_person_id`)
    REFERENCES `ocpizza2`.`DeliveryPerson` (`delivery_person_id`),
  CONSTRAINT `fk_delivery_pickup_gps`
    FOREIGN KEY (`pickup_gps_id`)
    REFERENCES `ocpizza2`.`GPSLocation` (`gps_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ocpizza2`.`DeliveryStatusHistory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza2`.`DeliveryStatusHistory` (
  `status_history_id` INT NOT NULL AUTO_INCREMENT,
  `delivery_id` INT NOT NULL,
  `status` ENUM('Pending', 'EnRoute', 'Delivered', 'Cancelled') NOT NULL,
  `changed_on` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`status_history_id`),
  INDEX `delivery_id` (`delivery_id` ASC) VISIBLE,
  CONSTRAINT `deliverystatushistory_ibfk_1`
    FOREIGN KEY (`delivery_id`)
    REFERENCES `ocpizza2`.`Delivery` (`delivery_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ocpizza2`.`Ingredient`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza2`.`Ingredient` (
  `ingredient_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`ingredient_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 25
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ocpizza2`.`Menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza2`.`Menu` (
  `menu_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `available_from` DATETIME NULL DEFAULT NULL,
  `available_until` DATETIME NULL DEFAULT NULL,
  `active` TINYINT(1) NULL DEFAULT '1',
  PRIMARY KEY (`menu_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ocpizza2`.`Recipe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza2`.`Recipe` (
  `recipe_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NULL DEFAULT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `instructions` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`recipe_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ocpizza2`.`MenuItem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza2`.`MenuItem` (
  `menu_item_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `price` DECIMAL(10,2) NULL DEFAULT NULL,
  `recipe_id` INT NULL DEFAULT NULL,
  `isActive` TINYINT(1) NULL DEFAULT '1',
  PRIMARY KEY (`menu_item_id`),
  INDEX `fk_menuitem_recipe` (`recipe_id` ASC) VISIBLE,
  CONSTRAINT `fk_menuitem_recipe`
    FOREIGN KEY (`recipe_id`)
    REFERENCES `ocpizza2`.`Recipe` (`recipe_id`)
    ON DELETE SET NULL,
  CONSTRAINT `menuitem_ibfk_1`
    FOREIGN KEY (`recipe_id`)
    REFERENCES `ocpizza2`.`Recipe` (`recipe_id`)
    ON DELETE SET NULL)
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ocpizza2`.`MenuItem_Menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza2`.`MenuItem_Menu` (
  `menu_id` INT NOT NULL,
  `menu_item_id` INT NOT NULL,
  PRIMARY KEY (`menu_id`, `menu_item_id`),
  INDEX `menu_item_id` (`menu_item_id` ASC) VISIBLE,
  CONSTRAINT `menuitem_menu_ibfk_1`
    FOREIGN KEY (`menu_id`)
    REFERENCES `ocpizza2`.`Menu` (`menu_id`)
    ON DELETE CASCADE,
  CONSTRAINT `menuitem_menu_ibfk_2`
    FOREIGN KEY (`menu_item_id`)
    REFERENCES `ocpizza2`.`MenuItem` (`menu_item_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ocpizza2`.`OrderItem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza2`.`OrderItem` (
  `order_item_id` INT NOT NULL AUTO_INCREMENT,
  `order_id` INT NOT NULL,
  `menu_item_id` INT NOT NULL,
  `quantity` INT NOT NULL,
  PRIMARY KEY (`order_item_id`),
  INDEX `order_id` (`order_id` ASC) VISIBLE,
  INDEX `menu_item_id` (`menu_item_id` ASC) VISIBLE,
  CONSTRAINT `orderitem_ibfk_1`
    FOREIGN KEY (`order_id`)
    REFERENCES `ocpizza2`.`Order` (`order_id`)
    ON DELETE CASCADE,
  CONSTRAINT `orderitem_ibfk_2`
    FOREIGN KEY (`menu_item_id`)
    REFERENCES `ocpizza2`.`MenuItem` (`menu_item_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ocpizza2`.`OrderStatusHistory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza2`.`OrderStatusHistory` (
  `status_history_id` INT NOT NULL AUTO_INCREMENT,
  `order_id` INT NOT NULL,
  `status` ENUM('Created', 'Preparing', 'Ready', 'Paid', 'InDelivery', 'Delivered', 'Cancelled', 'Refund') NOT NULL,
  `changed_on` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`status_history_id`),
  INDEX `order_id` (`order_id` ASC) VISIBLE,
  CONSTRAINT `orderstatushistory_ibfk_1`
    FOREIGN KEY (`order_id`)
    REFERENCES `ocpizza2`.`Order` (`order_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 19
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ocpizza2`.`PerformanceMetrics`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza2`.`PerformanceMetrics` (
  `metric_id` INT NOT NULL AUTO_INCREMENT,
  `store_id` INT NOT NULL,
  `metric` VARCHAR(255) NULL DEFAULT NULL,
  `category` ENUM('Sales', 'CustomerSatisfaction', 'InventoryTurnover', 'DeliveryEfficiency') NOT NULL,
  `value` DECIMAL(10,2) NULL DEFAULT NULL,
  `date` DATE NULL DEFAULT NULL,
  `details` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`metric_id`),
  INDEX `store_id` (`store_id` ASC) VISIBLE,
  CONSTRAINT `performancemetrics_ibfk_1`
    FOREIGN KEY (`store_id`)
    REFERENCES `ocpizza2`.`Store` (`store_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ocpizza2`.`RecipeIngredient`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza2`.`RecipeIngredient` (
  `recipe_ingredient_id` INT NOT NULL AUTO_INCREMENT,
  `recipe_id` INT NOT NULL,
  `ingredient_id` INT NOT NULL,
  `quantity` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`recipe_ingredient_id`),
  INDEX `recipe_id` (`recipe_id` ASC) VISIBLE,
  INDEX `ingredient_id` (`ingredient_id` ASC) VISIBLE,
  CONSTRAINT `recipeingredient_ibfk_1`
    FOREIGN KEY (`recipe_id`)
    REFERENCES `ocpizza2`.`Recipe` (`recipe_id`)
    ON DELETE CASCADE,
  CONSTRAINT `recipeingredient_ibfk_2`
    FOREIGN KEY (`ingredient_id`)
    REFERENCES `ocpizza2`.`Ingredient` (`ingredient_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 33
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ocpizza2`.`Stock`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza2`.`Stock` (
  `stock_id` INT NOT NULL AUTO_INCREMENT,
  `ingredient_id` INT NOT NULL,
  `quantity` DECIMAL(10,2) NULL DEFAULT NULL,
  `store_id` INT NOT NULL,
  PRIMARY KEY (`stock_id`),
  INDEX `ingredient_id` (`ingredient_id` ASC) VISIBLE,
  INDEX `store_id` (`store_id` ASC) VISIBLE,
  CONSTRAINT `stock_ibfk_1`
    FOREIGN KEY (`ingredient_id`)
    REFERENCES `ocpizza2`.`Ingredient` (`ingredient_id`)
    ON DELETE CASCADE,
  CONSTRAINT `stock_ibfk_2`
    FOREIGN KEY (`store_id`)
    REFERENCES `ocpizza2`.`Store` (`store_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 121
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ocpizza2`.`StoreEmployee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza2`.`StoreEmployee` (
  `store_employee_id` INT NOT NULL AUTO_INCREMENT,
  `store_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `user_type` ENUM('Visitor', 'Customer', 'Manager', 'PizzaChef', 'DeliveryPerson', 'Owner') NULL DEFAULT NULL,
  PRIMARY KEY (`store_employee_id`),
  INDEX `store_id` (`store_id` ASC) VISIBLE,
  INDEX `user_id` (`user_id` ASC) VISIBLE,
  CONSTRAINT `storeemployee_ibfk_1`
    FOREIGN KEY (`store_id`)
    REFERENCES `ocpizza2`.`Store` (`store_id`)
    ON DELETE CASCADE,
  CONSTRAINT `storeemployee_ibfk_2`
    FOREIGN KEY (`user_id`)
    REFERENCES `ocpizza2`.`Users` (`user_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ocpizza2`.`StoreMenu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza2`.`StoreMenu` (
  `store_menu_id` INT NOT NULL AUTO_INCREMENT,
  `store_id` INT NOT NULL,
  `menu_id` INT NOT NULL,
  PRIMARY KEY (`store_menu_id`),
  INDEX `store_id` (`store_id` ASC) VISIBLE,
  INDEX `menu_id` (`menu_id` ASC) VISIBLE,
  CONSTRAINT `storemenu_ibfk_1`
    FOREIGN KEY (`store_id`)
    REFERENCES `ocpizza2`.`Store` (`store_id`)
    ON DELETE CASCADE,
  CONSTRAINT `storemenu_ibfk_2`
    FOREIGN KEY (`menu_id`)
    REFERENCES `ocpizza2`.`Menu` (`menu_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 21
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ocpizza2`.`StoreMenuItems`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ocpizza2`.`StoreMenuItems` (
  `store_menu_item_id` INT NOT NULL AUTO_INCREMENT,
  `store_id` INT NOT NULL,
  `menu_item_id` INT NOT NULL,
  `active` TINYINT(1) NULL DEFAULT '1',
  PRIMARY KEY (`store_menu_item_id`),
  INDEX `store_id` (`store_id` ASC) VISIBLE,
  INDEX `menu_item_id` (`menu_item_id` ASC) VISIBLE,
  CONSTRAINT `storemenuitems_ibfk_1`
    FOREIGN KEY (`store_id`)
    REFERENCES `ocpizza2`.`Store` (`store_id`)
    ON DELETE CASCADE,
  CONSTRAINT `storemenuitems_ibfk_2`
    FOREIGN KEY (`menu_item_id`)
    REFERENCES `ocpizza2`.`MenuItem` (`menu_item_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 68
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `ocpizza2` ;

-- -----------------------------------------------------
-- procedure FetchIngredientsNeeded
-- -----------------------------------------------------

DELIMITER $$
USE `ocpizza2`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `FetchIngredientsNeeded`(orderId INT)
BEGIN
    DECLARE ingredient_id INT;
    DECLARE needed_quantity DECIMAL(10,2);
    DECLARE done INT DEFAULT 0;

    DECLARE recipe_cursor CURSOR FOR 
        SELECT ri.ingredient_id, SUM(ri.quantity * oi.quantity) AS needed
        FROM OrderItem oi
        JOIN MenuItem mi ON oi.menu_item_id = mi.menu_item_id
        JOIN RecipeIngredient ri ON mi.recipe_id = ri.recipe_id
        WHERE oi.order_id = orderId
        GROUP BY ri.ingredient_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN recipe_cursor;

    fetch_loop: LOOP
        FETCH recipe_cursor INTO ingredient_id, needed_quantity;
        IF done THEN
            LEAVE fetch_loop;
        END IF;
        -- Pour voir les résultats, vous pouvez choisir de les afficher, par exemple:
        SELECT ingredient_id, needed_quantity;
    END LOOP;

    CLOSE recipe_cursor;
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
USE `ocpizza2`;

DELIMITER $$
USE `ocpizza2`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `ocpizza2`.`RecordOrderStatusChange`
AFTER UPDATE ON `ocpizza2`.`Order`
FOR EACH ROW
BEGIN
    -- Vérifier si le statut a changé
    IF NEW.status <> OLD.status THEN
        -- Insérer l'enregistrement du changement de statut dans OrderStatusHistory
        INSERT INTO OrderStatusHistory (order_id, status, changed_on)
        VALUES (NEW.order_id, NEW.status, NOW());
    END IF;
END$$

USE `ocpizza2`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `ocpizza2`.`after_order_ready`
AFTER UPDATE ON `ocpizza2`.`Order`
FOR EACH ROW
BEGIN
    -- Déclarer les variables avant toute opération
    DECLARE pickupGpsId INT;
    DECLARE deliveryGpsId INT;

    -- Vérifier le changement de statut vers 'Ready'
    IF NEW.status = 'Ready' AND OLD.status != 'Ready' THEN
        -- Récupérer l'ID GPS du magasin
        SELECT gps_location_id INTO pickupGpsId FROM Store WHERE store_id = NEW.store_id;
        -- Récupérer l'ID GPS de l'adresse de livraison
        SELECT gps_id INTO deliveryGpsId FROM CustomerAddress WHERE address_id = NEW.delivery_address_id;

        -- Insérer dans la table Delivery
        INSERT INTO Delivery (order_id, pickup_gps_id, delivery_gps_id, status, real_time_tracking)
        VALUES (NEW.order_id, pickupGpsId, deliveryGpsId, 'Pending', 0);
    END IF;
END$$

USE `ocpizza2`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `ocpizza2`.`after_delivery_update`
AFTER UPDATE ON `ocpizza2`.`Delivery`
FOR EACH ROW
BEGIN
    IF NEW.status <> OLD.status THEN
        INSERT INTO `DeliveryStatusHistory` (delivery_id, status)
        VALUES (NEW.delivery_id, NEW.status);
    END IF;
END$$

USE `ocpizza2`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `ocpizza2`.`UpdateStockOnPreparing`
AFTER UPDATE ON `ocpizza2`.`OrderStatusHistory`
FOR EACH ROW
BEGIN
    -- Vérifier si le statut a changé pour 'Preparing'
    IF NEW.status = 'Preparing' AND OLD.status <> 'Preparing' THEN
        -- Mettre à jour le stock basé sur les items commandés
        UPDATE Stock s
        JOIN (
            SELECT 
                ri.ingredient_id,
                SUM(ri.quantity * oi.quantity) AS total_needed,
                o.store_id
            FROM `Order` o
            JOIN OrderItem oi ON o.order_id = NEW.order_id
            JOIN MenuItem mi ON oi.menu_item_id = mi.menu_item_id
            JOIN RecipeIngredient ri ON mi.recipe_id = ri.recipe_id
            GROUP BY ri.ingredient_id, o.store_id
        ) AS needed ON s.ingredient_id = needed.ingredient_id AND s.store_id = needed.store_id
        SET s.quantity = s.quantity - needed.total_needed
        WHERE s.quantity >= needed.total_needed;
    END IF;
END$$

USE `ocpizza2`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `ocpizza2`.`DisableStoreMenuItemsWhenStockDepleted`
AFTER UPDATE ON `ocpizza2`.`Stock`
FOR EACH ROW
BEGIN
    IF NEW.quantity = 0 THEN
        -- Mettre à jour uniquement les entrées de StoreMenuItems pour le magasin spécifique où le stock est épuisé
        UPDATE StoreMenuItems smi
        JOIN MenuItem mi ON smi.menu_item_id = mi.menu_item_id
        JOIN RecipeIngredient ri ON mi.recipe_id = ri.recipe_id
        JOIN Stock s ON s.ingredient_id = ri.ingredient_id AND s.store_id = smi.store_id
        SET smi.active = FALSE
        WHERE ri.ingredient_id = NEW.ingredient_id AND s.store_id = NEW.store_id;
    END IF;
END$$

USE `ocpizza2`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `ocpizza2`.`ReactivateStoreMenuItemsWhenStockReplenished`
AFTER UPDATE ON `ocpizza2`.`Stock`
FOR EACH ROW
BEGIN
    IF OLD.quantity = 0 AND NEW.quantity > 0 THEN
        -- Réactiver les entrées de StoreMenuItems pour le magasin spécifique où le stock est réapprovisionné
        UPDATE StoreMenuItems smi
        JOIN MenuItem mi ON smi.menu_item_id = mi.menu_item_id
        JOIN RecipeIngredient ri ON mi.recipe_id = ri.recipe_id
        JOIN Stock s ON s.ingredient_id = ri.ingredient_id AND s.store_id = smi.store_id
        SET smi.active = TRUE
        WHERE ri.ingredient_id = NEW.ingredient_id AND s.store_id = NEW.store_id;
    END IF;
END$$


DELIMITER ;
