
begin tran
	declare @oldData varchar(99)
	declare @newData varchar(99)
	waitfor delay '00:00:10'
	update Victims set @oldData=name, name='JJJJ', @newData=name where VicId=2
	exec sp_log_changes @oldData, @newData, 'Non-Repeatable Reads 1: update', null
	exec sp_log_locks 'Non-Repeatable Reads 1: after update'
commit tran