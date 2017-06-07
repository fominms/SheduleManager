USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_ClassRooms_Save]    Script Date: 07.06.2017 19:56:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[p_ClassRooms_Save] 
	@Action int, @ClassRooms_ID int, @Name varchar(16)
as begin
	if (@Action = 1)
	begin
		insert into dbo.t_ClassRooms (Name) select @Name
		return scope_identity()
	end
	else if (@Action = 2)
	begin
		update dbo.t_ClassRooms set Name = @Name where ClassRooms_ID = @ClassRooms_ID
	end
end
GO

