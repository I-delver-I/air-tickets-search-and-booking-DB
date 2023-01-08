USE msdb;
GO

EXEC sp_add_schedule
	@schedule_name = 'ThreeMonthlyJobs',
	@freq_type = 16,
	@freq_recurrence_factor = 3,
	@active_start_date = 20221229,
	@active_start_time = 1500
GO

EXEC sp_attach_schedule
	@job_name = 'UnbookedTicketsDeletion',
	@schedule_name = 'ThreeMonthlyJobs'
GO