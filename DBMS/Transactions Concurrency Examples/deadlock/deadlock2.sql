-- Deadlock, T2: update on table B + delay + update on table A

begin tran
	declare @oldData varchar(99)
	declare @newData varchar(99)
	update Malware set @oldData=severity, severity='mediumDeadlock', @newData=severity where Mid=1
	exec sp_log_changes @oldData, @newData, 'Deadlock 2: Update 1', null
	exec sp_log_locks 'Deadlock 2: between updates'
	waitfor delay '00:00:05'
	update Victims set @oldData=name, name='deadlockNameBoi', @newData=name where VicId=2
	exec sp_log_changes @oldData, @newData, 'Deadlock 2: Update 2', null
commit tran

-- select * from Victims
-- select * from Malware
