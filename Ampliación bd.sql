
CREATE TABLE Process (
    idProcess INT PRIMARY KEY IDENTITY(1,1), -- Identificador único del proceso
    nameType NVARCHAR(100) NOT NULL,            -- Nombre del proceso (ej: "Anticipo", "Disciplinary process")
    typeCode NVARCHAR(50) NOT NULL,             -- Código del proceso (ej: "F-F-16", "F-TH-26")
    [version] INT NOT NULL,                       -- Versión del proceso
    createdAt DATETIME DEFAULT GETDATE(),       -- Fecha de creación
    updatedAt DATETIME        -- Fecha de actualización
);
CREATE TABLE [State] (
    idState INT PRIMARY KEY IDENTITY(1,1),      -- Identificador único del estado
    nameState NVARCHAR(100) NOT NULL,           -- Nombre del estado (ej: "Abierto", "Resolución")
    processId INT NOT NULL,                     -- Relación con el proceso (FK)
    position INT NOT NULL,                      -- Posición del estado en la secuencia
    createdAt DATETIME DEFAULT GETDATE(),       -- Fecha de creación
    updatedAt DATETIME,       -- Fecha de actualización
    CONSTRAINT FK_State_Process FOREIGN KEY (processId) 
        REFERENCES Process(idProcess)       -- Clave foránea a la tabla Process
);
CREATE TABLE Permission (
    idPermission INT PRIMARY KEY IDENTITY(1,1), -- Identificador único del permiso
    roleId INT NOT NULL,                        -- Relación con el rol (FK)
    processId INT NOT NULL,                     -- Relación con el proceso (FK)
    stateId INT NOT NULL,                       -- Relación con el estado (FK)
    createdAt DATETIME DEFAULT GETDATE(),       -- Fecha de creación
    updatedAt DATETIME DEFAULT GETDATE(),       -- Fecha de actualización
    CONSTRAINT FK_Permission_Process FOREIGN KEY (processId) 
        REFERENCES Process(idProcess),      -- Clave foránea a la tabla Process
    CONSTRAINT FK_Permission_State FOREIGN KEY (stateId) 
        REFERENCES State(idState),               -- Clave foránea a la tabla State
	CONSTRAINT FK_Permission_Role FOREIGN KEY (roleId)
		REFERENCES Role(idRole)
);

CREATE TABLE DisciplinaryProcess (
    idDisciplinaryProcess INT PRIMARY KEY IDENTITY(1,1),    -- Identificador único del proceso
    employedId INT NOT NULL,                    -- Relación con el empleado (FK)
	processId INT NOT NULL,
    stateProcessId INT NOT NULL,         -- Estado del proceso (ej: "Abierto", "Resolución") (FK)
    typeOfFault NVARCHAR(100) NOT NULL,         -- Tipo de falta
    dateOfFault DATETIME NOT NULL,              -- Fecha de la falta
    description NVARCHAR(MAX),         -- Descripción de la falta
    createdAt DATETIME DEFAULT GETDATE(),       -- Fecha de creación
    updatedAt DATETIME       -- Fecha de actualización
	CONSTRAINT FK_DisciplinaryProcess_Emplyed FOREIGN KEY (employedId)
		REFERENCES Employed(idEmployed),
	CONSTRAINT FK_DisciplinaryProcess_Process FOREIGN KEY (processId)
		REFERENCES Process(idProcess),
	CONSTRAINT FK_DisciplinaryProcess_State FOREIGN KEY (stateProcessId)
		REFERENCES	[State](idState)
);

CREATE TABLE DisciplinaryResolution (
    idResolution INT PRIMARY KEY IDENTITY(1,1), -- Identificador único de la resolución
    disciplinaryProcessId INT NOT NULL,         -- Relación con el proceso disciplinario (FK)
    resolutionDate DATETIME NOT NULL,           -- Fecha de la resolución
    sanctionApplied NVARCHAR(100) NOT NULL,    -- Sanción aplicada
    sanctionDays INT,                           -- Días de suspensión (opcional)
    descriptionSanction NVARCHAR(MAX), -- Descripción de la sanción
    createdBy INT NOT NULL,                     -- Usuario que creó la resolución (FK)
    updatedBy INT,                     -- Usuario que actualizó la resolución (FK)
    createdAt DATETIME DEFAULT GETDATE(),       -- Fecha de creación
    updatedAt DATETIME,       -- Fecha de actualización
	CONSTRAINT FK_Resolution_User FOREIGN KEY (createdBy)
		REFERENCES [User](idUser),
    CONSTRAINT FK_Resolution_Process FOREIGN KEY (disciplinaryProcessId) 
        REFERENCES DisciplinaryProcess(idDisciplinaryProcess), -- Clave foránea a DisciplinaryProcess
	CONSTRAINT FK_Resolution_User_Update FOREIGN KEY (updatedBy)
		REFERENCES [User](idUser)
);

CREATE TABLE [Notification] (
    idNotification INT PRIMARY KEY IDENTITY(1,1), -- Identificador único de la notificación
    disciplinaryProcessId INT NOT NULL,           -- Relación con el proceso disciplinario (FK)
    isNotificationDate BIT NOT NULL,              -- Indica si la notificación tiene fecha
    notificationDate DATETIME,                    -- Fecha de la notificación
    typeOfNotification NVARCHAR(100),    -- Tipo de notificación
    description NVARCHAR(MAX),           -- Descripción de la notificación
    createdAt DATETIME DEFAULT GETDATE(),         -- Fecha de creación
    updatedAt DATETIME,         -- Fecha de actualización
    CONSTRAINT FK_Notification_Process FOREIGN KEY (disciplinaryProcessId) 
        REFERENCES DisciplinaryProcess(idDisciplinaryProcess) -- Clave foránea a DisciplinaryProcess
);

CREATE TABLE [File] (
    idFile INT PRIMARY KEY IDENTITY(1,1),        -- Identificador único del archivo
    nameFile NVARCHAR(255) NOT NULL,             -- Nombre del archivo
    ubicationFile NVARCHAR(255),        -- Ubicación del archivo (ruta local o en la nube)
    linkFileCloudLocal NVARCHAR(255),            -- Enlace al archivo (si está en la nube)
    idCloudService NVARCHAR(100),                -- Identificador del servicio en la nube (opcional)
    typeFile NVARCHAR(50) NOT NULL,              -- Tipo de archivo (ej: "PDF", "Imagen", "Video")
    createdAt DATETIME DEFAULT GETDATE(),        -- Fecha de creación
    createdBy INT NOT NULL                       -- Usuario que subió el archivo (FK)
	CONSTRAINT FK_File_User FOREIGN KEY (createdBy)
		REFERENCES [User](idUser),
);

CREATE TABLE DisciplinaryFiles (
    idDisciplinaryFile INT PRIMARY KEY IDENTITY(1,1), -- Identificador único de la relación
    fileId INT NOT NULL,                              -- Relación con el archivo (FK)
    stateFile NVARCHAR(50) NOT NULL,                  -- Estado del archivo (ej: "Activo", "Inactivo")
    CONSTRAINT FK_DisciplinaryFiles_File FOREIGN KEY (fileId) 
        REFERENCES [File](idFile) -- Clave foránea a File
);