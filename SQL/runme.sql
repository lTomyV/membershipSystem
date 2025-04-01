-- 1. Modificar la tabla 'players' para agregar nuevas columnas
ALTER TABLE `players`
    ADD COLUMN `membership` VARCHAR(50) NULL DEFAULT NULL,
    ADD COLUMN `coins` INT NULL DEFAULT '0';

-- 2. Crear la tabla 'memberships'
CREATE TABLE `memberships` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `citizenid` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
    `date_start` DATETIME NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `citizenid` (`citizenid`) USING BTREE,
    CONSTRAINT `FK1_players_citizenid` FOREIGN KEY (`citizenid`) REFERENCES `players` (`citizenid`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB;

-- 3. Crear el trigger para actualizar o insertar registros en 'memberships' tras cambios en 'players'
DELIMITER //
CREATE TRIGGER after_membership_update
AFTER UPDATE ON players
FOR EACH ROW
BEGIN
    -- Verifica si la columna 'membership' cambió
    IF OLD.membership <> NEW.membership THEN
        -- Si ya existe un registro en memberships, actualiza la fecha de inicio
        IF EXISTS (SELECT 1 FROM memberships WHERE citizenid = NEW.citizenid) THEN
            UPDATE memberships 
            SET date_start = NOW() 
            WHERE citizenid = NEW.citizenid;
        ELSE
            -- Si no existe, inserta un nuevo registro
            INSERT INTO memberships (citizenid, date_start) 
            VALUES (NEW.citizenid, NOW());
        END IF;
    END IF;
END;
//
DELIMITER ;

-- 4. Crear el evento para limpiar registros antiguos en 'memberships'
DELIMITER $$

CREATE DEFINER=`root`@`localhost` EVENT `cleanup_expired_memberships`
ON SCHEDULE 
    EVERY 6 HOUR STARTS '2025-01-01'
ON COMPLETION NOT PRESERVE
ENABLE
COMMENT ''
DO 
BEGIN
    -- Eliminar registros de memberships que tengan más de 30 días
    DELETE FROM memberships 
    WHERE date_start < NOW() - INTERVAL 30 DAY;

    -- Actualizar membership en players si ya no tienen una membresía en memberships
    UPDATE players 
    SET membership = NULL 
    WHERE citizenid NOT IN (SELECT citizenid FROM memberships);
END $$

DELIMITER ;
