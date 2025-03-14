CREATE TABLE `memberships` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`citizenid` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
	`date_start` DATETIME NULL DEFAULT current_timestamp(),
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `citizenid` (`citizenid`) USING BTREE,
	CONSTRAINT `FK1_players_citizenid` FOREIGN KEY (`citizenid`) REFERENCES `players` (`citizenid`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;
