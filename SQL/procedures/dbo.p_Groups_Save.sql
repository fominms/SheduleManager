USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_Groups_Save]    Script Date: 07.06.2017 19:57:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[p_Groups_Save] 
	@Action int, @Groups_ID int, @Name varchar(16)
as begin
	if (@Action = 1)
	begin
		insert into dbo.t_Groups (Name) select @Name
		return scope_identity()
	end
	else if (@Action = 2)
	begin
		update dbo.t_Groups set Name = @Name where Groups_ID = @Groups_ID
	end
end
GO

