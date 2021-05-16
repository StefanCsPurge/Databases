create database Malware_use
go
use Malware_use
go


CREATE TABLE Malware(
	Mid int PRIMARY KEY IDENTITY(1,1),
	Name varchar(55),
	Type varchar(55) NOT NULL,
	Severity varchar(55)
)

CREATE TABLE Victims(
	VicId int PRIMARY KEY IDENTITY,
	Name varchar(99),
	Type varchar(66),
	Location varchar(66)
)

CREATE TABLE Attacks(
	Mid int FOREIGN KEY REFERENCES Malware(Mid),
	VicId int FOREIGN KEY REFERENCES Victims(VicId),
	Date date,
	CONSTRAINT pk_Attacks PRIMARY KEY(Mid,VicId)
)


INSERT INTO Malware VALUES('Thanatos','ransomware','high')
INSERT INTO Malware VALUES('Titatium','backdoor malware','medium')
INSERT INTO Malware VALUES('Xafecopy','trojan','high')
INSERT INTO Malware VALUES('NotPetya','ransomware','high')
-- INSERT INTO Malware VALUES('WannaCry','ransomware','high')
-- INSERT INTO Malware VALUES('Mirai','botnet','medium')
-- INSERT INTO Malware VALUES('MEMZ','trojan','high')
-- INSERT INTO Malware VALUES('Regin','sophisticated spyware',7,'high')


INSERT INTO Victims VALUES('corleone1','HOSPITAL','UK')
INSERT INTO Victims VALUES('corleone2','HOSPITAL','Romania')
INSERT INTO Victims VALUES('corleone3','WINDOWS PC','Germany')
-- INSERT INTO Victims VALUES('corleone4','IoT LINUX DEVICE','Australia')
-- INSERT INTO Victims VALUES('corleone5','INDUSTRIAL FACILITY','Ukraine')
-- INSERT INTO Victims VALUES('corleone6','LINUX PC','Poland')
-- INSERT INTO Victims VALUES('corleone7','ANDROID DEVICE','USA')


INSERT INTO Attacks VALUES(1,3,'2018-02-23')
INSERT INTO Attacks VALUES(3,3,'2017-09-05')
INSERT INTO Attacks VALUES(4,2,'2017-06-20')
-- INSERT INTO Attacks VALUES(5,1,'2017-05-10')
-- INSERT INTO Attacks VALUES(5,2,'2017-05-11')
-- INSERT INTO Attacks VALUES(6,4,'2016-09-12')


SELECT * FROM Malware
SELECT * FROM Victims
SELECT * FROM Attacks