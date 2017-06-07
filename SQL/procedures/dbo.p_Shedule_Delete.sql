USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_Shedule_Delete]    Script Date: 07.06.2017 20:00:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[p_Shedule_Delete] @Shedule_ID int
as 
begin
	begin try
		begin tran
		delete from dbo.t_Files where Files_ID = (select Files_ID from dbo.t_Shedules where Shedules_ID = @Shedule_ID)
		delete from dbo.t_Shedules where Shedules_ID = @Shedule_ID
		delete from dbo.t_Shedules_Detail where Shedules_ID = @Shedule_ID		 
		if (@@trancount > 0) commit
	end try
	begin catch
		declare @ErrorMessage varchar(max) = error_message()
		if (@@trancount > 0) rollback
		raiserror('Ошибка при удалении расписания: %s', 16, 1, @ErrorMessage)
	end catch
end
GO

