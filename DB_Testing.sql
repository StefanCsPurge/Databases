USE Cybersecurity_Company

DELETE FROM Attacks
DELETE FROM Malware
DELETE FROM Victims
DELETE FROM TestTables
DELETE FROM TestViews
DELETE FROM TestRunTables
DELETE FROM TestRunViews
DELETE FROM TestRuns
DBCC CHECKIDENT ('TestRuns', RESEED, 0)

-- DBCC CHECKIDENT ('MalwareAuthors', RESEED, 0) -- reset table IDENTITY KEY after delete
-- SELECT * FROM MalwareAuthors
GO

CREATE OR ALTER VIEW ViewMalware AS
	SELECT Malware.Mid
	FROM Malware INNER JOIN MalwareAuthors ON Malware.Aid = MalwareAuthors.Aid
GO

CREATE OR ALTER VIEW ViewAttacks AS
	SELECT Attacks.Mid
	FROM Attacks INNER JOIN Malware ON Malware.Mid = Attacks.Mid
	GROUP BY Attacks.Mid
GO

CREATE OR ALTER VIEW ViewVictims AS
	SELECT * FROM Victims
GO

DELETE FROM Tables
DBCC CHECKIDENT ('Tables', RESEED, 0)
INSERT INTO Tables VALUES('Malware'),('Attacks'),('Victims')

DELETE FROM Views
DBCC CHECKIDENT ('Views', RESEED, 0)
INSERT INTO Views VALUES('ViewMalware'),('ViewAttacks'),('ViewVictims')

DELETE FROM Tests
DBCC CHECKIDENT ('Tests', RESEED, 0)
INSERT INTO Tests VALUES('selectView'),('insertMalware'),('deleteMalware'),('insertAttacks'),('deleteAttacks'),('insertVictims'),('deleteVictims')

SELECT * FROM Tables 
SELECT * FROM Views
SELECT * FROM Tests

--DELETE FROM TestViews
-- TestID, ViewID
INSERT INTO TestViews VALUES (1,1)
INSERT INTO TestViews VALUES (1,2)
INSERT INTO TestViews VALUES (1,3)

SELECT * FROM TestViews

--DELETE FROM TestTables
-- TestID, TableID, NoOfRows(how many records to insert), Position (denotes the order of execution)

-- insert tests
INSERT INTO TestTables VALUES (2,1,1000,3) -- insert in Malware
INSERT INTO TestTables VALUES (4,2,1000,1) -- insert in Attacks
INSERT INTO TestTables VALUES (6,3,1000,2) -- insert in Victims

SELECT * FROM TestTables

GO
CREATE OR ALTER PROC insertMalware AS
	DECLARE @crt INT = 1
	DECLARE @rows INT
	DECLARE @FK INT
	SET @FK = (SELECT TOP 1 Aid FROM MalwareAuthors)
	SELECT @rows = NoOfRows FROM TestTables WHERE TestID = 2
	WHILE @crt <= @rows
	BEGIN
			INSERT INTO Malware VALUES('name'+CAST(@crt AS varchar(5)), 'type'+CAST(@crt AS varchar(5)), @FK, 'severity'+CAST(@crt AS varchar(5)), NULL)
			SET @crt = @crt + 1
	END

GO
CREATE OR ALTER PROC deleteMalware AS
	DELETE FROM Malware


GO
CREATE OR ALTER PROC insertVictims AS
	DECLARE @crt INT = 1
	DECLARE @rows INT
	SELECT @rows = NoOfRows FROM TestTables WHERE TestID = 6
	WHILE @crt <= @rows
	BEGIN
			INSERT INTO Victims VALUES ('type'++CAST(@crt AS varchar(5)),'location'+CAST(@crt AS varchar(5)))
			SET @crt = @crt + 1
	END

GO
CREATE OR ALTER PROC deleteVictims AS
	DELETE FROM Victims

GO
CREATE OR ALTER PROC insertAttacks AS
	BEGIN
		INSERT INTO Attacks
		SELECT Mid,VicId,NULL
		FROM Malware CROSS JOIN Victims
	END

GO
CREATE OR ALTER PROC deleteAttacks AS
	DELETE FROM Attacks

SELECT * FROM Views

GO
CREATE OR ALTER PROC TestRunViewsProcedure AS
	DECLARE @start1 DATETIME
	DECLARE @end1 DATETIME

	SET @start1 = GETDATE()
	PRINT ('Executing ViewMalware')
	SELECT * FROM ViewMalware
	SET @end1 = GETDATE()
	INSERT INTO TestRuns VALUES('test_view1',@start1,@end1)
	INSERT INTO TestRunViews VALUES (@@IDENTITY,1,@start1,@end1)

	SET @start1 = GETDATE()
	PRINT ('Executing ViewAttacks')
	SELECT * FROM ViewAttacks
	SET @end1 = GETDATE()
	INSERT INTO TestRuns VALUES('test_view2',@start1,@end1)
	INSERT INTO TestRunViews VALUES (@@IDENTITY,2,@start1,@end1)

	SET @start1 = GETDATE()
	PRINT ('Executing ViewVictims')
	SELECT * FROM ViewVictims
	SET @end1 = GETDATE()
	INSERT INTO TestRuns VALUES('test_view3',@start1,@end1)
	INSERT INTO TestRunViews VALUES (@@IDENTITY,3,@start1,@end1)


GO
CREATE OR ALTER PROC TestRunTablesProcedure AS
	DECLARE @start DATETIME
	DECLARE @end DATETIME

	SET @start = GETDATE()
	PRINT('Deleting data from Malware')
	EXEC deleteMalware
	SET @end = GETDATE()
	INSERT INTO TestRuns VALUES('test_delete_malware',@start,@end)
	INSERT INTO TestRunTables VALUES(@@IDENTITY,1,@start,@end)

	SET @start = GETDATE()
	PRINT('Inserting data in Malware')
	EXEC insertMalware
	SET @end = GETDATE()
	INSERT INTO TestRuns VALUES('test_insert_malware',@start,@end)
	INSERT INTO TestRunTables VALUES(@@IDENTITY,1,@start,@end)

	SET @start = GETDATE()
	PRINT('Deleting data from Victims')
	EXEC deleteVictims
	SET @end = GETDATE()
	INSERT INTO TestRuns VALUES('test_delete_victims',@start,@end)
	INSERT INTO TestRunTables VALUES(@@IDENTITY,3,@start,@end)

	SET @start = GETDATE()
	PRINT('Inserting data in Victims')
	EXEC insertVictims
	SET @end = GETDATE()
	INSERT INTO TestRuns VALUES('test_insert_victims',@start,@end)
	INSERT INTO TestRunTables VALUES(@@IDENTITY,3,@start,@end)

	SET @start = GETDATE()
	PRINT('Deleting data from Attacks')
	EXEC deleteMalware
	SET @end = GETDATE()
	INSERT INTO TestRuns VALUES('test_delete_attacks',@start,@end)
	INSERT INTO TestRunTables VALUES(@@IDENTITY,2,@start,@end)

	SET @start = GETDATE()
	PRINT('Inserting data in Attacks')
	EXEC insertMalware
	SET @end = GETDATE()
	INSERT INTO TestRuns VALUES('test_insert_attacks',@start,@end)
	INSERT INTO TestRunTables VALUES(@@IDENTITY,2,@start,@end)



GO
EXEC TestRunTablesProcedure
EXEC TestRunViewsProcedure

SELECT * FROM TestRuns
SELECT * FROM TestRunViews
SELECT * FROM TestRunTables
-----------------------------
DELETE FROM Attacks
DELETE FROM Malware
DELETE FROM Victims
	
