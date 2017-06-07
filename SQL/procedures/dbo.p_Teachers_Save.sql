USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_Teachers_Save]    Script Date: 07.06.2017 20:02:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[p_Teachers_Save] 
	@Action int, @Teachers_ID int, @Name varchar(16)
as begin
	if (@Action = 1)
	begin
		insert into dbo.t_Teachers (Name) select @Name
	end
	else if (@Action = 2)
	begin
		update dbo.t_Teachers set Name = @Name where Teachers_ID = @Teachers_ID
	end
end
GO

