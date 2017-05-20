alter database DataBase_Shedule set trustworthy on
go

create assembly SheduleCLR from 'D:\_sources\SheduleManagerLibrary\SheduleManagerLibrary\bin\Debug\SheduleManagerLibrary.dll'
with permission_set = unsafe
go