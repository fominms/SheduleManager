create procedure dbo.p_Shedules_List
as begin
	select 		
		s.Shedules_ID
		, f.Name as FileName
		, f.Date as FileDate
		, cast(ay.Year_Begin as varchar(4)) + ' - ' + cast(ay.Year_End as varchar(4)) as AcademicYears
		, i.Name as Institut
		, sem.Name as Semestr
		, s.Is_Actual		
	from dbo.t_Files as f
		left join dbo.t_Shedules as s on s.Files_ID = f.Files_ID
		left join dbo.t_Academic_Years as ay on ay.Academic_Years_ID = s.Accademic_Years_ID
		left join dbo.t_Institutes as i on i.Institutes_ID = s.Institutes_ID
		left join dbo.t_Semestrs as sem on sem.Semestrs_ID = s.Semesters_ID
end	