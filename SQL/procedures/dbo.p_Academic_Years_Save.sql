USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_Academic_Years_Save]    Script Date: 07.06.2017 19:55:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[p_Academic_Years_Save]
	@Action int, @Academic_Years_ID int, @Year_Begin int, @Year_End int
as
begin
	if (@Action = 1)
	begin
		insert into dbo.t_Academic_Years(Year_Begin, Year_End) select @Year_Begin, @Year_End
		return scope_identity()
	end
	else if (@Action = 2)
	begin
		update dbo.t_Academic_Years 
		set 
			Year_Begin = @Year_Begin 
			, Year_End = @Year_End
		where 
			Academic_Years_ID = @Academic_Years_ID
	end
end
GO

