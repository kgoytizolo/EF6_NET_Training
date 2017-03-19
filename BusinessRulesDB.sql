-- Business Rules application Database:

-- Users from the application
CREATE TABLE dbo.TBL_USERS(
	UserId integer UNIQUE CLUSTERED IDENTITY,
	Login varchar(150) NOT NULL,
	Password varchar(30) NOT NULL,
	FirstName varchar(250) NOT NULL,
	LastName varchar(250) NOT NULL,
	Email varchar(200) NOT NULL 
)

CREATE INDEX Index_Users_Login ON dbo.TBL_USERS (Login)
sp_help TBL_USERS

-- Business Rule Type (Integrity / Behavior). Maybe it can be just an Enum
CREATE TABLE dbo.TBL_BUSINESS_RULES_TYPES
(
	BrTypeId tinyint UNIQUE CLUSTERED IDENTITY,
	BrTypeName varchar(30) NOT NULL,
	BrTypeDescription varchar(250)
)

-- Business Rule Category (Based on WC3 Business Rules standard Categories). Maybe it can be just an Enum
-- According to WC3 BR standards: https://www.w3.org/2004/12/rules-ws/slides/terrymoriarty.pdf
CREATE TABLE dbo.TBL_BUSINESS_RULES_CATEGORIES
(
	BrCategoryId tinyint UNIQUE CLUSTERED IDENTITY,
	BrCategoryName varchar(30) NOT NULL,
	BrCategoryDescription varchar(255)		
)

-- Business Rule Technology Type (If is a web application, a service application, a MEAN app, mobile app, etc)
CREATE TABLE dbo.TBL_TECHNOLOGIES
(
	TechnologyId smallint UNIQUE CLUSTERED IDENTITY,
	TechnologyName varchar(200)  NOT NULL,
	TechnologyDescription varchar(255),
	TechnologyVersion varchar(30) NOT NULL, 
	TechnologyMetadata varchar(255) NOT NULL,
	TechnologyFileTypes varchar(255) NOT NULL
)

CREATE INDEX Index_Technologies_Name ON dbo.TBL_TECHNOLOGIES (TechnologyName)

-- Business Rules Programming Language (For business rules searching)
CREATE TABLE dbo.TBL_PROGRAMMING_LANGUAGE
(
	ProgrammingLanguageId smallint UNIQUE CLUSTERED IDENTITY,
	ProgrammingLanguageName varchar(50) NOT NULL,
	ProgrammingLanguageDescription varchar (255),
	Version varchar(20) NOT NULL,
	CommentsSymbolIn varchar(5),
	CommentsSymbolOut varchar(5)
)

CREATE INDEX Index_Programming_Language_Name ON dbo.TBL_PROGRAMMING_LANGUAGE (ProgrammingLanguageName)

-- We need a relationship between technologies and programming language for an accurate business rules search
-- Example: A web application may have another projects or libraries in a different language than original. Same with FrontEnd

CREATE TABLE dbo.TBL_TECHNOLOGIES_PROGRAMMING_LANGUAGES(
	TechnologyId smallint FOREIGN KEY REFERENCES dbo.TBL_TECHNOLOGIES(TechnologyId),
	ProgrammingLanguageId smallint FOREIGN KEY REFERENCES dbo.TBL_PROGRAMMING_LANGUAGE(ProgrammingLanguageId)
)

CREATE INDEX Index_Technologies_ProgLang ON dbo.TBL_TECHNOLOGIES_PROGRAMMING_LANGUAGES (TechnologyId, ProgrammingLanguageId)

-- Business Rules tags to help on search
CREATE TABLE dbo.TBL_TAGS(
	TagId int UNIQUE CLUSTERED IDENTITY,
	TagName varchar(150) NOT NULL,
	TagDescription varchar(255)
)

CREATE INDEX Index_Tags_Name ON dbo.TBL_TAGS (TagName)

-- This is the application that should be analyzed in terms of business rules
CREATE TABLE dbo.TBL_APPLICATION(
	ApplicationId integer UNIQUE CLUSTERED IDENTITY,
	ApplicationName varchar(200) NOT NULL,
	ApplicationDescription varchar(255),
	ApplicationUrlSource varchar(255),
	CreationTime datetime DEFAULT GETDATE(),
	UserCreation integer FOREIGN KEY REFERENCES dbo.TBL_USERS(UserId)		-- FOREIGN KEY WITH USERS TABLE	
)

CREATE INDEX Index_Application_Name ON dbo.TBL_APPLICATION (ApplicationName)

-- Application technologies
CREATE TABLE dbo.TBL_APPLICATION_TECHNOLOGIES(
	ApplicationId integer FOREIGN KEY REFERENCES dbo.TBL_APPLICATION(ApplicationId),
	TechnologyId smallint FOREIGN KEY REFERENCES dbo.TBL_TECHNOLOGIES(TechnologyId)
)

CREATE INDEX Index_Application_Technologies ON dbo.TBL_APPLICATION_TECHNOLOGIES (ApplicationId, TechnologyId)

-- Business Rules Main Table
CREATE TABLE dbo.TBL_BUSINESS_RULES
(
	BrId integer UNIQUE CLUSTERED IDENTITY,
	BrName Varchar(250),
	BrDescription ntext,
	BrTypeId tinyint FOREIGN KEY REFERENCES dbo.TBL_BUSINESS_RULES_TYPES(BrTypeId),
	BrCategoryId tinyint FOREIGN KEY REFERENCES dbo.TBL_BUSINESS_RULES_CATEGORIES(BrCategoryId),  
	BrUserCreation integer FOREIGN KEY REFERENCES dbo.TBL_USERS(UserId),		-- FOREIGN KEY WITH USERS TABLE
	BrCreationTime datetime default getDate(),
	BrUserModification integer FOREIGN KEY REFERENCES dbo.TBL_USERS(UserId),	-- FOREIGN KEY WITH USERS TABLE
	BrLastModification datetime,
	BrDeprecated bit default 1	 
)

CREATE INDEX Index_Business_Rules_Name ON dbo.TBL_BUSINESS_RULES (BrName)

-- A Business rules might have in one or more apps
CREATE TABLE dbo.TBL_BUSINESS_RULES_PER_APPLICATION
(
	ApplicationId integer NOT NULL FOREIGN KEY REFERENCES dbo.TBL_APPLICATION(ApplicationId),
	BrId integer NOT NULL FOREIGN KEY REFERENCES dbo.TBL_BUSINESS_RULES(BrId),
	Component varchar(250) NOT NULL,
	Release varchar(200)
)

CREATE INDEX Index_Business_Rules_per_Application ON dbo.TBL_BUSINESS_RULES_PER_APPLICATION (ApplicationId, BrId)

-- Business rules and related tags for accurate findings
CREATE TABLE dbo.TBL_BUSINESS_RULES_TAGS
(
	BrId integer NOT NULL FOREIGN KEY REFERENCES dbo.TBL_BUSINESS_RULES(BrId),
	TagId int  NOT NULL FOREIGN KEY REFERENCES dbo.TBL_TAGS(TagId)
)

CREATE INDEX Index_Business_Rules_Tags ON dbo.TBL_BUSINESS_RULES_TAGS (BrId, TagId)


 