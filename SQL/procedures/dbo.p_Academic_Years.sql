USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_Academic_Years]    Script Date: 07.06.2017 19:55:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[p_Academic_Years]
as
begin
	select 
		ay.Academic_Years_ID
		, ay.Year_Begin
		, ay.Year_End
		, cast(ay.Year_Begin as varchar(4)) + ' - ' + cast(ay.Year_End as varchar(4)) as AcademicYears
	from dbo.t_Academic_Years as ay
end
GO

