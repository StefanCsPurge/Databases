-- T1: delay + insert + commit

begin tran
	waitfor delay '00:00:10'
	insert into Victims values('corleone6','LINUX PC','Poland')
	exec sp_log_changes null, 3, 'Phantom 1: insert', null
	exec sp_log_locks 'Phantom 1: after insert'
commit tran

-- delete from Victims where name = 'corleone6'
-- select * from Victims