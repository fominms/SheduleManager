-- {Путь к файлу} 
declare @FilePath varchar(max) = 'D:\_sources\SheduleManager\Files\it-1k-16_17-vesna-novoe.xlsx' 
declare @FileData varbinary(max) = null

-- {Если запускается из Microsoft SQL Server Management Studio, то выводим сообщения} 
if app_name() like '%Microsoft SQL Server Management Studio%' declare @_debug bit = 1

-- {Создание таблиц, пока будут табличные переменные} 
declare @t_Files table (Files_ID int identity(1,1), Name varchar(128), Date datetime, FileData varbinary(max)) 
declare @t_Semestrs table (Semestrs_ID int identity(1,1), Name varchar(16))
declare @t_Days table (Days_ID int identity(1,1), Name varchar(16))
declare @t_Weeks table (Weeks_ID int identity(1,1), Name varchar(16), Symbol varchar(2))
declare @t_Subjects table (Subjects_ID int identity(1,1), Name varchar(128)) 
declare @t_Academic_Years table (Academic_Years_ID int identity(1,1), Year_Begin int, Year_End int) 
declare @t_Shedules table (Shedules_ID int identity(1,1), Files_ID int, Accademic_Years_ID int, Institutes_ID int, Semesters_ID int) 
declare @t_Institutes table (Institutes_ID int identity(1,1), Name varchar(1024)) 
declare @t_Lesson_Number table (Lesson_Number_ID int identity(1,1), Number int, TimeBegin time, TimeEnd time)
declare @t_Lesson_Type table (Lesson_Type_ID int identity(1,1), Name varchar(64), Symbol varchar(8))
declare @t_Teachers table (Teachers_ID int identity(1,1), Name varchar(512)) 
declare @t_ClassRooms table (ClassRooms_ID int identity(1,1), Name varchar(16)) 
declare @t_Groups table (Groups_ID int identity(1,1), Name varchar(16)) 
declare @t_Shedules_Detail table (Shedules_Detail_ID int identity(1,1), Shedules_ID int, Groups_ID int, Days_ID int, Weeks_ID int, Lesson_Number_ID int, Subject_ID int, Lesson_Type_ID int, Teachers_ID int, ClassRooms_ID int)

-- {Заполнение таблиц}
insert into @t_Weeks (Name, Symbol) values ('Нечетная', 'I'), ('Четная','II')
insert into @t_Semestrs (Name) values ('Весенний'), ('Осенний')
insert into @t_Days (Name) values ('Понедельник'), ('Вторник'), ('Среда'), ('Четверг'), ('Пятница'), ('Суббота')
insert into @t_Lesson_Number (Number, TimeBegin, TimeEnd) values
	(1, '9:00', '10:30'), (2, '10:40', '12:10'), (3, '13:00', '14:30'), (4, '14:40', '16:10'), (5, '16:20', '17:50'), (6, '18:00', '19:30')
insert into @t_Lesson_Type (Name, Symbol) values ('Лекция', 'лк'), ('Практика','пр'), ('Лабораторная','лаб')

-- {Получим имя файла} 
declare @FileName varchar(1024) = right(@FilePath, charindex('\', reverse(@FilePath))-1)

-- {Запишем файл в таблицу} 
insert into @t_Files (Name, Date, FileData) select @FileName, getdate(), @FileData 
declare @Files_ID int = scope_identity()

-- {Заполнение временной таблицы из файла} 
if object_id('tempdb..#rasp') is not null drop table #rasp

-- {Добавим файл Excel к связному серверу}
if (exists(select 1 from sys.servers where name = 'XlsLnkSrv')) exec sp_dropserver @server = 'XlsLnkSrv', @droplogins = 'droplogins'
exec sp_addlinkedserver @server = 'XlsLnkSrv', @srvproduct = 'ACE 12.0', @provider = 'Microsoft.ACE.OLEDB.12.0', @datasrc = @FilePath, @provstr = 'Excel 12.0; HDR=No; IMEX=1;'

select * into #rasp from openquery (XlsLnkSrv, 'select * from [Лист1$]')



--exec('select * into #rasp from openrowset(''Microsoft.ACE.OLEDB.12.0'', ''Excel 12.0; HDR=No; IMEX=1; Database='+@FilePath+''', [Лист1$]) tt')

-- {Узнаем количество колонок во временной таблице} 
declare @_countColumns int = (select count(*) from tempdb.sys.columns where object_id = object_id('tempdb..#rasp')) 
if (@_debug = 1) raiserror('# Количество колонок во временной таблице: %i', 0, 1, @_countColumns)

-- {Добавим поле id} 
alter table #rasp add id int identity(1,1)

-- {Колонки временной таблицы} 
--select * from tempdb.sys.columns where object_id = object_id('tempdb..#rasp')

-- {Получим строку с описанием института, курса и учебного года} 
declare @_information varchar(max) = (select top 1 F2 from #rasp) 
set @_information = replace(replace(replace(@_information, char(10), ''), char(13), ''), '  ', '') 
if (@_debug = 1) raiserror('# @_information = %s', 1, 0, @_information)

-- {Разберем полученную строку} 
declare @_semestr varchar(max) = right(rtrim(left(@_information, charindex('СЕМЕСТРА', upper(@_information))-1))
	, charindex(' ', reverse(rtrim(left(@_information, charindex('СЕМЕСТРА', upper(@_information))-1))))-1)
declare @Semestrs_ID int 
if (upper(@_semestr) = 'ВЕСЕННЕГО') set @Semestrs_ID = (select Semestrs_ID from @t_Semestrs where Name = 'Весенний')
else set @Semestrs_ID = (select Semestrs_ID from @t_Semestrs where Name = 'Осенний')

declare @_institut varchar(max) = left(substring(@_information, charindex('КУРСА', upper(@_information))+6, len(@_information)),
	charindex(' НА ', upper(substring(@_information, charindex('КУРСА', upper(@_information))+6, len(@_information))))-1)
if (upper(@_institut) like 'ИНСТИТУТА') set @_institut = replace(@_institut, 'Института', 'Институт') 
if (upper(@_institut) like 'ФИЛИАЛА') set @_institut = replace(@_institut, 'Филиала', 'Филиал')

declare @_academicYears varchar(max) = right(@_information, charindex(' АН ', reverse(upper(@_information)))-1) 
declare @_yearBegin int = substring(@_academicYears, 1, charindex('-', @_academicYears)-1) 
declare @_yearEnd int = substring(@_academicYears, charindex('-', @_academicYears)+1, 4)

-- {Добавим строку в таблицу расписаний} 
declare @Institutes_ID int 
if (not(exists(select top 1 * from @t_Institutes where upper(Name) = upper(@_institut)))) 
begin
	insert into @t_Institutes (Name) select @_institut 
	set @Institutes_ID = scope_identity()
end 
else 
begin
	set @Institutes_ID = (select Institutes_ID from @t_Institutes where upper(Name) = upper(@_institut))
end

declare @Academic_Years_ID int 
if (not(exists(select top 1 * from @t_Academic_Years where Year_Begin = @_yearBegin and Year_End = @_yearEnd))) 
begin
	insert into @t_Academic_Years (Year_Begin, Year_End) select @_yearBegin, @_yearEnd 
	set @Academic_Years_ID = scope_identity()
end 
else 
begin
	set @Academic_Years_ID = (select Academic_Years_ID from @t_Academic_Years where Year_Begin = @_yearBegin and Year_End = @_yearEnd)
end

insert into @t_Shedules (Files_ID, Accademic_Years_ID, Institutes_ID, Semesters_ID) select @Files_ID, @Academic_Years_ID, @Institutes_ID, @Semestrs_ID 
declare @Shedules_ID int = scope_identity()

-- {Удалим ненужные поля} 
delete from #rasp where id = 1 
delete from #rasp where id >= (select id from #rasp where upper(F3) like upper('%Начальник%'))

if object_id('tempdb..#t_rasp') is not null drop table #t_rasp

create table #t_rasp (
	id int identity(1,1), GroupNumber varchar(max), Day varchar(max), NumberLesson varchar(max) 
	, DateBegin varchar(max), DateEnd varchar(max), Weekend varchar(max), Name varchar(max) 
	, Type varchar(max), Teacher varchar(max), Cabinet varchar(max), old_id int)
declare @i int = 2 

while @i <= @_countColumns 
begin
	declare @_columnName varchar(8) = (select name from tempdb.sys.columns where object_id = object_id('tempdb..#rasp') and column_id = @i) 
	declare @_sql nvarchar(max) = N'set @_columnValue = (select ' + @_columnName + ' from #rasp where id = 3)' 
	declare @_columnValue varchar(max) 
	
	exec sp_executesql @_sql, N'@_columnValue varchar(max) out', @_columnValue = @_columnValue out 
	if (upper(ltrim(rtrim(@_columnValue))) = 'ПРЕДМЕТ') 
	begin
		-- {Узнаем номер группы} 
		declare @_groupNumber varchar(max) 
		set @_sql = N'set @_groupNumber = (select ' + @_columnName + ' from #rasp where id = 2)' 
		exec sp_executesql @_sql, N'@_groupNumber varchar(max) out', @_groupNumber = @_groupNumber out 	

		set @_sql = N' insert into #t_rasp (GroupNumber, Day, NumberLesson, DateBegin, DateEnd, Weekend, Name, Type, Teacher, Cabinet, old_id)
			select ''' + @_groupNumber + ''', F1, F2, F3, F4, F5, F' + cast(@i as varchar) + ', F' + cast(@i+1 as varchar) + ', F' + cast(@i+2 as varchar) + ', F' + cast(@i+3 as varchar) + ', id from #rasp where id >= 4' 
		exec sp_executesql @_sql
	end 
	set @i += 1
end 
if object_id('tempdb..#rasp') is not null drop table #rasp

-- {Почистим таблицу от ненужных данных} 
update #t_rasp set Name = null where Name in ('День', 'самостоятельных', 'занятий')

select * from #t_rasp

declare
	@id int
	, @GroupNumber varchar(max) 
	, @Day varchar(max) 
	, @NumberLesson varchar(max) 
	, @DateBegin varchar(max) 
	, @DateEnd varchar(max) 
	, @Weekend varchar(max) 
	, @SubjectName varchar(max) 
	, @Type varchar(max) 
	, @Teacher varchar(max) 
	, @Cabinet varchar(max)

declare
	@Groups_ID int 
	, @Days_ID int 
	, @Lesson_Number_ID int 
	, @Weeks_ID int 
	, @Subject_ID int 
	, @Lesson_Type_ID int 
	, @Teachers_ID int 
	, @ClassRooms_ID int
	
while (exists(select top 1 * from #t_rasp order by id)) 
begin
	select top 1 @id = id, @GroupNumber = GroupNumber , @Day = Day , @NumberLesson = NumberLesson , @DateBegin = DateBegin , @DateEnd = DateEnd , @Weekend = Weekend , @SubjectName = Name , @Type = Type , @Teacher = Teacher , @Cabinet = Cabinet
	from #t_rasp order by id

-- {Очистим переменные} 
-- {Получим значения для записи в таблицы} 
if ((@GroupNumber is not null) and (not(exists(select top 1 * from @t_Groups where upper(Name) = upper(@GroupNumber))))) 
begin
	insert into @t_Groups (Name) select @GroupNumber set @Groups_ID = scope_identity()
end 
else 
begin
	set @Groups_ID = (select Groups_ID from @t_Groups where upper(Name) = upper(@GroupNumber))
end

if (@Day is not null) set @Days_ID = (select Days_ID from @t_Days where upper(Name) = upper(@Day)) 
if (@NumberLesson is not null) set @Lesson_Number_ID = (select Lesson_Number_ID from @t_Lesson_Number where Number = @NumberLesson) 
set @Weeks_ID = (select Weeks_ID from @t_Weeks where Symbol = @Weekend) 
set @Lesson_Type_ID = (select Lesson_Type_ID from @t_Lesson_Type where upper(Symbol) = upper(@Type))

if ((@SubjectName is not null) and (not(exists(select top 1 * from @t_Subjects where upper(Name) = upper(@SubjectName))))) 
begin
	insert into @t_Subjects (Name) select @SubjectName set @Subject_ID = scope_identity()
end 
else 
begin
	set @Subject_ID = (select Subjects_ID from @t_Subjects where upper(Name) = upper(@SubjectName))
end

if ((@Teacher is not null) and (not(exists(select top 1 * from @t_Teachers where upper(Name) = upper(@Teacher))))) 
begin
	insert into @t_Teachers (Name) select (@Teacher) set @Teachers_ID = scope_identity()
end 
else 
begin
	set @Teachers_ID = (select Teachers_ID from @t_Teachers where upper(Name) = upper(@Teacher))
end

if ((@Cabinet is not null) and (not(exists(select top 1 * from @t_ClassRooms where upper(Name) = upper(@Cabinet))))) 
begin
	insert into @t_ClassRooms (Name) select (@Cabinet) set @ClassRooms_ID = scope_identity()
end 
else 
begin
	set @ClassRooms_ID = (select ClassRooms_ID from @t_ClassRooms where upper(Name) = upper(@Cabinet))
end

insert into @t_Shedules_Detail (Shedules_ID, Groups_ID, Days_ID, Weeks_ID, Lesson_Number_ID, Subject_ID, Lesson_Type_ID, Teachers_ID, ClassRooms_ID) select @Shedules_ID, @Groups_ID, @Days_ID, @Weeks_ID, @Lesson_Number_ID, @Subject_ID, @Lesson_Type_ID, @Teachers_ID, @ClassRooms_ID

delete from #t_rasp where id = @id

end if object_id('tempdb..#rasp') is not null drop table #t_rasp select * from @t_Shedules_Detail