-------new --------
CREATE TABLE Members(
	MemberId SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	Surname VARCHAR(30) NOT NULL,
	Pin VARCHAR(11) UNIQUE CHECK(LENGTH(Pin)=11),
	BirthDate TIMESTAMP NOT NULL,
	Gender VARCHAR(1) NOT NULL CHECK(Gender IN('M', 'F')),
	PlaceOfResidence VARCHAR(30) NOT NULL
)

CREATE TABLE Interns(
	InternId SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	Surname VARCHAR(30) NOT NULL,
	Pin VARCHAR(11) UNIQUE CHECK(LENGTH(Pin)=11),
	BirthDate TIMESTAMP NOT NULL,
	Gender VARCHAR(1) NOT NULL CHECK(Gender IN('M', 'F')), 
	PlaceOfResidence VARCHAR(30) NOT NULL, 
	--InternshipDateStart TIMESTAMP REFERENCES Internships(DateStart) CHECK (EXTRACT(year FROM BirthDate)-EXTRACT(year FROM InternshipDateStart) BETWEEN 16 AND 24),
	InternshipId INT REFERENCES Internships(InternshipId)
)
DROP TABLE INTERNS
CREATE TABLE Domains(
	DomainId SERIAL PRIMARY KEY,
	Name VARCHAR(20) NOT NULL CHECK(Name IN ('Developing', 'Desing', 'Multimedia', 'Marketing')),
	LeaderDomainId INT REFERENCES Members(MemberId)
)
	
CREATE TABLE Internships(
	InternshipId SERIAL PRIMARY KEY,
	DateStart TIMESTAMP UNIQUE,
	DateEnd TIMESTAMP CHECK(DateEnd>DateStart),
	CurrentPhase VARCHAR(14) NOT NULL CHECK(CurrentPhase in ('in preparation', 'in process', 'finished')),
	LeaderInternshipId INT REFERENCES Members(MemberId) UNIQUE
)
DROP TABLE Homeworks CASCADE
CREATE TABLE Homeworks(
	HomeworkId SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	ReviewerId INT REFERENCES Members(MemberId)
)
CREATE TABLE HomeworksInterns(
	HomeworkId INT REFERENCES Homeworks(HomeworkId),
	InternId INT REFERENCES Interns(InternId),
	Grade INT NOT NULL CHECK(Grade in (1, 2, 3, 4, 5))
)
DROP TABLE HomeworksInterns
CREATE TABLE DomainsInterns(
	DomainId INT REFERENCES Domains(DomainId),
	InternId INT REFERENCES Interns(InternId),
	Status VARCHAR(20) NOT NULL CHECK(Status IN ('intern', 'kicked out', 'finished Internship'))
)
CREATE TABLE DomainsInternships(
	DomainId INT REFERENCES Domains(DomainId),
	InternshipId INT REFERENCES Internships(InternshipId),
	PRIMARY KEY(DomainId, InternshipId)
)
CREATE TABLE DomainsMembers(
	DomainId INT REFERENCES Domains(DomainId),
	MemberId INT REFERENCES Members(MemberId)
)
DROP TABLE DomainsMembers
--need fixing
ALTER TABLE DomainsMembers
	ADD CONSTRAINT CountNumberOfMembers CHECK(COUNT(MemberId)<21)
ALTER TABLE DomainsMembers 
	ADD CONSTRAINT CountNumberOfMembers CHECK((COUNT(*), d.Name FROM Members m
	JOIN DomainsMembers dm ON dm.MemberId=m.MemberId
	JOIN Domains d ON d.DomainId=dm.DomainId
	GROUP BY d.Name)<20)
	
----------INSERTING TEST VALUES----------
SELECT * FROM MEMBERS
INSERT INTO Members(MemberId,Name,Surname,Pin,BirthDate,Gender,PlaceOfResidence) VALUES
(default, 'Carter', 'Riley', '20846671841', '1993-5-4', 'M', 'Split'),
(default, 'Luc', 'Buckin', '20846674841', '1995-7-1', 'M', 'Split'),
(default, 'Earl', 'Hunt', '20846631841', '2000-11-13', 'M', 'Zagreb'),
(default, 'Saul', 'Hodge', '20846571841', '2002-1-14', 'M', 'Split'),
(default, 'Bianca', 'Duncanin', '20846771841', '2001-5-2', 'F', 'Osijek'),
(default, 'Aadam', 'Lee', '20846679841', '1997-10-1', 'M', 'Pula'),
(default, 'Izaak', 'Phelpsin', '20846671891', '1999-12-1', 'M', 'Split'),
(default, 'Annika', 'Hart', '20849667181', '1999-12-30','F', 'Zadar'),
(default, 'Teresa', 'Short', '00846671841', '1991-12-5', 'F', 'Zagreb'),
(default, 'Leila', 'Lawrence', '20806671841', '2000-5-29', 'F', 'Split')

SELECT * FROM DOMAINS
INSERT INTO Domains(DomainId, Name, LeaderDomainId) VALUES
(default, 'Developing', 4),
(default, 'Desing', 5),
(default, 'Multimedia', 7),
(default, 'Marketing', 10)

SELECT * FROM DomainsMembers
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

SELECT * FROM INTERNSHIPS
INSERT INTO Internships(InternshipId, DateStart, DateEnd, CurrentPhase, LeaderInternshipId) VALUES
(default, '2021-11-30', '2022-5-1', 'finished', 4),
(default, '2022-11-28', '2023-5-1', 'in process', 3),
(default, '2018-11-25', '2019-5-1', 'finished', 8),
(default, '2023-11-15', '2024-5-1', 'in preparation', 10)

SELECT * FROM DomainsInternships
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
DROP TABLE INTERNS
SELECT * FROM INTERNS
INSERT INTO Interns(InternId, Name, Surname, Pin, BirthDate, Gender, PlaceOfResidence, InternshipId) VALUES
(default, 'Nell', 'Stanton', '78294512300','2000-4-30', 'M', 'Split', 1),
(default, 'Isabel', 'Riley', '78294512301','2001-4-30', 'M', 'Zagreb', 1),
(default, 'Francesco', 'Hull', '78294512302','1999-4-30', 'M', 'Split', 1),
(default, 'Evil', 'Lambert', '08294512300','1999-4-30', 'M', 'Zadar', 2),
(default, 'Steffan', 'Whitehead', '78294512303','1998-4-30', 'M', 'Osijek', 2),
(default, 'Juliette', 'Booth', '78294512304','2000-4-30', 'M', 'Solin', 3),
(default, 'Jana', 'Chen', '78294512305','2002-4-30', 'M', 'Split', 1),
(default, 'Iona', 'Rojas', '78294512306','2000-4-30', 'M', 'Solin', 3),
(default, 'Sarah', 'Stephens', '78294512307','2001-4-30', 'M', 'Split', 1),
(default, 'Cindy', 'Hunt', '78294512308','2000-4-30', 'M', 'Split', 4)

SELECT * FROM DOMAINSINTERNS
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

SELECT * FROM HOMEWORKS
INSERT INTO Homeworks(HomeworkId, Name, ReviewerId) VALUES
(default, 'Database homework', 3),
(default, 'Database homework', 2),
(default, 'Design homework1', 1),
(default, 'Design homework2', 5),
(default, 'Marketing homework1', 10),
(default, 'Marketing homework2', 10),
(default, 'Git homework', 3),
(default, 'OOP homework', 2),
(default, 'OOP homework', 4)

SELECT * FROM HomeworksInterns
INSERT INTO HomeworksInterns(HomeworkId, InternId, Grade) VALUES
(1, 1, 3),
(1, 2, 5),
(2, 6, 2),
(2, 10, 3),
(3, 3, 4),
(4, 3, 5),
(5, 4, 5),
(5, 5, 4),
(5, 7, 3),
(5, 9, 3),
(6, 7, 5),
(6, 9, 4),
(7, 1, 3),
(8, 2, 3),
(9, 1, 4)

---ideas
SELECT COUNT(*) AS NumberInDomains, d.Name AS DomainName FROM Members m
JOIN DomainsMembers dm ON dm.MemberId=m.MemberId
JOIN Domains d ON d.DomainId=dm.DomainId
GROUP BY d.Name

-------------PRINT-------------

