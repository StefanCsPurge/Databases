-- console 1
select @@TRANCOUNT
DBCC USEROPTIONS

set transaction isolation level read uncommitted
-- set transaction isolation level read committed -- problem solved

BEGIN TRAN 
	SELECT * FROM Victims
	exec sp_log_locks 'Dirty reads 1: after select'
	waitfor delay '00:00:10'
	SELECT * FROM Victims
	waitfor delay '00:00:10'
	SELECT * FROM Victims
COMMIT TRAN



