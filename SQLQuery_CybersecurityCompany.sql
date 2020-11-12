create database Cybersecurity_Company
go
use Cybersecurity_Company
go


CREATE TABLE Teams(
	Tid int PRIMARY KEY,
	Designation varchar(55),
	NoOfMembers int,
	LeaderName varchar(55))

CREATE TABLE Employees(
	Eid int PRIMARY KEY,
	Name varchar(55),
	Surname varchar(55),
	Age int,
	Tid int FOREIGN KEY REFERENCES Teams(Tid))

CREATE TABLE Vulnerabilities(
	Vid int PRIMARY KEY,
	AffectedPlatform varchar(66),
	SeverityLevel int,
	Mitigated varchar(11), -- yes / no
	Description varchar(111),
	Discoverer int FOREIGN KEY REFERENCES Employees(Eid))

CREATE TABLE MalwareAuthors(
	Aid int PRIMARY KEY IDENTITY,
	Name varchar(55),
	Surname varchar(55),
	Location varchar(55) )

CREATE TABLE Malware(
	Mid int PRIMARY KEY IDENTITY(1,1),
	Name varchar(55),
	Type varchar(55) NOT NULL,
	Aid int FOREIGN KEY REFERENCES MalwareAuthors(Aid),
	Severity varchar(55),
	MainExploitedVuln int FOREIGN KEY REFERENCES Vulnerabilities(Vid)
)

CREATE TABLE Victims(
	VicId int PRIMARY KEY IDENTITY,
	Type varchar(66),
	Location varchar(66))

CREATE TABLE Attacks(
	Mid int FOREIGN KEY REFERENCES Malware(Mid),
	VicId int FOREIGN KEY REFERENCES Victims(VicId),
	Date date,
	CONSTRAINT pk_Attacks PRIMARY KEY(Mid,VicId))

CREATE TABLE TestSubjects(
	TSid int PRIMARY KEY IDENTITY,
	Name varchar(66),
	Type varchar(55),
	Objective varchar(66))

CREATE TABLE PenetrationTests(
	TSid int FOREIGN KEY REFERENCES TestSubjects(TSid),
	Tid int FOREIGN KEY REFERENCES Teams(Tid),
	StartDate date,
	State varchar(55),
	CONSTRAINT pk_Pentests PRIMARY KEY(TSid,Tid))

CREATE TABLE HackingTools(
	HTid int PRIMARY KEY IDENTITY,
	Name varchar(55),
	Type varchar(55),
	PowerLevel int)

CREATE TABLE PentestsHackingTools(
	TSid int,
	Tid int,
	FOREIGN KEY (TSid, Tid) REFERENCES PenetrationTests(TSid,Tid),
	HTid int FOREIGN KEY REFERENCES HackingTools(HTid),
	CONSTRAINT pk_PentestsHackingTools PRIMARY KEY(TSid,Tid,HTid))




INSERT INTO Teams VALUES (12,'Malware Analysis',4,'Gica')
INSERT INTO Teams VALUES (13,'Malware Analysis',4,'Mihnea')
-- INSERT INTO Teams VALUES (12,'Malware Analysis',7,'Ionel')
INSERT INTO Teams VALUES (22,'Pentesting',4,'Vlad')
INSERT INTO Teams VALUES (23,'Pentesting',3,'Lorand')

-- INSERT INTO Employees VALUES(100,'Gica','Miron',44,34) -- violates referential integrity constraints
INSERT INTO Employees VALUES(120,'Gica','Miron',44,12)
INSERT INTO Employees VALUES(121,'Gucci','Costin',25,12)
INSERT INTO Employees VALUES(125,'Nicu','Paleru',38,12)
INSERT INTO Employees VALUES(124,'John','Crisu',40,12)
INSERT INTO Employees VALUES(131,'Mihnea','Pustiu',34,13)
INSERT INTO Employees VALUES(132,'Costel','Sika',24,13)
INSERT INTO Employees VALUES(135,'Daniel','Coco',47,13)
INSERT INTO Employees VALUES(139,'Alan','Manhattan',53,13)
INSERT INTO Employees VALUES(222,'Vlad','Puiu',31,22)
INSERT INTO Employees VALUES(226,'Laura','Balaura',29,22)
INSERT INTO Employees VALUES(228,'Mirela','Caracatita',30,22)
INSERT INTO Employees VALUES(223,'Gregor','Piatra',33,22)
INSERT INTO Employees VALUES(231,'Donald','Black',44,23)
INSERT INTO Employees VALUES(230,'Lorand','Gagiu',33,23)
INSERT INTO Employees VALUES(234,'Yvona','Snowden',44,23)
INSERT INTO Employees(Eid,Name,Surname,Age) VALUES(333,'Schnitzel','Bambi',20)

-- DELETE FROM Employees WHERE Name = 'Gica' AND Eid <> 120

INSERT INTO Vulnerabilities VALUES(79,'web',46,'no','Cross-site Scripting (XSS)',NULL)
INSERT INTO Vulnerabilities VALUES(89,'web',20,'yes','SQL Injection',121)
INSERT INTO Vulnerabilities VALUES(78,'OS',16,'no','OS Command Injection',125)
INSERT INTO Vulnerabilities VALUES(190,'C sotfware',15,'no','Integer Overflow or Wraparound',231)
INSERT INTO Vulnerabilities VALUES(400,'any software',4,'no','Uncontrolled Resource Consumption',NULL)
INSERT INTO Vulnerabilities VALUES(798,'any software',5,'no','Use of Hard-coded Credentials',228)
INSERT INTO Vulnerabilities VALUES(787,'C software',45,'no','Out-of-bounds Write',222)
INSERT INTO Vulnerabilities VALUES(22,'any software',13,'yes','Path Traversal',230)
INSERT INTO Vulnerabilities VALUES(420,'Windows OS',66,'yes','EternalBlue',234)


INSERT INTO MalwareAuthors VALUES('Vadim','Scorsese','Russia')
INSERT INTO MalwareAuthors VALUES('Hatz','Chelu','Romania')
INSERT INTO MalwareAuthors VALUES('Stephen','Marshal','Finland')
INSERT INTO MalwareAuthors VALUES('PLATINUM',NULL,'South and Southeast Asia')
INSERT INTO MalwareAuthors VALUES('Lazarus Group',NULL,'North Korea')
INSERT INTO MalwareAuthors VALUES('Leurak',NULL,NULL)
INSERT INTO MalwareAuthors VALUES('NSA',NULL,'USA')


INSERT INTO Malware VALUES('Thanatos','ransomware',NULL,'high',22)
INSERT INTO Malware VALUES('Titatium','backdoor malware',4,'medium',78)
INSERT INTO Malware VALUES('Xafecopy','trojan',2,'high',22)
INSERT INTO Malware VALUES('NotPetya','ransomware',1,'high',420)
INSERT INTO Malware VALUES('WannaCry','ransomware',5,'high',420)
INSERT INTO Malware VALUES('Mirai','botnet',4,'medium',798)
INSERT INTO Malware VALUES('MEMZ','trojan',6,'high',22)
INSERT INTO Malware VALUES('Regin','sophisticated spyware',7,'high',NULL)


INSERT INTO Victims VALUES('HOSPITAL','UK')
INSERT INTO Victims VALUES('HOSPITAL','Romania')
INSERT INTO Victims VALUES('WINDOWS PC','Germany')
INSERT INTO Victims VALUES('IoT LINUX DEVICE','Australia')
INSERT INTO Victims VALUES('INDUSTRIAL FACILITY','Ukraine')
INSERT INTO Victims VALUES('LINUX PC','Poland')
INSERT INTO Victims VALUES('ANDROID DEVICE','USA')

-- DELETE FROM Victims WHERE Location = 'Iran' 

-- EXEC sp_rename 'MalwareAuthors.Country', 'Location', 'COLUMN';  -- change name of column

INSERT INTO Attacks VALUES(1,3,'2018-02-23')
INSERT INTO Attacks VALUES(3,7,'2017-09-05')
INSERT INTO Attacks VALUES(4,5,'2017-06-20')
INSERT INTO Attacks VALUES(5,1,'2017-05-10')
INSERT INTO Attacks VALUES(5,2,'2017-05-11')
INSERT INTO Attacks VALUES(6,4,'2016-09-12')

-- DELETE FROM Attacks -- delete all data from the table
-- DBCC CHECKIDENT ('Victims', RESEED, 0)  -- reset table IDENTITY KEY after delete

INSERT INTO TestSubjects VALUES('Pentagon','Military facility','Obtain main server access')
INSERT INTO TestSubjects VALUES('Regina Maria H.','Hospital','Gain physical access to the archive and server rooms')
INSERT INTO TestSubjects VALUES('Amazon','Multi company','Gain access to a Bezos account')

INSERT INTO PenetrationTests VALUES(2,22,'2020-10-10','succeeded')
INSERT INTO PenetrationTests VALUES(3,22,'2020-07-02','in progress')
INSERT INTO PenetrationTests VALUES(1,23,'2019-12-24','failed')

INSERT INTO HackingTools VALUES('Sn1per','vulnerability scanner',8)
INSERT INTO HackingTools VALUES('John the Ripper','offline password cracker',8)
INSERT INTO HackingTools VALUES('THC Hydra','online password cracker',8)
INSERT INTO HackingTools VALUES('Cain & Abel','complex password cracker',7)
INSERT INTO HackingTools VALUES('Metasploit','collection of hacking tools and frameworks',9)
INSERT INTO HackingTools VALUES('Maltego','forensics',9)
INSERT INTO HackingTools VALUES('OWASP ZED','web vulnerability scanner',7)
INSERT INTO HackingTools VALUES('Wireshark','network traffic monitor & attack',8)
INSERT INTO HackingTools VALUES('Aircrack-ng','Wireless hacking',8)
INSERT INTO HackingTools VALUES('NMAP (NETWORK MAPPER)','network discovery and security auditing',8)
INSERT INTO HackingTools VALUES('Nikto','web server scanner',7) -- detected by IDS (intrusion detection software)


INSERT INTO PentestsHackingTools VALUES(2,22,6)
INSERT INTO PentestsHackingTools VALUES(2,22,8)
INSERT INTO PentestsHackingTools VALUES(1,23,10)
INSERT INTO PentestsHackingTools VALUES(1,23,7)
INSERT INTO PentestsHackingTools VALUES(1,23,1)
INSERT INTO PentestsHackingTools VALUES(3,22,1)
INSERT INTO PentestsHackingTools VALUES(3,22,6)

UPDATE Employees SET Surname='Showers' WHERE Name='Costel' AND Age=24
UPDATE Employees SET Tid=23 WHERE Tid IS NULL AND Eid IN (555,333,999)
UPDATE Teams SET NoOfMembers=4 WHERE NoOfMembers=3 OR Tid=23
UPDATE Vulnerabilities SET Mitigated='yes' WHERE Description LIKE '%Hard-coded Credentials'

DELETE FROM Employees WHERE Age BETWEEN 22 AND 30 AND Surname LIKE 'Balaur%'
DELETE FROM PentestsHackingTools WHERE TSid = 1 AND HTid = 1


SELECT * FROM Teams
SELECT * FROM Employees
SELECT * FROM Vulnerabilities
SELECT * FROM MalwareAuthors
SELECT * FROM Malware
SELECT * FROM Victims
SELECT * FROM Attacks
SELECT * FROM TestSubjects
SELECT * FROM PenetrationTests
SELECT * FROM HackingTools
SELECT * FROM PentestsHackingTools


-- a.
SELECT DISTINCT AffectedPlatform, Description FROM Vulnerabilities WHERE SeverityLevel>30   -- DISTINCT 
 
 -- select all ids of the hacking tools that have the half of their PowerLevel > 5 or their name stars with 'M'

SELECT HTid FROM HackingTools WHERE PowerLevel/2 > 5 OR Name LIKE 'M%' -- OR version                   -- OR in the WHERE clause

SELECT HTid FROM HackingTools WHERE PowerLevel/2 > 5												-- arithmetic expression
UNION															   -- UNION version
SELECT HTid FROM HackingTools WHERE Name LIKE 'M%'


-- b.
 -- select all the disctinct hacking tools ids that are scanners AND have power level and have their power level * 2 > 10

SELECT DISTINCT HTid FROM HackingTools WHERE Type LIKE '%scanner' 
INTERSECT														  -- INTERSECT version
SELECT DISTINCT HTid FROM HackingTools WHERE PowerLevel*2 > 10										-- arith expression + distinct

SELECT DISTINCT HTid FROM HackingTools WHERE Type LIKE '%scanner' AND 
HTid IN (SELECT DISTINCT HTid FROM HackingTools WHERE PowerLevel*2 > 10)  -- IN version


-- c.
 -- find all the employees' ids that are of age >= 20 but have not discovered any vulnerability

 SELECT Eid from Employees  WHERE Age >= 20 
 EXCEPT											-- EXCEPT version
 SELECT Discoverer from Vulnerabilities
 ORDER BY Eid									-- ORDER BY
 

 SELECT E.Eid from Employees E WHERE E.Age >= 20 AND 
 E.Eid NOT IN (SELECT V.Discoverer from Vulnerabilities V WHERE V.Discoverer IS NOT NULL)	-- NOT IN version 
 ORDER BY E.Eid


 -- d.
-- FULL JOIN: show all the employees' names along with the vulnerabilities, to check who discovered any vulnerability and who didn't
SELECT E.Name, E.Surname, V.* FROM Employees E FULL JOIN Vulnerabilities V ON E.Eid = V.Discoverer

-- INNER JOIN: Show the name of the hacking tools and the name of the penetration tests in which they were used
SELECT DISTINCT HT.Name, PT.* FROM PentestsHackingTools PHT INNER JOIN HackingTools HT ON HT.HTid = PHT.HTid     -- DISTINCT 
INNER JOIN PenetrationTests PT ON PT.TSid = PHT.TSid  -- many to many join

-- LEFT JOIN: show the first 10 attacks along with the malware used (known or not) and the victims , ordered ascending by attack date (Joining 3 tables)
SELECT TOP 10 * FROM Attacks A LEFT JOIN Malware M ON A.Mid = M.Mid													-- TOP
						LEFT JOIN Victims V ON A.VicId = V.VicId ORDER BY A.Date   -- ORDER BY

-- RIGHT JOIN: show all the teams that do penetration tests along with the test subjects, even if they had a team assigned or not 
SELECT DISTINCT T.Tid, TS.* FROM Teams T RIGHT OUTER JOIN TestSubjects TS ON T.Designation = 'Pentesting'  -- many to many join


-- e.
-- show first 5 of the victims that have been affected by an attack post 2017
SELECT TOP 5 * FROM Victims V WHERE V.VicId IN (SELECT A.VicId FROM Attacks A WHERE A.Date>='2018-01-01')				-- TOP

-- show all the hacking tools that have been used in a penetration test against any type of hospital ( the inception IN :) )
SELECT * FROM HackingTools HT WHERE HT.HTid IN (SELECT PHT.HTid FROM PentestsHackingTools PHT WHERE TSid IN (SELECT TSid FROM TestSubjects WHERE Type LIKE 'Hospital%'))


-- f.
-- show all the malware that has a known author
SELECT * FROM Malware WHERE EXISTS (SELECT Aid FROM MalwareAuthors WHERE MalwareAuthors.Aid = Malware.Aid)

-- show all the test subjects that have been tested at least once
SELECT * FROM TestSubjects TS WHERE EXISTS (SELECT PT.TSid from PenetrationTests PT WHERE PT.TSid = TS.TSid)

-- g.
-- show all the test subjects name with the hacking tools types that were used to test them
SELECT T.Name, T.Type
FROM (SELECT TS.Name, HT.HTid, HT.Type
FROM HackingTools HT INNER JOIN PentestsHackingTools PHT ON HT.HTid = PHT.HTid INNER JOIN TestSubjects TS ON TS.TSid = PHT.TSid) T

-- show all the employees surnames and the penetrations tests IDs which they did if they were part of a Pentesting team
SELECT T.Surname, T.TSid, T.Tid
FROM (SELECT E.Surname, PT.TSid, PT.Tid 
FROM Employees E INNER JOIN Teams Tm ON E.Tid = Tm.Tid INNER JOIN PenetrationTests PT ON PT.Tid = Tm.Tid) T


-- h. 4 queries with the GROUP BY clause, 3 of which also contain the HAVING clause; 
--    2 of the latter will also have a subquery in the HAVING clause; use the aggregation operators: COUNT, SUM, AVG, MIN, MAX;

-- the average of the ages of the employees of each team
SELECT T.Tid, AVG(E.Age) AS Average_Age
FROM Teams T INNER JOIN Employees E ON E.Tid = T.Tid
GROUP BY T.Tid

-- show the hacking tools grouped by their type, showing how many of that type exist
SELECT COUNT(HTid) AS NO_OF ,Type
FROM HackingTools GROUP BY Type
HAVING COUNT(HTid) >= 1

-- show the real severity of the effect of the vulnerabilities on a certain platform; the real severity is 
-- the sum of the severities for a platform (which has to be > AVG of severity levels) * 10
SELECT AffectedPlatform, SUM(SeverityLevel)*10 AS RealSeverity												-- arithmetic expression
FROM Vulnerabilities
GROUP BY AffectedPlatform
HAVING SUM(SeverityLevel) > (SELECT AVG(SeverityLevel) FROM Vulnerabilities)
ORDER BY RealSeverity DESC																					-- ORDER BY

-- show the teams' designation along with the maximum number of members of a team for each designation
SELECT Designation, MAX(NoOfMembers) AS MaxNoOfMembers
FROM Teams
GROUP BY Designation
HAVING MIN(NoOfMembers) <= (SELECT AVG(NoOfMembers) FROM Teams)
ORDER BY MaxNoOfMembers DESC																				-- ORDER BY


-- i. ALL and ANY (at least one record checks the condition)

-- ANY : show all the malware that exploits a vulnerability with severity level > 5
SELECT * FROM Malware
WHERE MainExploitedVuln = ANY( SELECT Vid FROM Vulnerabilities WHERE SeverityLevel > 5)
-- can be rewriten with IN
SELECT * FROM Malware WHERE MainExploitedVuln IN (SELECT Vid FROM Vulnerabilities WHERE SeverityLevel > 5)   -- parantheses in the WHERE clause

-- ALL : show all the attacks that did not target Romania
SELECT * FROM Attacks
WHERE VicId <> ALL( SELECT VicId FROM Victims WHERE Location = 'Romania')
-- can be rewritten with NOT IN
SELECT * FROM Attacks
WHERE VicId NOT IN ( SELECT VicId FROM Victims WHERE Location = 'Romania')          -- NOT in the WHERE clause

-- show the oldest employees
SELECT * FROM Employees
WHERE Age >= ALL(SELECT E.Age FROM Employees E WHERE Eid = E.Eid)
-- can be rewritten with MAX
SELECT * FROM Employees
WHERE Age >= (SELECT MAX(E.Age) FROM Employees E WHERE Eid = E.Eid)

-- show all the attacks , withoud the newest ones
SELECT * FROM Attacks
WHERE Date < ANY(SELECT A.Date FROM Attacks A WHERE A.Mid = Mid AND A.VicId = VicId)
-- can be rewritten with MAX
SELECT * FROM Attacks
WHERE Date < (SELECT MAX(A.Date) FROM Attacks A WHERE A.Mid = Mid AND A.VicId = VicId)				-- AND in the WHERE clause





----------------- EXTRA QUERIES SECTION ---------------------

 -- select all the vulnerabilities that have not been discovered by an employee or that have been exploited by any ransomware (UNION version)
SELECT Vid FROM Vulnerabilities WHERE Discoverer IS NULL
UNION
SELECT MainExploitedVuln FROM Malware WHERE Type='ransomware' 
-- OR version
SELECT Vid FROM Vulnerabilities WHERE Discoverer IS NULL OR Vid IN (SELECT MainExploitedVuln FROM Malware WHERE Type='ransomware')


 -- select all employees ids that are younger than 33 and have discovered at least a vulnerability of severity 13,16,20,66,46 or 45

SELECT e.Eid FROM Employees e WHERE e.age<33
INTERSECT
SELECT v.Discoverer FROM Vulnerabilities v WHERE v.SeverityLevel IN (13,16,20,66,45,46)


 -- find all the hacking tools that have the power level over 7 without the ones that have not been used in any pentest against test subjects 1 or 2

 SELECT HTid from HackingTools WHERE PowerLevel > 7 
 EXCEPT
 SELECT HTid from PentestsHackingTools WHERE TSid NOT IN (1,2)


 --------- BONUS QUERY ----------
-- 
--
-- Let's say that the FBI suspects that someone from this cybersecurity company performed an illegal cyberattack on 
-- 2020-01-22 (using the hacking tool Metasploit) and probably tried to make it look like a legal penetration test.
-- However, all the malicious cyber attacks are saved automatically in the Attacks table of the same database, and ALL the 
-- uses of any Hacking Tool is stored automatically in the PentestsHackingTools table of, again, the same database.
--
-- So the FBI can obtain pretty good evidence for this just by using a query that SELECTS the PenetrationTests and the Attacks 
-- that happened on the SAME given date of '2020-01-22' with the CONDITION that the 'Metasploit' hacking tool was used
-- for these PenetrationTests (this being information that can be gathered from the hacking tools uses table: PentestsHackingTools)  

-- I just added a fishy attack to test the query
INSERT INTO Victims VALUES('Military facility','USA')
INSERT INTO Attacks VALUES(2,8,'2020-01-22')

INSERT INTO PenetrationTests VALUES(1,22,'2020-01-22','')
INSERT INTO PentestsHackingTools VALUES(1,22,5) -- Metasploit
INSERT INTO PenetrationTests VALUES(2,23,'2020-01-22','')
INSERT INTO PentestsHackingTools VALUES(2,23,6) -- not Metasploit

--

SELECT * FROM PenetrationTests PT INNER JOIN Attacks A ON 
PT.StartDate = A.Date AND A.Date = '2020-01-22'
INNER JOIN PentestsHackingTools PHT ON
PT.TSid = PHT.TSid AND PT.Tid = PHT.Tid AND PHT.HTid IN (SELECT HTid FROM HackingTools WHERE Name = 'Metasploit') 










