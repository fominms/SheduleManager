USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_Days_Save]    Script Date: 07.06.2017 19:56:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[p_Days_Save] 
	@Action int, @Days_ID int, @Name varchar(16)
as begin
	if (@Action = 1)
	begin
		insert into dbo.t_Days (Name) select @Name
		return scope_identity()
	end
	else if (@Action = 2)
	begin
		update dbo.t_Days set Name = @Name where Days_ID = @Days_ID
	end
end
GO

