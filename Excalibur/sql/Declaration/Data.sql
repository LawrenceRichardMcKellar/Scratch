set nocount on;
go

/*
drop table if exists [Data].[Relationship];
drop table if exists [Data].[Object_Classification];
drop table if exists [Data].[Object];
*/

exec [dbo].[schema_ensure] 'Data';
go
exec [dbo].[schema_ensure] 'Data-Profile';
go

create table [Data].[Object]
(
    [id] int not null identity(1,2),
    constraint [PK [Data]].[Object]]([Id]])]
        primary key ([Id]),
    [classificationId] int not null,
    constraint [FK [Declaration]].[Object]]([classificationId]])]
        foreign key ([classificationId])
        references [Declaration].[Classification]([Id]),
    [attributes] bigint not null,
    [DisplayName] nvarchar(1024) not null
);
go

create table [Data].[Object_Classification]
(
    [objectId] int not null,
    constraint [FK [Data]].[Object]]([objectId]])]
        foreign key ([objectId])
        references [Data].[Object]([Id]),
    [classificationId] int not null,
    constraint [FK [Declaration]].[Object_Classification]]([classificationId]])]
        foreign key ([classificationId])
        references [Declaration].[Classification]([Id]),
    [attributes] bigint not null
);
go

create table [Data].[Relationship]
(
    [id] int not null identity(2,2),
    constraint [PK [Data]].[Relationship]]([Id]])]
        primary key ([Id]),
	[typeId] int not null,
    constraint [FK [Declaration]].[Relationship]]([typeId]])]
        foreign key ([typeId])
        references [Declaration].[RelationshipType]([Id]),
    [leftObjectId] int not null,
    constraint [FK [Declaration]].[Relationship]]([leftObjectId]])]
        foreign key ([leftObjectId])
        references [Data].[Object]([Id]),
    [rightObjectId] int not null,
    constraint [FK [Declaration]].[Relationship]]([rightObjectId]])]
        foreign key ([rightObjectId])
        references [Data].[Object]([Id]),
	[objectId] int null,
    constraint [FK [Data]].[Relationship]]([objectId]])]
        foreign key ([objectId])
        references [Data].[Object]([Id]),
);

create unique index [Data]].[Relationship]]([typeId]], [leftObjectId]], [rightObjectId]])]
on [Data].[Relationship] ([typeId], [leftObjectId], [rightObjectId]) include ([id], [objectId]);

create unique index [Data]].[Relationship]]([typeId]], [rightObjectId]], [leftObjectId]])]
on [Data].[Relationship] ([typeId], [rightObjectId], [leftObjectId]) include ([id], [objectId]);

create unique index [Data]].[Relationship]]([objectId]])]
on [Data].[Relationship] ([objectId]) include ([id], [typeId], [rightObjectId], [leftObjectId]);
go

--create table [Data].[ProfileName]
--(
--    [objectId] int not null,
--    [propertyName_fieldName] [sqlType] [null|not null],
--    ...
--);

--create table [Data].[ProfileName_PropertyName_FieldName|{guid}]
--(
--    [objectId] int not null,
--    [ordinal] int not null,
--    [Value] [sqlType] not null
--);