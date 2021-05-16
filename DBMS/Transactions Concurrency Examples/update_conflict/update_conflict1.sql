-- update conflict, T1 
select @@SPID
select @@TRANCOUNT
DBCC USEROPTIONS

alter database Malware_use set allow_snapshot_isolation on

begin tran
	declare @oldData varchar(99)
	declare @newData varchar(99)
	update Victims set @oldData=name, name='updateConflictName', @newData=name where VicId=2
	waitfor delay '00:00:10'
	exec sp_log_changes @oldData, @newData, 'Update Conflict 1: update', null
	exec sp_log_locks 'Update Conflict 1: after update'
	select * from Victims
commit tran

-- ALTER DATABASE Malware_use SET ALLOW_SNAPSHOT_ISOLATION OFF