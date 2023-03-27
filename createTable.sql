-- Uncomment the following drop table clauses to debug create tables;
-- Note: The order of dropping table matters, or you will get error message:
-- RA-02449: unique/primary keys in table referenced by foreign keys.

-- DROP TABLE FriendOf;
-- DROP TABLE SupportTicketRequest;
-- DROP TABLE SupportTicketStatus;
-- DROP TABLE Participate;
-- DROP TABLE CommunityAssociate;
-- DROP TABLE Own;
-- DROP TABLE BelongsTo;
-- DROP TABLE GenreDescription;
-- DROP TABLE GenreName;
-- DROP TABLE GenreUpdate;
-- DROP TABLE ReviewWriteAssociateContent;
-- DROP TABLE ReviewWriteAssociateUser;
-- DROP TABLE DiscountAssociate;
-- DROP TABLE SalesEventContent;
-- DROP TABLE SalesEventDate;
-- DROP TABLE Developer;
-- DROP TABLE Publisher;
-- DROP TABLE GameInfo;
-- DROP TABLE CompanyInfo;
-- DROP TABLE CompanyRevenue;
-- DROP TABLE GameURL;
-- DROP TABLE GamePrice;
-- DROP TABLE UserInfo;
-- DROP TABLE UserProfile;



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
	Phone# CHAR(20),
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
    CID INTEGER NOT NULL,
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



