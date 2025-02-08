CREATE TABLE `mms_crates` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`crateid` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'armscii8_general_ci',
	`identifier` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'armscii8_general_ci',
	`charidentifier` INT(11) NOT NULL DEFAULT '0',
	`name` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'armscii8_general_ci',
	`model` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'armscii8_general_ci',
	`inventory` INT(11) NOT NULL DEFAULT '0',
	`size` INT(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='armscii8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=2
;


INSERT INTO `items`(`item`, `label`, `limit`, `can_remove`, `type`, `usable`) VALUES ('Crate1', 'Crate Small', 10, 1, 'item_standard', 1)
ON DUPLICATE KEY UPDATE `item`='Crate1', `label`='Crate Small', `limit`=10, `can_remove`=1, `type`='item_standard', `usable`=1;

INSERT INTO `items`(`item`, `label`, `limit`, `can_remove`, `type`, `usable`) VALUES ('Crate1S', 'Crate Small', 10, 1, 'item_standard', 1)
ON DUPLICATE KEY UPDATE `item`='Crate1', `label`='Crate Small', `limit`=10, `can_remove`=1, `type`='item_standard', `usable`=1;

INSERT INTO `items`(`item`, `label`, `limit`, `can_remove`, `type`, `usable`) VALUES ('Crate2', 'Crate Medium', 10, 1, 'item_standard', 1)
ON DUPLICATE KEY UPDATE `item`='Crate1', `label`='Crate Small', `limit`=10, `can_remove`=1, `type`='item_standard', `usable`=1;

INSERT INTO `items`(`item`, `label`, `limit`, `can_remove`, `type`, `usable`) VALUES ('Crate2M', 'Crate Medium', 10, 1, 'item_standard', 1)
ON DUPLICATE KEY UPDATE `item`='Crate1', `label`='Crate Small', `limit`=10, `can_remove`=1, `type`='item_standard', `usable`=1;

INSERT INTO `items`(`item`, `label`, `limit`, `can_remove`, `type`, `usable`) VALUES ('Crate3', 'Crate Big', 10, 1, 'item_standard', 1)
ON DUPLICATE KEY UPDATE `item`='Crate1', `label`='Crate Small', `limit`=10, `can_remove`=1, `type`='item_standard', `usable`=1;

INSERT INTO `items`(`item`, `label`, `limit`, `can_remove`, `type`, `usable`) VALUES ('Crate3B', 'Crate Big', 10, 1, 'item_standard', 1)
ON DUPLICATE KEY UPDATE `item`='Crate1', `label`='Crate Small', `limit`=10, `can_remove`=1, `type`='item_standard', `usable`=1;

