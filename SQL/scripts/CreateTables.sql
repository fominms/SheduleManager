USE [DataBase_Shedule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

create table dbo.t_Files (Files_ID int identity(1,1), Name varchar(128), Date datetime, FileData varbinary(max)
	, constraint [PK_t_Files] primary key clustered (Files_ID asc) with (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) ON [PRIMARY] 
go
create table dbo.t_Semestrs (Semestrs_ID int identity(1,1), Name varchar(16)
	, constraint [PK_t_Semestrs] primary key clustered (Semestrs_ID asc) with (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) ON [PRIMARY] 
go
create table dbo.t_Days (Days_ID int identity(1,1), Name varchar(16)
	, constraint [PK_t_Days] primary key clustered (Days_ID asc) with (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) ON [PRIMARY] 
go
create table dbo.t_Weeks (Weeks_ID int identity(1,1), Name varchar(16), Symbol varchar(2)
	, constraint [PK_t_Weeks] primary key clustered (Weeks_ID asc) with (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) ON [PRIMARY] 
go
create table dbo.t_Subjects (Subjects_ID int identity(1,1), Name varchar(128)
	, constraint [PK_t_Subjects] primary key clustered (Subjects_ID asc) with (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) ON [PRIMARY] 
go
create table dbo.t_Academic_Years (Academic_Years_ID int identity(1,1), Year_Begin int, Year_End int
	, constraint [PK_t_Academic_Years] primary key clustered (Academic_Years_ID asc) with (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) ON [PRIMARY] 
go
create table dbo.t_Shedules (Shedules_ID int identity(1,1), Files_ID int, Accademic_Years_ID int, Institutes_ID int, Semesters_ID int, Is_Actual bit
	, constraint [PK_t_Shedules] primary key clustered (Shedules_ID asc) with (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) ON [PRIMARY] 
go
create table dbo.t_Institutes (Institutes_ID int identity(1,1), Name varchar(1024)
	, constraint [PK_t_Institutes] primary key clustered (Institutes_ID asc) with (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) ON [PRIMARY] 
go
create table dbo.t_Lesson_Number (Lesson_Number_ID int identity(1,1), Number int, TimeBegin time, TimeEnd time
	, constraint [PK_t_Lesson_Number] primary key clustered (Lesson_Number_ID asc) with (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) ON [PRIMARY] 
go
create table dbo.t_Lesson_Type (Lesson_Type_ID int identity(1,1), Name varchar(64), Symbol varchar(8)
	, constraint [PK_t_Lesson_Type] primary key clustered (Lesson_Type_ID asc) with (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) ON [PRIMARY] 
go
create table dbo.t_Teachers (Teachers_ID int identity(1,1), Name varchar(512)
	, constraint [PK_t_Teachers] primary key clustered (Teachers_ID asc) with (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) ON [PRIMARY] 
go
create table dbo.t_ClassRooms (ClassRooms_ID int identity(1,1), Name varchar(16)
	, constraint [PK_t_ClassRooms] primary key clustered (ClassRooms_ID asc) with (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) ON [PRIMARY] 
go
create table dbo.t_Groups (Groups_ID int identity(1,1), Name varchar(16)
	, constraint [PK_t_Groups] primary key clustered (Groups_ID asc) with (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) ON [PRIMARY] 
go
create table dbo.t_Shedules_Detail (Shedules_Detail_ID int identity(1,1), Shedules_ID int, Groups_ID int, Days_ID int, Weeks_ID int, Lesson_Number_ID int, Subject_ID int, Lesson_Type_ID int, Teachers_ID int, ClassRooms_ID int
	, constraint [PK_t_Shedules_Detail] primary key clustered (Shedules_Detail_ID asc) with (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) ON [PRIMARY] 
go

SET ANSI_PADDING OFF
GO
