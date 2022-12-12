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
	InternshipId INT REFERENCES Internships(InternshipId)
)
	
CREATE TABLE Domains(
	DomainId SERIAL PRIMARY KEY,
	Name VARCHAR(20) NOT NULL CHECK(Name IN ('Developing', 'Desing', 'Multimedia', 'Marketing'))
)
	
CREATE TABLE Internships(
	InternshipId SERIAL PRIMARY KEY,
	DateStart TIMESTAMP,
	DateEnd TIMESTAMP CHECK(DateEnd>DateStart),
	CurrentPhase VARCHAR(10) NOT NULL CHECK(CurrentPhase in ('u pripremi', 'u tijeku', 'zavrsen')),
	LeaderInternshipId INT REFERENCES Members(MemberId) UNIQUE
)

CREATE TABLE Homeworks(
	HomeworkId SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	ReviewerId INT REFERENCES Members(MemberId),
	Grade INT NOT NULL CHECK(Grade in (1, 2, 3, 4, 5))
)
CREATE TABLE HomeworksInterns(
	HomeworkId INT REFERENCES Homeworks(HomeworkId),
	InternId INT REFERENCES Interns(InternId)
)
CREATE TABLE DomainsInterns(
	DomainId INT REFERENCES Domains(DomainId),
	InternId INT REFERENCES Interns(InternId),
	Status VARCHAR(20) NOT NULL CHECK(Status IN ('intern', 'kicked out', 'finished Internship'))
)
CREATE TABLE DomainsInternships(
	DomainId INT REFERENCES Domains(DomainId),
	InternshipId INT REFERENCES Internships(InternshipId)
)
CREATE TABLE DomainsMembers(
	DomainId INT REFERENCES Domains(DomainId),
	MemberId INT REFERENCES Members(MemberId),
	LeaderDomainId INT REFERENCES Members(MemberId),
	PRIMARY KEY(DomainId, MemberId)
)
--need fixing
ALTER TABLE DomainsMembers
	ADD CONSTRAINT CountNumberOfMembers CHECK(COUNT(MemberId)<21)
ALTER TABLE DomainsMembers 
	ADD CONSTRAINT CountNumberOfMembers CHECK((COUNT(*), d.Name FROM Members m
	JOIN DomainsMembers dm ON dm.MemberId=m.MemberId
	JOIN Domains d ON d.DomainId=dm.DomainId
	GROUP BY d.Name)<20)

---ideas
SELECT COUNT(*) AS NumberInDomains, d.Name AS DomainName FROM Members m
JOIN DomainsMembers dm ON dm.MemberId=m.MemberId
JOIN Domains d ON d.DomainId=dm.DomainId
GROUP BY d.Name

INSERT INTO DomainsMembers(DomainId, MemberId) VALUES
(1, 2),
(2, 1)

-------------PRINT-------------
