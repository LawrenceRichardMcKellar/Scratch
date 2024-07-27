drop function if exists [dbo].[varchar_split];
go
create function [dbo].[varchar_split]
(
    @text varchar(max),
    @delimiter char(1) = ','
)
returns table
as
return (select [Value] from string_split(@text, @delimiter) where 0 != len([Value]));
go

drop type if exists [dbo].[varchar_set];
go
create type [dbo].[varchar_set]
as table
(
    [Value] varchar(128) not null primary key
);
go

drop function if exists [dbo].[varchar_split_distinct];
go
create function [dbo].[varchar_split_distinct]
(
    @text varchar(max),
    @delimiter char(1) = ','
)
returns @result table ([Value] varchar(128) not null primary key)
as
begin
    insert @result
    select distinct [Value] from string_split(@text, @delimiter) where 0 != len([Value]);
    return;
end;
go

drop type if exists [dbo].[varchar_list];
go
create type [dbo].[varchar_list]
as table
(
    [Ordinal] int not null primary key,
    [Value] varchar(128) not null
);
go

drop function if exists [dbo].[varchar_ordinalsplit];
go
create function [dbo].[varchar_ordinalsplit]
(
    @text varchar(max),
    @delimiter char(1) = ','
)
returns @result table ([Ordinal] int not null identity(1, 1) primary key, [Value] varchar(128) not null)
as
begin
    insert @result ([Value])
    select
        [Value]
    from
        string_split(@text, @delimiter)
    where
        0 != len([Value])
    ;
    return;
end;
go



drop function if exists [dbo].[nvarchar_split];
go
create function [dbo].[nvarchar_split]
(
    @text nvarchar(max),
    @delimiter nchar(1) = ','
)
returns table
as
return (select [Value] from string_split(@text, @delimiter) where 0 != len([Value]));
go

drop type if exists [dbo].[nvarchar_set];
go
create type [dbo].[nvarchar_set]
as table
(
    [Value] nvarchar(128) not null primary key
);
go

drop function if exists [dbo].[nvarchar_split_distinct];
go
create function [dbo].[nvarchar_split_distinct]
(
    @text nvarchar(max),
    @delimiter nchar(1) = ','
)
returns @result table ([Value] nvarchar(128) not null primary key)
as
begin
    insert @result
    select distinct [Value] from string_split(@text, @delimiter) where 0 != len([Value]);
    return;
end;
go

drop type if exists [dbo].[nvarchar_list];
go
create type [dbo].[nvarchar_list]
as table
(
    [Ordinal] int not null primary key,
    [Value] nvarchar(128) not null
);
go

drop function if exists [dbo].[nvarchar_ordinalsplit];
go
create function [dbo].[nvarchar_ordinalsplit]
(
    @text nvarchar(max),
    @delimiter nchar(1) = ','
)
returns @result table ([Ordinal] int not null identity(1, 1) primary key, [Value] nvarchar(128) not null)
as
begin
    insert @result ([Value])
    select
        [Value]
    from
        string_split(@text, @delimiter)
    where
        0 != len([Value])
    ;
    return;
end;
go


drop function if exists [dbo].[int_split];
go
create function [dbo].[int_split]
(
    @text varchar(max),
    @delimiter char(1) = ','
)
returns table
as
return (select cast([Value] as int) [Value] from string_split(@text, @delimiter) where 0 != len([Value]));
go

drop type if exists [dbo].[int_set];
go
create type [dbo].[int_set]
as table
(
    [Value] int not null primary key
);
go

drop function if exists [dbo].[int_split_distinct];
go
create function [dbo].[int_split_distinct]
(
    @text varchar(max),
    @delimiter char(1) = ','
)
returns @result table ([Value] int not null primary key)
as
begin
    insert @result
    select distinct cast([Value] as int) [Value] from string_split(@text, @delimiter) where 0 != len([Value]);
    return;
end;
go

drop type if exists [dbo].[int_list];
go
create type [dbo].[int_list]
as table
(
    [Ordinal] int not null primary key,
    [Value] int not null
);
go

drop function if exists [dbo].[int_ordinalsplit];
go
create function [dbo].[int_ordinalsplit]
(
    @text nvarchar(max),
    @delimiter nchar(1) = ','
)
returns @result table ([Ordinal] int not null identity(1, 1) primary key, [Value] int not null)
as
begin
    insert @result ([Value])
    select
        cast([Value] as int) [Value]
    from
        string_split(@text, @delimiter)
    where
        0 != len([Value])
    ;
    return;
end;
go



drop function if exists [dbo].[uniqueidentifier_split];
go
create function [dbo].[uniqueidentifier_split]
(
    @text varchar(max),
    @delimiter char(1) = ','
)
returns table
as
return (select cast([Value] as uniqueidentifier) [Value] from string_split(@text, @delimiter) where 0 != len([Value]));
go

drop type if exists [dbo].[uniqueidentifier_set];
go
create type [dbo].[uniqueidentifier_set]
as table
(
    [Value] uniqueidentifier not null primary key
);
go

drop function if exists [dbo].[uniqueidentifier_split_distinct];
go
create function [dbo].[uniqueidentifier_split_distinct]
(
    @text varchar(max),
    @delimiter char(1) = ','
)
returns @result table ([Value] uniqueidentifier not null primary key)
as
begin
    insert @result
    select distinct cast([Value] as uniqueidentifier) [Value] from string_split(@text, @delimiter) where 0 != len([Value]);
    return;
end;
go

drop type if exists [dbo].[uniqueidentifier_list];
go
create type [dbo].[uniqueidentifier_list]
as table
(
    [Ordinal] int not null primary key,
    [Value] uniqueidentifier not null
);
go

drop function if exists [dbo].[uniqueidentifier_ordinalsplit];
go
create function [dbo].[uniqueidentifier_ordinalsplit]
(
    @text varchar(max),
    @delimiter char(1) = ','
)
returns @result table ([Ordinal] int not null identity(1, 1) primary key, [Value] uniqueidentifier not null)
as
begin
    insert @result ([Value])
    select
        cast([Value] as uniqueidentifier) [Value]
    from
        string_split(@text, @delimiter)
    where
        0 != len([Value])
    ;
    return;
end;
go
