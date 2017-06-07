USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_Lesson_Number]    Script Date: 07.06.2017 19:58:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[p_Lesson_Number]
as
begin
	select ln.Lesson_Number_ID, ln.Number, ln.TimeBegin, ln.TimeEnd from dbo.t_Lesson_Number as ln
end
GO

