CREATE DATABASE IndexesLab
USE IndexesLab

CREATE TABLE Malware(
	mid INT IDENTITY,
	CONSTRAINT PK_M PRIMARY KEY(mid),
	CVE INT UNIQUE,
	aka VARCHAR(99)
)

-- DROP TABLE Victims
CREATE TABLE Victims(
	vid INT IDENTITY,
	CONSTRAINT PK_V PRIMARY KEY(vid),
	lvl INT
)

CREATE TABLE Attacks(
	aid INT IDENTITY,
	CONSTRAINT PK_A PRIMARY KEY(aid),
	mid INT REFERENCES Malware(mid),
	vid INT REFERENCES Victims(vid)
)

INSERT INTO Malware VALUES (2,'a'),(0,'c'),(10,'b'),(14,'dd'),(-4,'g'),(5,'f')
INSERT INTO Victims VALUES (11),(1),(2),(44),(128),(256)
INSERT INTO Attacks VALUES (1,1),(2,3),(3,2),(6,6),(6,2),(5,4),(4,4)

--SELECT * FROM Malware
--SELECT * FROM Victims
--SELECT * FROM Attacks

-- a) queries on Ta such that their execution plans contain the following operators:

-- clustered index scan
SELECT * FROM Malware
WHERE CVE < 4
ORDER BY mid DESC

-- clustered index seek
SELECT * FROM Malware
WHERE mid > 2

-- nonclustered index scan + key lookup
SELECT * FROM Malware
ORDER BY CVE

-- nonclustered index seek
SELECT Mid FROM Malware
WHERE CVE = 2


-- b) Write a query on table Tb with a WHERE clause of the form WHERE b2 = value and analyze its execution plan. 
--    Create a nonclustered index that can speed up the query. Examine the execution plan again.

SELECT * FROM Victims 
WHERE lvl = 2
-- Select estimated subtree cost without the nonclustered index: 0.0032886

IF EXISTS (SELECT NAME FROM sys.indexes WHERE name='N_idx_Victims_lvl')
DROP INDEX N_idx_Victims_lvl ON Victims
CREATE NONCLUSTERED INDEX N_idx_Victims_lvl ON Victims(lvl)

-- now, the execution plan shows a nonclustered index seek, which is more efficient
SELECT * FROM Victims 
WHERE lvl = 2
-- Select estimated subtree cost with nonclustered index: 0.0032831


-- c) Create a view that joins at least 2 tables. 
--    Check whether existing indexes are helpful; if not, reassess existing indexes / examine the cardinality of the tables.

-- DROP VIEW MA
GO
CREATE VIEW MA
AS 
	SELECT m.CVE, a.aid, a.vid FROM Malware m
	--INNER JOIN Victims v ON m.CVE=v.lvl
	INNER JOIN Attacks a ON m.CVE=a.vid
	WHERE a.vid BETWEEN 2 AND 4
GO

SELECT * FROM MA

-- there are no non-clustered indexes that are helpful, so I'll create the ones below

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'Attacks_Vid_IDX') 
DROP INDEX Attacks_Vid_IDX ON Attacks
CREATE NONCLUSTERED INDEX Attacks_Vid_IDX ON Attacks(aid,vid)

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'Malware_IDX') 
DROP INDEX Malware_IDX ON Malware
CREATE NONCLUSTERED INDEX Malware_IDX ON Malware(CVE)