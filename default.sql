-- Uncomment the following drop table clauses to debug create tables;
-- Note: The order of dropping table matters, or you will get error message:
-- RA-02449: unique/primary keys in table referenced by foreign keys.

DROP TABLE FriendOf;
DROP TABLE SupportTicketRequest;
DROP TABLE SupportTicketStatus;
DROP TABLE Participate;
DROP TABLE CommunityAssociate;
DROP TABLE Own;
DROP TABLE BelongsTo;
DROP TABLE GenreDescription;
DROP TABLE GenreName;
DROP TABLE GenreUpdate;
DROP TABLE ReviewWriteAssociateContent;
DROP TABLE ReviewWriteAssociateUser;
DROP TABLE DiscountAssociate;
DROP TABLE SalesEventContent;
DROP TABLE SalesEventDate;
DROP TABLE Developer;
DROP TABLE Publisher;
DROP TABLE GameInfo;
DROP TABLE CompanyInfo;
DROP TABLE CompanyRevenue;
DROP TABLE GameURL;
DROP TABLE GamePrice;
DROP TABLE UserInfo;
DROP TABLE UserProfile;



-- The order of create table matters
CREATE TABLE UserProfile (
	Profile_URL CHAR(100) PRIMARY KEY,
	User_name CHAR(20),
	Creation_Date DATE,
	Account_Level INTEGER
);

CREATE TABLE UserInfo (
	Playtime FLOAT,
	UserID INTEGER PRIMARY KEY,
	UserLocation CHAR(50),
	PhoneNum CHAR(20),
    Profile_URL CHAR(100) NOT NULL,
	FOREIGN KEY (Profile_URL) REFERENCES UserProfile ON DELETE CASCADE
);

 
CREATE TABLE FriendOf (
    UserID INTEGER,
	FUID INTEGER,
	PRIMARY KEY (UserID, FUID),
	FOREIGN KEY (UserID) REFERENCES UserInfo (UserID) ON DELETE CASCADE,
	FOREIGN KEY (FUID) REFERENCES UserInfo (UserID) ON DELETE CASCADE
);

CREATE TABLE SupportTicketStatus (
    Description CHAR(200),
    Date_reported DATE,
    UserID INTEGER    NOT NULL,
	Status CHAR(20),
	PRIMARY KEY (Description ,UserID, Date_reported),
	FOREIGN KEY (UserID) REFERENCES UserInfo(UserID) ON DELETE CASCADE 
);
 
CREATE TABLE SupportTicketRequest (
    TID INTEGER PRIMARY KEY,
    Description CHAR(200),
    Date_reported DATE,
	UserID INTEGER          NOT NULL,
	FOREIGN KEY (UserID) REFERENCES UserInfo(UserID) ON DELETE CASCADE, 
	FOREIGN KEY (Description, UserID, Date_reported) REFERENCES SupportTicketStatus ON DELETE CASCADE
);

CREATE TABLE CompanyRevenue(
	Name		CHAR(50),
	Location	CHAR(100),
	Revenue	FLOAT,
	PRIMARY KEY (Name, Location)
);

CREATE TABLE CompanyInfo(
	CID	INTEGER	PRIMARY KEY,
	Email		CHAR(50),
	Name		CHAR(50),
	Location	CHAR(100),
	FOREIGN KEY (Name, Location) REFERENCES CompanyRevenue ON DELETE CASCADE
);


CREATE TABLE Publisher (
    CPID INTEGER PRIMARY KEY,
    NumGamesPublished INTEGER,
    FOREIGN KEY (CPID) REFERENCES CompanyInfo(CID) ON DELETE CASCADE);

CREATE TABLE Developer (
    CDID INTEGER PRIMARY KEY,
    NumGamesDeveloped INTEGER,
    FOREIGN KEY (CDID) REFERENCES CompanyInfo(CID) ON DELETE CASCADE);

CREATE TABLE GamePrice(
	Name		CHAR(50),
	Release_Date		DATE,
	Price		FLOAT,
	PRIMARY KEY (Name, Release_Date)
);

CREATE TABLE GameURL(
	URL	CHAR(100)	PRIMARY KEY,
	Name 		CHAR(50),
	Release_Date		DATE,
	Requirements		CHAR(1000),
	num_of_internal_achievement	INTEGER,
	FOREIGN KEY (Name, Release_Date) REFERENCES GamePrice
	ON DELETE CASCADE
	);

CREATE TABLE GameInfo(
	GID	INTEGER	PRIMARY KEY,
	URL	CHAR(100),
	gameDescription	CHAR(1000),
	CPID	INTEGER,
	CDID	INTEGER,
	FOREIGN KEY (URL) REFERENCES GameURL ON DELETE CASCADE,
	FOREIGN KEY (CPID) REFERENCES CompanyInfo(CID) ON DELETE CASCADE,
	FOREIGN KEY (CDID) REFERENCES CompanyInfo(CID) ON DELETE CASCADE
);

CREATE TABLE Own (
    UserID INTEGER,
    GID INTEGER,
    ownDate DATE,
	Ownership_type CHAR(20),
	PRIMARY KEY (UserID, GID),
	FOREIGN KEY (UserID) REFERENCES UserInfo ON DELETE CASCADE,
	FOREIGN KEY (GID) REFERENCES GameInfo ON DELETE CASCADE
);

CREATE TABLE GenreUpdate (
    Name CHAR(20),
    LastUpdatedDate DATE,
    PRIMARY KEY (Name)
);

CREATE TABLE GenreName (
    Description CHAR(200),
    Name CHAR(20),
	PRIMARY KEY (Description),
    FOREIGN KEY (Name) REFERENCES GenreUpdate ON DELETE CASCADE);

CREATE TABLE GenreDescription (
    GeID INTEGER,
    Description CHAR(200),
    PRIMARY KEY (GeID),
    FOREIGN KEY (Description) REFERENCES GenreName ON DELETE CASCADE
);

CREATE TABLE BelongsTo (
    GID INTEGER,
    GeID INTEGER,
    PRIMARY KEY (GID, GeID),
    FOREIGN KEY (GID) REFERENCES GameInfo ON DELETE CASCADE,
    FOREIGN KEY (GeID) REFERENCES GenreDescription ON DELETE CASCADE
);


CREATE TABLE ReviewWriteAssociateUser (
    ReviewText CHAR(200),
    Rating INTEGER,
    PostDate DATE,
    UserID INTEGER NOT NULL,
    PRIMARY KEY (ReviewText, PostDate, Rating),
    FOREIGN KEY (UserID) REFERENCES UserInfo ON DELETE CASCADE);

CREATE TABLE ReviewWriteAssociateContent (
    RID INTEGER,
    GID INTEGER,
    ReviewText CHAR(200) NOT NULL,
    Rating INTEGER NOT NULL,
    PostDate DATE NOT NULL,
    PRIMARY KEY (RID, GID),
    FOREIGN KEY (GID) REFERENCES GameInfo ON DELETE CASCADE,
    FOREIGN KEY (ReviewText, PostDate, Rating) REFERENCES ReviewWriteAssociateUser ON DELETE CASCADE
);

CREATE TABLE CommunityAssociate (
    CoID INTEGER PRIMARY KEY,
    GID INTEGER   NOT NULL UNIQUE,
    Title CHAR(200),
    Section CHAR(200),
    FOREIGN KEY (GID) REFERENCES GameInfo ON DELETE CASCADE
);

CREATE TABLE Participate (
    CoID INTEGER,
    UserID INTEGER,
    PRIMARY KEY (CoID, UserID),
   FOREIGN KEY (CoID) REFERENCES CommunityAssociate ON DELETE CASCADE,
   FOREIGN KEY (UserID) REFERENCES UserInfo ON DELETE CASCADE
);

CREATE TABLE SalesEventDate (
    SalesDescription CHAR(200),
    StartDate DATE,
    PRIMARY KEY (SalesDescription)
);

CREATE TABLE SalesEventContent (
    SID INTEGER,
    SalesDescription CHAR(200) NOT NULL,
    CID INTEGER,
    PRIMARY KEY (SID),
   FOREIGN KEY (CID) REFERENCES CompanyInfo ON DELETE CASCADE,
   FOREIGN KEY (SalesDescription) REFERENCES SalesEventDate ON DELETE CASCADE
);

CREATE TABLE DiscountAssociate (
    GID INTEGER,
	SID INTEGER,
    DiscountPercentage INTEGER,
    PRIMARY KEY (GID, SID),
    FOREIGN KEY (GID) REFERENCES GameInfo ON DELETE CASCADE,
    FOREIGN KEY (SID) REFERENCES SalesEventContent ON DELETE CASCADE
);


-- Insert Default Data
INSERT
INTO  UserProfile
VALUES ('https://steamcommunity.com/id/1/', 'Sniper', '19-SEP-2019', 50);

INSERT
INTO  UserProfile 
VALUES ('https://steamcommunity.com/id/2/', 'NaviElec', '18-OCT-2009', 100);

INSERT
INTO  UserProfile
VALUES ('https://steamcommunity.com/id/3/', 'Mr.Database', '05-MAY-2020', 15);

INSERT
INTO  UserProfile 
VALUES ('https://steamcommunity.com/id/4/', '0x15', '23-DEC-2022', 3);

INSERT
INTO  UserProfile
VALUES ('https://steamcommunity.com/id/5/', '304Lover', '04-AUG-2018', 15);

INSERT
INTO  UserInfo
VALUES (1000.0, 1, 'Canada', '604-012-8901', 'https://steamcommunity.com/id/1/');

INSERT
INTO  UserInfo
VALUES (300.0, 2, 'USA', '206-780-4576', 'https://steamcommunity.com/id/2/');

INSERT
INTO  UserInfo
VALUES (2560.0, 3, 'USA', '080-345-6048', 'https://steamcommunity.com/id/3/');

INSERT
INTO  UserInfo
VALUES (5000.0, 4, 'USA', '112-530-8761', 'https://steamcommunity.com/id/4/');

INSERT
INTO UserInfo
VALUES (8920.0, 5, 'Canada', '009-056-8701', 'https://steamcommunity.com/id/5/');

INSERT
INTO FriendOf
VALUES (1, 2);

INSERT
INTO FriendOf 
VALUES (2, 5);

INSERT
INTO FriendOf
VALUES (3, 4);

INSERT
INTO FriendOf
VALUES (4, 1);

INSERT
INTO FriendOf
VALUES (5, 2);

INSERT
INTO GamePrice
VALUES ('Hogwarts Legacy', '10-FEB-2023', 79.99);

INSERT
INTO GamePrice
VALUES ('Red Dead Redemption 2', '05-DEC-2019', 79.99);

INSERT
INTO GamePrice
VALUES ('GRAND THEFT AUTO V', '15-APR-2015', 29.98);

INSERT
INTO GamePrice
VALUES ('Sekiro: Shadows Die Twice', '21-MAR-2019', 79.99);

INSERT 
INTO GamePrice
VALUES ('Elden Ring', '24-FEB-2022', 79.99);

INSERT
INTO GameURL
VALUES ('https://store.steampowered.com/app/990080/Hogwarts_Legacy/', 'Hogwarts Legacy', '10-FEB-2023', '85 GB available space', 45);

INSERT
INTO GameURL 
VALUES ('https://store.steampowered.com/app/1174180/Red_Dead_Redemption_2/', 'Red Dead Redemption 2', '05-DEC-2019', '150 GB available space', 51);

INSERT
INTO GameURL 
VALUES ('https://store.steampowered.com/app/271590/Grand_Theft_Auto_V/', 'GRAND THEFT AUTO V', '15-APR-2015', '72 GB available space', 77);

INSERT
INTO GameURL 
VALUES('https://store.steampowered.com/app/814380/Sekiro_Shadows_Die_Twice__GOTY_Edition/', 'Sekiro: Shadows Die Twice', '21-MAR-2019', '25 GB available space', 34);

INSERT
INTO GameURL 
VALUES('https://store.steampowered.com/app/1245620/ELDEN_RING/', 'Elden Ring', '24-FEB-2022', '60 GB available space', 42);


-- revenue is in million
INSERT INTO CompanyRevenue
VALUES ('FromSoftware Inc.', 'Tokyo, Japan', 186);

INSERT INTO CompanyRevenue 
VALUES ('Rockstar Games', 'New York City, US', 63);

INSERT INTO CompanyRevenue
VALUES ('Warner Bro. Games', 'Burbank, California, US', 62.7);

INSERT INTO CompanyRevenue
VALUES ('Activition Games', 'Santa Monica, California, US', 8.803);

INSERT INTO CompanyRevenue 
VALUES ('CD Project Red', 'Warsaw, Poland', 229.9);

INSERT 
INTO CompanyInfo
VALUES (1, 'web-support@fromsoftware.co.jp', 'FromSoftware Inc.', 'Tokyo, Japan');

INSERT 
INTO CompanyInfo 
VALUES (2, 'support@rockstargames.com', 'Rockstar Games', 'New York City, US');

INSERT 
INTO CompanyInfo 
VALUES (3, 'ex.jane.doe@warnerbros.com', 'Warner Bro. Games', 'Burbank, California, US');

INSERT 
INTO CompanyInfo 
VALUES (4, 'privacy@activision.com', 'Activition Games', 'Santa Monica, California, US');

INSERT 
INTO CompanyInfo 
VALUES (5, 'biz@cdprojektred.com', 'CD Project Red', 'Warsaw, Poland');

INSERT
INTO GameInfo 
VALUES (1, 'https://store.steampowered.com/app/990080/Hogwarts_Legacy/', 'Hogwarts Legacy is an immersive, open-world action RPG set in the world first introduced in the Harry Potter books.', 3,3);

INSERT
INTO GameInfo
VALUES (2, 'https://store.steampowered.com/app/1174180/Red_Dead_Redemption_2/', 'Arthur Morgan and the Van der Linde gang are outlaws on the run. With federal agents and the best bounty hunters in the nation massing on their heels, the gang must rob, steal and fight their way across the rugged heartland of America in order to survive', 2,2);

INSERT
INTO GameInfo
VALUES (3, 'https://store.steampowered.com/app/271590/Grand_Theft_Auto_V/', 'When a young street hustler, a retired bank robber, and a terrifying psychopath land themselves in trouble, they must pull off a series of dangerous heists to survive in a city in which they can trust nobody, least of all each other.', 5,5);

INSERT
INTO GameInfo
VALUES (4,
'https://store.steampowered.com/app/814380/Sekiro_Shadows_Die_Twice__GOTY_Edition/', 'Sekiro: Shadows Die Twice is an intense, third-person, action-adventure set against the bloody backdrop of 14th-century Japan.', 4,4);

INSERT
INTO GameInfo
VALUES (5, 'https://store.steampowered.com/app/1245620/ELDEN_RING/', 'Elden Ring is an action role-playing game played in a third person perspective, with gameplay focusing on combat and exploration', 1,1);

INSERT
INTO Publisher
VALUES (1, 24);

INSERT
INTO Publisher
VALUES (2, 27);

INSERT
INTO Publisher
VALUES (3, 256);

INSERT
INTO Publisher
VALUES (4, 750);

INSERT
INTO Publisher
VALUES (5, 5);
INSERT
INTO Developer
VALUES (1, 24);

INSERT
INTO Developer
VALUES (2, 22);

INSERT
INTO Developer
VALUES (3, 110);

INSERT
INTO Developer
VALUES (4, 49);

INSERT
INTO Developer
VALUES (5, 5);

INSERT 
INTO SalesEventDate
VALUES ('Rockstar Game Publisher Sale', '19-AUG-2021');

INSERT 
INTO SalesEventDate
VALUES ('Summer sale 2022', '29-JUN-2022');

INSERT 
INTO SalesEventDate
VALUES ('Winter sale 2022', '20-DEC-2022');

INSERT 
INTO SalesEventDate
VALUES ('Sports Fest', '15-MAY-2022');

INSERT 
INTO SalesEventDate
VALUES ('Scream Fest', '26-OCT-2022');

INSERT
INTO SalesEventContent
VALUES (1, 'Rockstar Game Publisher Sale', 2);

INSERT 
INTO SalesEventContent
VALUES (2, 'Summer sale 2022', 2);

INSERT 
INTO SalesEventContent
VALUES (3, 'Winter sale 2022', 2);

INSERT 
INTO SalesEventContent
VALUES (4, 'Sports Fest', 2);

INSERT 
INTO SalesEventContent
VALUES (5, 'Scream Fest', 2);

INSERT INTO DiscountAssociate 
VALUES (3, 1, 50);

INSERT INTO DiscountAssociate 
VALUES (2, 1, 65);

INSERT INTO DiscountAssociate
VALUES (3, 2, 60);

INSERT INTO DiscountAssociate 
VALUES (4, 3, 75);

INSERT INTO DiscountAssociate
VALUES (5, 4, 20);

INSERT 
INTO ReviewWriteAssociateUser
VALUES ('Love this game', 5, '23-NOV-2022', 1);

INSERT 
INTO ReviewWriteAssociateUser
VALUES ('Good', 5, '08-SEP-2021', 2);

INSERT 
INTO ReviewWriteAssociateUser
VALUES ('Too many cheaters!', 3, '20-JUN-2020', 3);

INSERT 
INTO ReviewWriteAssociateUser
VALUES ('Enjoyable', 5, '03-MAY-2019', 2);

INSERT 
INTO ReviewWriteAssociateUser
VALUES ('Once starting the game, Windows will restart...', 2, '09-FEB-2023', 5);

INSERT 
INTO ReviewWriteAssociateContent
VALUES (1, 5, 'Love this game', 5, '23-NOV-2022');

INSERT
INTO ReviewWriteAssociateContent
VALUES (2, 2, 'Good', 5, '08-SEP-2021');

INSERT 
INTO ReviewWriteAssociateContent
VALUES (3, 3, 'Too many cheaters!', 3, '20-JUN-2020');

INSERT 
INTO ReviewWriteAssociateContent 
VALUES (4, 3, 'Enjoyable', 5, '03-MAY-2019');

INSERT 
INTO ReviewWriteAssociateContent
VALUES (5, 1, 'Once starting the game, Windows will restart...', 2, '09-FEB-2023');

INSERT INTO GenreUpdate 
VALUES ('RPG', '16-FEB-2023');

INSERT INTO GenreUpdate 
VALUES ('Action', '10-FEB-2023');

INSERT INTO GenreUpdate 
VALUES ('MOBA', '26-FEB-2023');

INSERT INTO GenreUpdate 
VALUES ('Racing', '23-FEB-2023');

INSERT INTO GenreUpdate 
VALUES ('Sandbox', '17-JAN-2023');


INSERT INTO GenreName
VALUES ('Role-Playing Game, a game in which players assume the roles of characters in a fictional setting', 'RPG');

INSERT INTO GenreName 
VALUES ('An action game is a video game genre that emphasizes physical challenges, including hand–eye coordination and reaction-time.', 'Action');

INSERT INTO GenreName 
VALUES ('Multiplayer online battle arena (MOBA) is a subgenre of strategy video games in which two teams of players compete against each other', 'MOBA');

INSERT INTO GenreName 
VALUES ('Racing games are a video game genre in which the player participates in a racing competition.', 'Racing');

INSERT INTO GenreName 
 VALUES ('A sandbox game is a video game with a gameplay element that provides players a great degree of creativity to interact with.', 'Sandbox');


INSERT INTO GenreDescription
VALUES (1, 'Role-Playing Game, a game in which players assume the roles of characters in a fictional setting');

INSERT INTO GenreDescription
VALUES (2, 'An action game is a video game genre that emphasizes physical challenges, including hand–eye coordination and reaction-time.');

INSERT INTO GenreDescription 
VALUES (3, 'Multiplayer online battle arena (MOBA) is a subgenre of strategy video games in which two teams of players compete against each other');

INSERT INTO GenreDescription 
VALUES (4, 'Racing games are a video game genre in which the player participates in a racing competition.');

INSERT INTO GenreDescription
VALUES (5, 'A sandbox game is a video game with a gameplay element that provides players a great degree of creativity to interact with.');


INSERT INTO BelongsTo 
VALUES (1, 1);

INSERT INTO BelongsTo 
VALUES (2, 2);

INSERT INTO BelongsTo
VALUES (3, 2);

INSERT INTO BelongsTo
VALUES (4, 1);

INSERT INTO BelongsTo
VALUES (5, 1);


INSERT
INTO Own
VALUES (2, 2, '06-MAY-2020', 'Purchased');

INSERT
INTO Own
VALUES (2, 4, '20-JUL-2021', 'Free for testing');

INSERT
INTO Own
VALUES (3, 5, '20-SEP-2022', 'Purchased');

INSERT
INTO Own
VALUES (5, 3, '25-DEC-2019', 'Gifted from friend');

INSERT
INTO Own
VALUES (1, 1, '28-FEB-2023', 'Purchased');

INSERT INTO CommunityAssociate 
VALUES (1, 2, 'Players made artwork', 'Artwork');

INSERT INTO CommunityAssociate 
VALUES (2, 5, 'In-game screenshots', 'Screenshot');

INSERT INTO CommunityAssociate
VALUES (3, 1, 'Trouble shooting discussion', 'Discussion');

INSERT INTO CommunityAssociate 
VALUES (4, 3, 'Trouble shooting discussion', 'Discussion');

INSERT INTO CommunityAssociate 
VALUES (5, 4, 'In-game screenshots', 'Screenshot');

INSERT 
INTO Participate
VALUES (1, 5);

INSERT 
INTO Participate
VALUES (2, 4);

INSERT 
INTO Participate
VALUES (3, 3);

INSERT 
INTO Participate
VALUES (4, 2);

INSERT 
INTO Participate
VALUES (5, 1);

INSERT
INTO SupportTicketStatus
VALUES ('Gameplay or technical issues', '23-JAN-2023', 3, 'In Progress');

INSERT
INTO SupportTicketStatus
VALUES ('Missing DLC or extra content', '19-OCT-2013', 2, 'Resolved');

INSERT
INTO SupportTicketStatus
VALUES ('Game Refund', '06-JUN-2021', 1, 'Resolved');

INSERT
INTO SupportTicketStatus
VALUES ('Game Refund', '23-JAN-2023', 2, 'In Progress');

INSERT
INTO SupportTicketStatus
VALUES ('Game is not in my game library', '06-SEP-2020', 5, 'Resolved');

INSERT
INTO SupportTicketRequest
VALUES (1, 'Gameplay or technical issues', '23-JAN-2023', 3);

INSERT
INTO SupportTicketRequest
VALUES (2, 'Missing DLC or extra content', '19-OCT-2013', 2);

INSERT
INTO SupportTicketRequest
VALUES (3, 'Game Refund', '06-JUN-2021', 1);

INSERT
INTO SupportTicketRequest
VALUES (4, 'Game Refund', '23-JAN-2023', 2);

INSERT
INTO SupportTicketRequest
VALUES (5, 'Game is not in my game library', '06-SEP-2020', 5);