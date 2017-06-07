USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_Lesson_Type]    Script Date: 07.06.2017 19:58:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[p_Lesson_Type]
as
begin
	select lt.Lesson_Type_ID, lt.Name, lt.Symbol from dbo.t_Lesson_Type as lt
end
GO

