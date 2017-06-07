USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_Subjects_Save]    Script Date: 07.06.2017 20:02:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[p_Subjects_Save] 
	@Action int, @Subjects_ID int, @Name varchar(16)
as begin
	if (@Action = 1)
	begin
		insert into dbo.t_Subjects (Name) select @Name
	end
	else if (@Action = 2)
	begin
		update dbo.t_Subjects set Name = @Name where Subjects_ID = @Subjects_ID
	end
end
GO

