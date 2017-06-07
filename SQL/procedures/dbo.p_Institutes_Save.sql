USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_Institutes_Save]    Script Date: 07.06.2017 19:57:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[p_Institutes_Save] 
	@Action int, @Institutes_ID int, @Name varchar(16)
as begin
	if (@Action = 1)
	begin
		insert into dbo.t_Institutes (Name) select @Name
	end
	else if (@Action = 2)
	begin
		update dbo.t_Institutes set Name = @Name where Institutes_ID = @Institutes_ID
	end
end
GO

