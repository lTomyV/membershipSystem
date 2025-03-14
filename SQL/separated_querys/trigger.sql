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
