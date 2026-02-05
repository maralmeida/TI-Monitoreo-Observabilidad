-- consulta1: total conexiones activas
SELECT COUNT(*) as ConexionesActivas 
FROM sys.dm_exec_sessions 
WHERE is_user_process = 1;

-- consulta2: quién mantiene conexiones activas
SELECT 
    session_id, 
    login_name, 
    host_name, 
    program_name 
FROM sys.dm_exec_sessions 
WHERE is_user_process = 1;

-- consulta3:  .mdf y .ldf archivos que componen base
SELECT name, size*8/1024 AS TamañoMB, max_size 
FROM sys.database_files;