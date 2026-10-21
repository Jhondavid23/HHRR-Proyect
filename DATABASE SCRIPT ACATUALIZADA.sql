-- Creación de la base de datos
CREATE DATABASE HHRRMODULE;
GO

USE HHRRMODULE;
GO

-- Tabla: User
CREATE TABLE [User] (
    idUser INT PRIMARY KEY IDENTITY(1,1),
    fullName NVARCHAR(100) NOT NULL,
    identityDocument NVARCHAR(50) NOT NULL,
    documentIdType NVARCHAR(10) NOT NULL,
    email NVARCHAR(100) NOT NULL,
    password NVARCHAR(100) NOT NULL,
    urlPhoto NVARCHAR(255),
    roleId INT NOT NULL,
    stateId INT NOT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME
);

-- Tabla: Role
CREATE TABLE [Role] (
    idRole INT PRIMARY KEY IDENTITY(1,1),
    nameRol NVARCHAR(50) NOT NULL,
	parentRoleId INT NULL, -- Relación jerárquica entre roles
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME,
	FOREIGN KEY (parentRoleId) REFERENCES [Role](idRole) -- Rolación jerárquica 
);

-- Tabla: UserState
CREATE TABLE UserState (
    idState INT PRIMARY KEY IDENTITY(1,1),
    nameState NVARCHAR(50) NOT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME
);

-- Tabla: Employed
CREATE TABLE Employed (
    idEmployed INT PRIMARY KEY IDENTITY(1,1),
    userId INT NOT NULL FOREIGN KEY REFERENCES [User](idUser),
    stateId INT NOT NULL FOREIGN KEY REFERENCES UserState(idState),
    position NVARCHAR(50) NOT NULL,
    department NVARCHAR(50) NOT NULL,
	clientAssigned VARCHAR(50),
    entryDate DATE NOT NULL,
	typeEmployed VARCHAR(50) NOT NULL,
    urlPhoto NVARCHAR(MAX),
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME
);

-- Tabla: TypeFormat
CREATE TABLE TypeFormat (
    idTypeFormat INT PRIMARY KEY IDENTITY(1,1),
    nameType NVARCHAR(50) NOT NULL,
    typeCode NVARCHAR(50) NOT NULL,
    [version] INT NOT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME
);

-- Tabla: RequestFormat
CREATE TABLE RequestFormat (
    idRequest INT PRIMARY KEY IDENTITY(1,1),
    nameRequest NVARCHAR(255) NOT NULL,
    idEmployed INT NOT NULL FOREIGN KEY REFERENCES Employed(idEmployed),
    idTypeFormat INT NOT NULL FOREIGN KEY REFERENCES TypeFormat(idTypeFormat),
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME
);

-- Tabla: typeFieldFormat
CREATE TABLE TypeFieldFormat (
    idTypeField INT PRIMARY KEY IDENTITY(1,1),
    idTypeFormat INT NOT NULL FOREIGN KEY REFERENCES TypeFormat(idTypeFormat),
    nameTypeField NVARCHAR(100) NOT NULL,
    TypeValue NVARCHAR(50) NOT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME
);

-- Tabla: FieldFormat
CREATE TABLE FieldFormat (
    idField INT PRIMARY KEY IDENTITY(1,1),
    idTypeField INT NOT NULL FOREIGN KEY REFERENCES TypeFieldFormat(idTypeField),
    idRequestFormat INT NOT NULL FOREIGN KEY REFERENCES RequestFormat(idRequest),
    nameFieldRequest NVARCHAR(255) NOT NULL,
    valueField NVARCHAR(MAX),
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME
);

-- Tabla: Authorizations
CREATE TABLE [Authorization] (
    idAuthorization INT PRIMARY KEY IDENTITY(1,1),
    idTypeFormat INT NOT NULL FOREIGN KEY REFERENCES TypeFormat(idTypeFormat),
    idRole INT NOT NULL FOREIGN KEY REFERENCES Role(idRole),
	idParentAuth INT FOREIGN KEY REFERENCES [Authorization](idAuthorization), --Parent authorization, to define groups 
    Nombre NVARCHAR(100) NOT NULL,
    position INT NOT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME
);

-- Tabla: RequestFormatAuth
CREATE TABLE RequestFormatAuth (
    idProcessState INT PRIMARY KEY IDENTITY(1,1),
    idAutorizacion INT NOT NULL FOREIGN KEY REFERENCES [Authorization](idAuthorization),
    idRequestFormat INT NOT NULL FOREIGN KEY REFERENCES RequestFormat(idRequest),
    [status] NVARCHAR(20) DEFAULT 'Pending',
	[value] BIT DEFAULT 0,
	comments NVARCHAR(MAX) NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME
);

-- Tabla: Logs
CREATE TABLE Logs (
    idLog INT PRIMARY KEY IDENTITY(1,1),
    userId INT NOT NULL FOREIGN KEY REFERENCES [User](idUser),
    action NVARCHAR(50) NOT NULL,
    description NVARCHAR(MAX),
    createdAt DATETIME DEFAULT GETDATE()
);

-- Relaciones y constraints
ALTER TABLE [User]
ADD CONSTRAINT FK_User_Role FOREIGN KEY (roleId) REFERENCES Role(idRole);

ALTER TABLE [User]
ADD CONSTRAINT FK_User_StateUser FOREIGN KEY (stateId) REFERENCES UserState(idState);
