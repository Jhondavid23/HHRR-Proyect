CREATE DATABASE HHRRMODULE

USE HHRRMODULE;
CREATE TABLE [Role] (
    idRole INT PRIMARY KEY IDENTITY(1,1),
    nameRol VARCHAR(100) NOT NULL, -- 'Administrador', 'Colaborador', etc.
	createdAt DATETIME DEFAULT GETDATE(),
	updatedAt DATETIME
)

CREATE TABLE StateUser(
	idStateUser INT PRIMARY KEY IDENTITY(1,1),
	nameState VARCHAR(255) NOT NULL,
	createdAt DATETIME DEFAULT GETDATE(),
	updatedAt DATETIME
) 

CREATE TABLE [User] (
    idUser INT PRIMARY KEY IDENTITY(1,1),
    identityDocuemnt INT UNIQUE NOT NULL,
    fullName VARCHAR(100) NOT NULL,
    username VARCHAR(100) NOT NULL, -- Username o Email 
	[password] VARCHAR(255) NOT NULL,
	[stateId] INT FOREIGN KEY REFERENCES StateUser(idStateUser) NOT NULL, -- Activo, Inactivo, Suspendido, etc.
    roleId INT FOREIGN KEY REFERENCES [Role](idRole), -- Se relaciona con los Roles
    createdAt DATETIME DEFAULT GETDATE(),
	updatedAt DATETIME
)

CREATE TABLE Employed(
	idEmployed INT PRIMARY KEY IDENTITY(1,1),
	userId INT REFERENCES [User](idUser) NOT NULL,
	position VARCHAR(100) NOT NULL,
	department VARCHAR(100) NOT NULL,
	entryDate DATETIME NOT NULL,
	urlPhoto VARCHAR(MAX),
	cretedAt DATETIME DEFAULT GETDATE(),
	updatedAt DATETIME
)

CREATE TABLE TypeRecognitions(
	idTypeRecognition INT PRIMARY KEY IDENTITY(1,1),
	typeName VARCHAR(255) NOT NULL,
	createdAt DATETIME DEFAULT GETDATE(),
	updatedAt DATETIME
)

CREATE TABLE Recognition(
	idRecognition INT PRIMARY KEY IDENTITY(1,1),
	idEmployed INT REFERENCES Employed(idEmployed) NOT NULL,
	typeRecognitions INT REFERENCES TypeRecognitions(idTypeRecognition) NOT NULL,
	[description] VARCHAR(255) NOT NULL,
	recognitionDate DATETIME NOT NULL,
	[value] VARCHAR(255) NOT NULL,
	createdAt DATETIME DEFAULT GETDATE(),
	updatedAt DATETIME
)

CREATE TABLE RecognitionHistory(
	idRecognitionHistory INT PRIMARY KEY IDENTITY(1,1),
	recognitionId INT REFERENCES Recognition(idRecognition) NOT NULL,
	userId INT REFERENCES [User](idUser) NOT NULL,
	[action] VARCHAR(255) NOT NULL,
	createdAt DATETIME DEFAULT GETDATE(),
	updatedAt DATETIME
)

CREATE TABLE DisciplinaryProcess(
	idProcess INT PRIMARY KEY IDENTITY(1,1),
	idEmployed INT REFERENCES Employed(idEmployed) NOT NULL,
	reason TEXT NOT NULL,
	processDate DATETIME NOT NULL,
	[stateOfProcess] VARCHAR(255) NOT NULL,
	[value] DECIMAL(10,2) NOT NULL,
	createdAt DATETIME DEFAULT GETDATE(),
	updatedAt DATETIME
)

CREATE TABLE DiscuplinaryProcessHistory(
	idProcess INT PRIMARY KEY IDENTITY(1,1),
	processId INT REFERENCES DisciplinaryProcess(idProcess) NOT NULL,
	userId INT REFERENCES [User](idUser) NOT NULL,
	[action] VARCHAR(255) NOT NULL,
	createdAt DATETIME DEFAULT GETDATE(),
	updatedAt DATETIME
)

CREATE TABLE TypeRequest(
	idTypeRequest INT PRIMARY KEY IDENTITY(1,1),
	nameType VARCHAR(255) NOT NULL,
	typeCode VARCHAR(100) NOT NULL,
	[version] VARCHAR(100) NOT NULL,
	createdAt DATETIME DEFAULT GETDATE(),
)

CREATE TABLE RequestFormat(
	idRequest INT PRIMARY KEY IDENTITY(1,1),
	idEmployed INT REFERENCES Employed(idEmployed) NOT NULL,
	idTypeRequest INT REFERENCES TypeRequest(idTypeRequest) NOT NULL,
	nameRequest VARCHAR(255) NOT NULL,
	[state] VARCHAR(100) NOT NULL,
	createdAt DATETIME DEFAULT GETDATE(),
	updatedAt DATETIME
)

CREATE TABLE TypeFieldRequest(
	idTypeRequest INT PRIMARY KEY IDENTITY(1,1),
	nameType VARCHAR(100) NOT NULL,
	createdAt DATETIME DEFAULT GETDATE(),
	updatedAt DATETIME
)

CREATE TABLE FieldRequest(
	idField INT PRIMARY KEY IDENTITY(1,1),
	idTypeField INT REFERENCES TypeFieldRequest(idTypeRequest) NOT NULL,
	idRequest INT REFERENCES RequestFormat(idRequest) NOT NULL,
	nameFieldRequest VARCHAR(255) NOT NULL,
	[value] VARCHAR(255) NOT NULL,
	[state] VARCHAR(255) NOT NULL,
	createdAt DATETIME DEFAULT GETDATE(),
	updatedAt DATETIME
)