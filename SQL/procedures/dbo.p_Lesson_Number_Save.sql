USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_Lesson_Number_Save]    Script Date: 07.06.2017 19:58:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[p_Lesson_Number_Save]
	@Action int, @Lesson_Number_ID int, @Number int, @TimeBegin varchar(8), @TimeEnd varchar(8)
as
begin
	if (@Action = 1)
	begin
		insert into dbo.t_Lesson_Number (Number, TimeBegin, TimeEnd) 
		select @Number, cast(@TimeBegin as time(0)),  cast(@TimeEnd as time(0))
		return scope_identity()
	end
	else if (@Action = 2)
	begin
		update dbo.t_Lesson_Number 
		set 
			Number = @Number
			, TimeBegin = cast(@TimeBegin as time(0))
			, TimeEnd = cast(@TimeEnd as time(0))
		where 
			Lesson_Number_ID = @Lesson_Number_ID
	end
end
GO

