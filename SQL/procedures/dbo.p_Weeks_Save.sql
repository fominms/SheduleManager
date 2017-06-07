USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_Weeks_Save]    Script Date: 07.06.2017 20:03:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[p_Weeks_Save]
	@Action int, @Weeks_ID int, @Name varchar(16), @Symbol varchar(8)
as begin
	if (@Action = 1)
	begin
		insert into dbo.t_Weeks(Name, Symbol) select @Name, @Symbol
	end
	else if (@Action = 2)
	begin
		update dbo.t_Weeks set Name = @Name, Symbol = @Symbol where Weeks_ID = @Weeks_ID
	end
end
GO

