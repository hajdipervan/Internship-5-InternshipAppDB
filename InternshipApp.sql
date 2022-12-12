CREATE TABLE Members(
	MemberId SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	Surname VARCHAR(30) NOT NULL,
	Pin VARCHAR(11) UNIQUE CHECK(LENGTH(Pin)=11),
	BirthDate TIMESTAMP NOT NULL,
	Gender VARCHAR(1) NOT NULL CHECK(Gender IN('M', 'F')),
	PlaceOfResidence VARCHAR(30) NOT NULL
)
-------------------------------
CREATE TABLE Internships(
	InternshipId SERIAL PRIMARY KEY,
	DateStart TIMESTAMP UNIQUE,
	DateEnd TIMESTAMP CHECK(DateEnd>DateStart),
	CurrentPhase VARCHAR(14) NOT NULL CHECK(CurrentPhase in ('in preparation', 'in process', 'finished')),
	LeaderInternshipId INT REFERENCES Members(MemberId) UNIQUE
)
-------------------------------
CREATE TABLE Interns(
	InternId SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	Surname VARCHAR(30) NOT NULL,
	Pin VARCHAR(11) UNIQUE CHECK(LENGTH(Pin)=11),
	BirthDate TIMESTAMP NOT NULL,
	Gender VARCHAR(1) NOT NULL CHECK(Gender IN('M', 'F')), 
	PlaceOfResidence VARCHAR(30) NOT NULL,
	InternshipId INT REFERENCES Internships(InternshipId)
)
-------------------------------
CREATE TABLE Domains(
	DomainId SERIAL PRIMARY KEY,
	Name VARCHAR(20) NOT NULL CHECK(Name IN ('Developing', 'Desing', 'Multimedia', 'Marketing')),
	LeaderDomainId INT REFERENCES Members(MemberId)
)
-------------------------------	
CREATE TABLE Homeworks(
	HomeworkId SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL
)
-------------------------------
CREATE TABLE HomeworksInterns(
	HomeworkId INT REFERENCES Homeworks(HomeworkId),
	InternId INT REFERENCES Interns(InternId) ON DELETE CASCADE,
	Grade INT NOT NULL CHECK(Grade in (1, 2, 3, 4, 5)),
	ReviewerId INT REFERENCES Members(MemberId) NOT NULL
)
-------------------------------
CREATE TABLE DomainsInterns(
	DomainId INT REFERENCES Domains(DomainId),
	InternId INT REFERENCES Interns(InternId) ON DELETE CASCADE,
	Status VARCHAR(20) NOT NULL CHECK(Status IN ('intern', 'kicked out', 'finished Internship'))
)
-------------------------------
CREATE TABLE DomainsInternships(
	DomainId INT REFERENCES Domains(DomainId),
	InternshipId INT REFERENCES Internships(InternshipId),
	PRIMARY KEY(DomainId, InternshipId)
)
-------------------------------
CREATE TABLE DomainsMembers(
	DomainId INT REFERENCES Domains(DomainId),
	MemberId INT REFERENCES Members(MemberId) ON DELETE CASCADE
)
-------------------------------
ALTER TABLE DomainsMembers
	ADD CONSTRAINT CountNumberOfMembers CHECK(MemberId<21)

	
----------INSERTING TEST VALUES----------
INSERT INTO Members(MemberId,Name,Surname,Pin,BirthDate,Gender,PlaceOfResidence) VALUES
(default, 'Carter', 'Riley', '20846671841', '1993-5-4', 'M', 'Split'),
(default, 'Luc', 'Buckin', '20846674841', '1999-7-1', 'M', 'Split'),
(default, 'Earl', 'Hunt', '20846631841', '2000-11-13', 'M', 'Zagreb'),
(default, 'Saul', 'Hodge', '20846571841', '2002-1-14', 'M', 'Split'),
(default, 'Bianca', 'Duncanin', '20846771841', '2001-5-2', 'F', 'Osijek'),
(default, 'Aadam', 'Lee', '20846679841', '1998-10-1', 'M', 'Pula'),
(default, 'Izaak', 'Phelpsin', '20846671891', '1999-12-1', 'M', 'Split'),
(default, 'Annika', 'Hart', '20849667181', '1999-12-30','F', 'Zadar'),
(default, 'Teresa', 'Short', '00846671841', '1991-12-5', 'F', 'Zagreb'),
(default, 'Leila', 'Lawrence', '20806671841', '2000-5-29', 'F', 'Split')
-------------------------------
INSERT INTO Domains(DomainId, Name, LeaderDomainId) VALUES
(default, 'Developing', 4),
(default, 'Desing', 5),
(default, 'Multimedia', 7),
(default, 'Marketing', 10)
-------------------------------
INSERT INTO DomainsMembers(DomainId, Memberid) VALUES
(2, 1),
(1, 2),
(1, 3),
(1, 4),
(2, 5),
(3, 6),
(3, 7),
(4, 8),
(3, 9),
(4, 10)
-------------------------------
INSERT INTO Internships(InternshipId, DateStart, DateEnd, CurrentPhase, LeaderInternshipId) VALUES
(default, '2021-11-30', '2022-5-1', 'finished', 4),
(default, '2022-11-28', '2023-5-1', 'in process', 3),
(default, '2018-11-25', '2019-5-1', 'finished', 8),
(default, '2023-11-15', '2024-5-1', 'in preparation', 10)
-------------------------------
INSERT INTO DomainsInternships(DomainId, InternshipId) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(3, 1),
(3, 2),
(3, 3),
(3, 4),
(4, 1),
(4, 2),
(4, 4)
-------------------------------
INSERT INTO Interns(InternId, Name, Surname, Pin, BirthDate, Gender, PlaceOfResidence, InternshipId) VALUES
(default, 'Nell', 'Stanton', '78294512300','2000-4-30', 'M', 'Split', 1),
(default, 'Isabel', 'Riley', '78294512301','2001-4-30', 'F', 'Zagreb', 1),
(default, 'Francesco', 'Hull', '78294512302','1999-4-30', 'M', 'Split', 1),
(default, 'Evil', 'Lambert', '08294512300','1999-4-30', 'M', 'Zadar', 2),
(default, 'SteffanI', 'Whitehead', '78294512303','1998-4-30', 'F', 'Osijek', 2),
(default, 'Juliette', 'Booth', '78294512304','2000-4-30', 'F', 'Solin', 3),
(default, 'Jana', 'Chen', '78294512305','2002-4-30', 'F', 'Split', 1),
(default, 'Iona', 'Rojas', '78294512306','2000-4-30', 'F', 'Solin', 3),
(default, 'Sarah', 'Stephens', '78294512307','2001-4-30', 'F', 'Split', 1),
(default, 'Cindy', 'Hunt', '78294512308','2000-4-30', 'F', 'Split', 1)
-------------------------------
INSERT INTO DomainsInterns(DomainId, InternId, Status) VALUES
(1, 1, 'intern'),
(1, 1, 'kicked out'),
(2, 3, 'finished Internship'),
(1, 4, 'intern'),
(4, 4, 'kicked out'),
(4, 5, 'kicked out'),
(1, 6, 'intern'),
(2, 6, 'intern'),
(4, 7, 'intern'),
(3, 8, 'finished Internship'),
(4, 9, 'kicked out'),
(1, 10, 'intern')
-------------------------------
INSERT INTO Homeworks(HomeworkId, Name) VALUES
(default, 'Database homework'),
(default, 'Database homework'),
(default, 'Design homework1'),
(default, 'Design homework2'),
(default, 'Marketing homework1'),
(default, 'Marketing homework2'),
(default, 'Git homework'),
(default, 'OOP homework'),
(default, 'OOP homework')
-------------------------------
INSERT INTO HomeworksInterns(HomeworkId, InternId, Grade, ReviewerId ) VALUES
(1, 1, 3, 3),
(1, 2, 5, 2),
(2, 6, 2, 2),
(2, 2, 3, 4),
(3, 3, 4, 2),
(4, 3, 5, 5),
(5, 4, 5, 8),
(5, 5, 4, 10),
(5, 7, 3, 10),
(5, 9, 3, 10),
(6, 7, 5, 8),
(6, 9, 4, 10),
(7, 1, 3, 3),
(8, 2, 3, 4),
(9, 1, 4, 4)
-------------------------------
---ideas---
SELECT COUNT(*) AS NumberInDomains, d.Name AS DomainName FROM Members m
JOIN DomainsMembers dm ON dm.MemberId=m.MemberId
JOIN Domains d ON d.DomainId=dm.DomainId
GROUP BY d.Name

-------------PRINT-------------
--1--
SELECT m.Name AS MemberName, m.Surname AS MemberSurname FROM Members m
WHERE m.PlaceOfResidence <> 'Split'
--2--
SELECT i.DateStart, i.DateEnd FROM Internships i
ORDER BY i.DateStart DESC
--3--
SELECT i.Name AS MemberName, i.Surname AS MemberSurname FROM Interns i 
JOIN Internships it ON it.InternshipId=i.InternshipId
WHERE EXTRACT(YEAR FROM it.DateStart)=2021 AND EXTRACT(YEAR FROM it.DateEnd)=2022
--4--
SELECT COUNT(*) AS NumberOfGirlsOnInternshipThisYear FROM Interns i
JOIN Internships it ON it.InternshipId=i.InternshipId
WHERE i.Gender='F' AND EXTRACT(YEAR FROM it.DateStart)=EXTRACT(YEAR FROM NOW())
--5--
SELECT COUNT(*) AS NumberOfKickedMarketing FROM Interns i
JOIN DomainsInterns di ON di.InternId=i.InternId
JOIN Domains d ON d.DomainId=di.DomainId
WHERE di.Status='kicked out' AND d.Name='Marketing'
--6--
UPDATE Members 
SET PlaceOfResidence='Moskva'
WHERE Surname LIKE '%in'
--7--
DELETE FROM Members
WHERE (EXTRACT(YEAR FROM NOW())-EXTRACT(YEAR FROM BirthDate))>25
--8--
--ideja, ne znam kako napraviti pa sam prisilno obrisala--
SELECT i.InternId, i.Name, i.Surname, AVG(hi.Grade) AS AverageGrade FROM Interns i
JOIN HomeworksInterns hi ON hi.InternId=i.InternId
GROUP BY Name, Surname, i.InternId
ORDER BY AVG(hi.Grade) DESC
-------------
DELETE FROM Interns
WHERE InternId=6




