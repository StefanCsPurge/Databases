-- update conflict, T2
select @@SPID
select @@TRANCOUNT
DBCC USEROPTIONS

-- set transaction isolation level read uncommitted -- solution
set transaction isolation level snapshot

begin tran
	declare @oldData varchar(99)
	declare @newData varchar(99)
	update Victims set @oldData=name, name='updateConflictName2', @newData=name where VicId=2
	exec sp_log_changes @oldData, @newData, 'Update Conflict 2: update', null
	exec sp_log_locks 'Update Conflict 2: after update'
	select * from Victims
commit tran