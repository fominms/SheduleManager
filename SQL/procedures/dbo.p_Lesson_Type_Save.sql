USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_Lesson_Type_Save]    Script Date: 07.06.2017 19:59:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[p_Lesson_Type_Save]
	@Action int, @Lesson_Type_ID int, @Name varchar(16), @Symbol varchar(8)
as begin
	if (@Action = 1)
	begin
		insert into dbo.t_Lesson_Type(Name, Symbol) select @Name, @Symbol
	end
	else if (@Action = 2)
	begin
		update dbo.t_Lesson_Type set Name = @Name, Symbol = @Symbol where Lesson_Type_ID = @Lesson_Type_ID
	end
end
GO

