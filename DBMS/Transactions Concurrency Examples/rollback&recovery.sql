use Malware_use
go

create or alter procedure addMalware(@name varchar(55), @type varchar(55), @severity varchar(55)) as
	IF (@name is null)
	BEGIN
		RAISERROR('Malware name must not be null', 14, 1);
	END
	IF (@type is null)
	BEGIN
		RAISERROR('Malware type must not be null', 14, 1);
	END
	IF (@severity is null)
	BEGIN
		RAISERROR('Malware severity must not be null', 14, 1);
	END
	INSERT INTO Malware VALUES(@name,@type,@severity)
	EXEC sp_log_changes null, @name, 'Added row to Malware', null
GO

create or alter procedure addVictim(@name varchar(99), @type varchar(66), @location varchar(66)) as
	IF (@name is null)
	BEGIN
		RAISERROR('Victim name must not be null', 14, 1);
	END
	IF (@type is null)
	BEGIN
		RAISERROR('Victim type must not be null', 14, 1);
	END
	IF (@location is null)
	BEGIN
		RAISERROR('Victim location must not be null', 14, 1);
	END
	INSERT INTO Victims VALUES(@name,@type,@location)
	EXEC sp_log_changes null, @name, 'Added row to Victims', null
GO

create or alter procedure addAttack(@date date) as
	IF (@date > GETDATE())
	BEGIN
		RAISERROR('Attack date cannot be in the future', 14, 1);
	END
	DECLARE @MalwareID INT
	SET @MalwareID = (SELECT TOP 1 Mid FROM Malware ORDER BY Mid DESC)
	DECLARE @VictimID INT
	SET @VictimID = (SELECT TOP 1 VicId FROM Victims ORDER BY VicId DESC)
	INSERT INTO Attacks VALUES(@MalwareID, @VictimID, @date)
	Declare @newData varchar(99)
	SET @newData = @MalwareID + ' ' + @VictimID
	EXEC sp_log_changes null, @newData, 'Added row to Attacks', null
GO

CREATE OR ALTER PROCEDURE rollbackSuccess
AS
	BEGIN TRAN
	BEGIN TRY
		EXEC addMalware 'WannaCry','ransomware','high'
		EXEC addVictim 'corleone4','IoT LINUX DEVICE','Australia'
		EXEC addAttack '2017-05-10'
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SELECT 'Error'
		RETURN
	END CATCH
	COMMIT TRAN
GO

CREATE OR ALTER PROCEDURE rollbackFailure
AS
	BEGIN TRAN
	BEGIN TRY
		EXEC addMalware 'WannaCry','ransomware','high'
		EXEC addVictim 'corleone4','IoT LINUX DEVICE','Australia'
		EXEC addAttack '2022-05-10'
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE()
		RETURN
	END CATCH
	COMMIT TRAN
GO

---------------------------------------------------------------------

CREATE OR ALTER PROCEDURE recoverSuccess
AS
	DECLARE @errors INT
	SET @errors = 0
	BEGIN TRY
		EXEC addMalware 'Mirai','botnet','medium'
	END TRY
	BEGIN CATCH
		SET @errors = @errors + 1
	END CATCH

	BEGIN TRY
		EXEC addVictim 'corleone5','INDUSTRIAL FACILITY','Ukraine'
	END TRY
	BEGIN CATCH
		SET @errors = @errors + 1
	END CATCH

	IF @errors = 0 BEGIN
		BEGIN TRY
			EXEC addAttack '2017-05-11'
		END TRY
		BEGIN CATCH 
			SELECT ERROR_MESSAGE()
		END CATCH
	END
GO


CREATE OR ALTER PROCEDURE recoverFailure
AS
	DECLARE @errors INT
	SET @errors = 0
	BEGIN TRY
		EXEC addMalware 'Mirai','botnet','medium'
	END TRY
	BEGIN CATCH
		SET @errors = @errors + 1
	END CATCH

	BEGIN TRY
		EXEC addVictim null,'INDUSTRIAL FACILITY','Ukraine'
	END TRY
	BEGIN CATCH
		SET @errors = @errors + 1
	END CATCH

	IF @errors = 0 BEGIN
		BEGIN TRY
			EXEC addAttack '2017-05-11'
		END TRY
		BEGIN CATCH 
			SELECT ERROR_MESSAGE()
		END CATCH
	END
GO


-- DELETE FROM Malware
-- DELETE FROM Victims
-- DELETE FROM Attacks

exec rollbackSuccess
exec rollbackFailure

exec recoverSuccess
exec recoverFailure

select * from Malware
select * from Victims
select * from Attacks