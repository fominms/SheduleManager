-- {Заполнение таблиц}
insert into dbo.t_Weeks (Name, Symbol) values ('Нечетная', 'I'), ('Четная','II')
insert into dbo.t_Semestrs (Name) values ('Весенний'), ('Осенний')
insert into dbo.t_Days (Name) values ('Понедельник'), ('Вторник'), ('Среда'), ('Четверг'), ('Пятница'), ('Суббота')
insert into dbo.t_Lesson_Number (Number, TimeBegin, TimeEnd) values (1, '9:00', '10:30'), (2, '10:40', '12:10'), (3, '13:00', '14:30'), (4, '14:40', '16:10'), (5, '16:20', '17:50'), (6, '18:00', '19:30')
insert into dbo.t_Lesson_Type (Name, Symbol) values ('Лекция', 'лк'), ('Практика','пр'), ('Лабораторная','лаб')


