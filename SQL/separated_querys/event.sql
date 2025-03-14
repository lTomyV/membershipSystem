CREATE DEFINER=`root`@`localhost` EVENT `cleanup_expired_memberships`
	ON SCHEDULE
		EVERY 6 HOUR STARTS '2025-01-01'
	ON COMPLETION NOT PRESERVE
	ENABLE
	COMMENT ''
	DO BEGIN
    -- Eliminar registros de memberships que tengan más de 30 días
    DELETE FROM memberships 
    WHERE date_start < NOW() - INTERVAL 30 DAY;

    -- Actualizar membership en players si ya no tienen una membresía en memberships
    UPDATE players 
    SET membership = NULL 
    WHERE citizenid NOT IN (SELECT citizenid FROM memberships);
END