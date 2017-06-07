USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_Subjects]    Script Date: 07.06.2017 20:02:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[p_Subjects]
as
begin
	select s.Subjects_ID, s.Name from dbo.t_Subjects as s
end
GO

