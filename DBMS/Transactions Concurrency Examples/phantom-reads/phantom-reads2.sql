-- T2: select + delay + select

-- set transaction isolation level repeatable read
set transaction isolation level serializable -- solution

begin tran
	select * from Victims
	exec sp_log_locks 'Phantom 2: between selects'
	waitfor delay '00:00:10'
	select * from Victims
	exec sp_log_locks 'Phantom 2: after both selects'
commit tran 

