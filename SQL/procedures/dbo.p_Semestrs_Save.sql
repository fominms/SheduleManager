USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_Semestrs_Save]    Script Date: 07.06.2017 19:59:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[p_Semestrs_Save] 
	@Action int, @Semestrs_ID int, @Name varchar(16)
as begin
	if (@Action = 1)
	begin
		insert into dbo.t_Semestrs (Name) select @Name
	end
	else if (@Action = 2)
	begin
		update dbo.t_Semestrs set Name = @Name where Semestrs_ID = @Semestrs_ID
	end
end
GO

