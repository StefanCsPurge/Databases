-- Deadlock T1: update on table A + delay + update on table B
-- solution: make the updates in the same order as in T2

SET DEADLOCK_PRIORITY HIGH
begin tran
	declare @oldData varchar(99)
	declare @newData varchar(99)

	update Victims set @oldData=name, name='theDeadlockBoi', @newData=name where VicId=2
	exec sp_log_changes @oldData, @newData, 'Deadlock 1: Update 1', null

	exec sp_log_locks 'Deadlock 1: between updates'
	waitfor delay '00:00:10'

	update Malware set @oldData=severity, severity='mediumusDeadlock', @newData=severity where Mid=1
	exec sp_log_changes @oldData, @newData, 'Deadlock 1: Update 2', null

commit tran
