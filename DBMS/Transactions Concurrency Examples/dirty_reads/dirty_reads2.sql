-- console 2 
select @@TRANCOUNT
DBCC USEROPTIONS

BEGIN TRAN
	declare @oldData varchar(99)
	declare @newData varchar(99)

	UPDATE Victims set @oldData=name, name='wtfRomania1', @newData=name where VicId=2

	exec sp_log_changes @oldData, @newData, 'Dirty reads 2: update', null
	exec sp_log_locks 'Dirty reads 2: after update'
	waitfor delay '00:00:10'

	UPDATE Victims set @oldData=name, name='Romania112', @newData=name where VicId=2
	exec sp_log_changes @oldData, @newData, 'Dirty reads 2: update', null
	exec sp_log_locks 'Dirty reads 2: after update'
	waitfor delay '00:00:10'
ROLLBACK TRAN