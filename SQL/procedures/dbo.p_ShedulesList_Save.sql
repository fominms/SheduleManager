USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_ShedulesList_Save]    Script Date: 07.06.2017 20:01:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[p_ShedulesList_Save]
	@ShedulesID int, @AcademicYearsID int, @InstitutID int, @SemestrID int, @IsActual bit
as
begin
	begin tran
	begin try
		update dbo.t_Shedules
		set Accademic_Years_ID = @AcademicYearsID
			, Institutes_ID = @InstitutID
			, Semesters_ID = @SemestrID
			, IS_Actual = @IsActual
		where
			Shedules_ID = @ShedulesID
		if (@@trancount > 0) commit
	end try
	begin catch
		declare @ErrorMessage varchar(max) = error_message()		
		if (@@trancount > 0) rollback
		raiserror('%s', 16, 1, @ErrorMessage)		
	end catch
end


GO

