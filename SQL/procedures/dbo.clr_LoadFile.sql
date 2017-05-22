create procedure clr_LoadFile @FileName nvarchar(max), @FileBinary varbinary(max) out, @ErrorMessage nvarchar(max) out
as external name SheduleCLR.[SheduleManagerLibrary.File].Load
go