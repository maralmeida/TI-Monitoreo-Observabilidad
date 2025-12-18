-- Crea BD
CREATE DATABASE UsuariosApp;
GO

USE UsuariosApp;
GO

-- Crea tabla con campos de formulario
CREATE TABLE registros (
    id INT IDENTITY(1,1) PRIMARY KEY, -- Se numera solo
    nombre NVARCHAR(100),
    edad INT,
    genero NVARCHAR(20),
    pais NVARCHAR(50),
    profesion NVARCHAR(50),
    fecha_registro DATETIME DEFAULT GETDATE() -- Guarda cuándo se creó registro
);

select * from registros;
