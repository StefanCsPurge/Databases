USE Cybersecurity_Company

-- start version: 0

-- version 1
-- a) Modify the type of a column

GO
CREATE OR ALTER PROCEDURE do_proc_1 AS
BEGIN
	ALTER TABLE HackingTools
	ALTER COLUMN PowerLevel TINYINT
	PRINT 'Do proc 1 done.'
END

-- EXEC do_proc_1

GO
CREATE OR ALTER PROCEDURE undo_proc_1 AS
BEGIN
	ALTER TABLE HackingTools
	ALTER COLUMN PowerLevel INT
	PRINT 'Undo proc 1 done.'
END

-- EXEC undo_proc_1


-- version 2
-- b) Add/remove a column

GO
CREATE OR ALTER PROCEDURE do_proc_2 AS
BEGIN
	ALTER TABLE HackingTools
	ADD Size INT
	PRINT 'Do proc 2 done.'
END

GO
CREATE OR ALTER PROCEDURE undo_proc_2 AS
BEGIN
	ALTER TABLE HackingTools
	DROP COLUMN Size
	PRINT 'Undo proc 2 done.'
END


-- version 3
-- c) Add/remove a DEFAULT constraint

GO
CREATE OR ALTER PROCEDURE do_proc_3 AS
BEGIN
	ALTER TABLE HackingTools
	ADD CONSTRAINT df_pwlev1 DEFAULT 1 FOR PowerLevel
	PRINT 'Do proc 3 done.'
END

GO
CREATE OR ALTER PROCEDURE undo_proc_3 AS
BEGIN
	ALTER TABLE HackingTools
	DROP CONSTRAINT df_pwlev1
	PRINT 'Undo proc 3 done.'
END


-- version 4
-- d) Add/remove primary key

GO
CREATE OR ALTER PROCEDURE do_proc_4 AS
BEGIN
	ALTER TABLE Attacks
	DROP CONSTRAINT pk_Attacks
	PRINT 'Do proc 4 done.'
	-- SELECT * FROM Attacks
END

-- EXEC do_proc_4

GO
CREATE OR ALTER PROCEDURE undo_proc_4 As
BEGIN
	ALTER TABLE Attacks
	ADD CONSTRAINT pk_Attacks PRIMARY KEY (Mid, VicId)
	PRINT 'Undo proc 4 done.'
	-- SELECT * FROM Attacks
END

-- EXEC undo_proc_4


-- version 5
-- e) Add/remove a candidate key

GO
CREATE OR ALTER PROCEDURE do_proc_5 AS
BEGIN
	ALTER TABLE HackingTools
	ADD CONSTRAINT CK_Name UNIQUE(Name)
	PRINT 'Do proc 5 done.'
END

GO
CREATE OR ALTER PROCEDURE undo_proc_5 AS
BEGIN
	ALTER TABLE HackingTools
	DROP CONSTRAINT CK_Name
	PRINT 'Undo proc 5 done.'
END


-- version 6
-- f) Add/remove a foreign key

GO
CREATE OR ALTER PROCEDURE do_proc_6 AS
BEGIN
	ALTER TABLE Attacks
	DROP CONSTRAINT FK_Vic
	PRINT 'Do proc 6 done'
END

-- EXEC do_proc_6

GO
CREATE OR ALTER PROCEDURE undo_proc_6 AS
BEGIN
	ALTER TABLE Attacks
	ADD CONSTRAINT FK_Vic FOREIGN KEY(VicId) REFERENCES Victims(VicId)
	PRINT 'Undo proc 6 done'
END

-- EXEC undo_proc_6


-- version 7
-- g) Create/drop a table

GO
CREATE OR ALTER PROCEDURE do_proc_7 AS
BEGIN
	CREATE TABLE FormerEmployees(
	FEid int PRIMARY KEY,
	Name varchar(55),
	Surname varchar(55),
	Age int);
	PRINT 'Do proc 7 done'
END

GO
CREATE OR ALTER PROCEDURE undo_proc_7 AS
BEGIN
	DROP TABLE IF EXISTS FormerEmployees
	PRINT 'Undo proc 7 done'
END

-------------------------------------------------------------------

-- table that holds the current version of the database schema
DROP TABLE IF EXISTS DatabaseVersion
CREATE TABLE DatabaseVersion(
ID INT IDENTITY PRIMARY KEY,
crt_v INT);

-- current version is 0
INSERT INTO DatabaseVersion VALUES (7)

GO
CREATE OR ALTER PROCEDURE changeVersion @version INT AS
BEGIN
	DECLARE @crtVersion INT
	SET @crtVersion = (SELECT D.crt_v FROM DatabaseVersion D)
	-- PRINT (@crtVersion)
	DECLARE @procedure varchar(55)

	IF @version < 0 or @version > 7 BEGIN 
		PRINT 'Version must be in [0,7] !'
		RETURN
	END
	
	WHILE @version > @crtVersion BEGIN
		SET @crtVersion = @crtVersion + 1
		SET @procedure = 'do_proc_' + CAST(@crtVersion AS varchar(5))
		EXEC @procedure
	END

	WHILE @version < @crtVersion BEGIN
		SET @procedure = 'undo_proc_' + CAST(@crtVersion AS varchar(5))
		EXEC @procedure
		SET @crtVersion = @crtVersion - 1
	END

	UPDATE DatabaseVersion SET crt_v = @version
END


EXEC changeVersion 7

SELECT * FROM DatabaseVersion



