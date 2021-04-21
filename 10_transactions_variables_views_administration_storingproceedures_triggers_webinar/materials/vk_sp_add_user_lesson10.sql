DROP PROCEDURE IF EXISTS vk.sp_user_add;

DELIMITER $$
$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `vk`.`sp_user_add`(
firstname varchar(100), lastname varchar(100), email varchar(100), 
phone varchar(100), hometown varchar(50), photo_id INT,
OUT  tran_result varchar(100))
BEGIN
	
	DECLARE `_rollback` BIT DEFAULT 0;
	DECLARE code varchar(100);
	DECLARE error_string varchar(100); 


	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
 		SET `_rollback` = 1;
 		GET stacked DIAGNOSTICS CONDITION 1
			code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
		SET tran_result = concat('УПС. Ошибка: ', code, ' Текст ошибки: ', error_string);
	END;

	START TRANSACTION;
	 INSERT INTO users (firstname, lastname, email, phone)
	 VALUES (firstname, lastname, email, phone);
	
	
	-- SET @last_user_id = last_insert_id();
	
	INSERT INTO profiles (user_id, hometown, photo_id)
	VALUES (last_insert_id(), hometown, photo_id);
	
	IF `_rollback` THEN
		-- SET tran_result = 'ROLLBACK';
		ROLLBACK;
	ELSE
		SET tran_result = 'O K';
		COMMIT;
	END IF;
END$$
DELIMITER ;
