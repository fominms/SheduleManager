USE [DataBase_Shedule]
GO

/****** Object:  StoredProcedure [dbo].[p_Rep_SheduleTeacher]    Script Date: 07.06.2017 19:59:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[p_Rep_SheduleTeacher] 
@Academic_Years_ID int, @Semesters_ID int, @Teachers_ID int
as 
begin
	select
		sh.Shedules_ID
		, cast(ay.Year_Begin as varchar(4)) + ' - ' + cast(ay.Year_End as varchar(4)) as AcademicYears
		, ay.Academic_Years_ID as _AcademicYearsID
		, inst.Name as InstitutName
		, inst.Institutes_ID as _InstitutID
		, sem.Name as SemestrName
		, sem.Semestrs_ID as _SemestrID
		, shd.Shedules_Detail_ID
		, d.Name as DayName
		, g.Name as GroupName
		, ln.Number as LessonNumber
		, ln.TimeBegin
		, ln.TimeEnd
		, lt.Name as LessonTypeName
		, lt.Symbol as LessonTypeSymbol
		, s.Name as SubjectName
		, t.Name as TeacherName
		, w.Name as WeekName
		, w.Symbol as WeekSymbol
		, cr.Name as ClassRoomName
	from dbo.t_Shedules as sh
		left join dbo.t_Shedules_Detail as shd on shd.Shedules_ID = sh.Shedules_ID
		left join dbo.t_Academic_Years as ay on ay.Academic_Years_ID = sh.Accademic_Years_ID
		left join dbo.t_Institutes as inst on inst.Institutes_ID = sh.Institutes_ID
		left join dbo.t_Semestrs as sem on sem.Semestrs_ID = sh.Semesters_ID
		left join dbo.t_Days as d on d.Days_ID = shd.Days_ID
		left join dbo.t_Groups as g on g.Groups_ID = shd.Groups_ID
		left join dbo.t_Lesson_Number as ln on ln.Lesson_Number_ID = shd.Lesson_Number_ID
		left join dbo.t_Lesson_Type as lt on lt.Lesson_Type_ID = shd.Lesson_Type_ID
		left join dbo.t_Subjects as s on s.Subjects_ID = shd.Subject_ID
		left join dbo.t_Teachers as t on t.Teachers_ID = shd.Teachers_ID
		left join dbo.t_Weeks as w on w.Weeks_ID = shd.Weeks_ID
		left join dbo.t_ClassRooms as cr on cr.ClassRooms_ID = shd.ClassRooms_ID
	where sh.Accademic_Years_ID = @Academic_Years_ID
		and sh.Semesters_ID = @Semesters_ID
		and shd.Teachers_ID = @Teachers_ID
end
GO

