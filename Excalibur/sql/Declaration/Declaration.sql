set nocount on;
go

/*
drop table if exists [Declaration].[Classification_Role];
drop table if exists [Declaration].[Classification_RelationshipType];
drop table if exists [Declaration].[Classification_Profile];

drop table if exists [Declaration].[ProfilePropertyStructureField];
drop table if exists [Declaration].[ProfileProperty];

drop table if exists [Declaration].[Profile];
drop table if exists [Declaration].[RelationshipType];
drop table if exists [Declaration].[Classification];

drop table if exists [Declaration].[Role];

drop table if exists [Declaration].[StructureField];
drop table if exists [Declaration].[Structure];

drop table if exists [Declaration].[EnumerationValue];
drop table if exists [Declaration].[Enumeration];

drop table if exists [Declaration].[DataType];

--drop schema if exists [Declaration];
*/

exec [dbo].[schema_ensure] 'Declaration';
go

create table [Declaration].[Classification]
(
    [parentId] int not null,
    constraint [FK [Declaration]].[Classification]]([parentId]])]
        foreign key ([parentId])
        references [Declaration].[Classification]([Id]),
    [id] int not null identity(0,1),
    constraint [PK [Declaration]].[Classification]]([Id]])]
        primary key ([Id]),
    [Name] nvarchar(128) not null,
    constraint [PK [Declaration]].[Classification]]([Name]])]
        unique ([Name]),
    [attributes] bigint not null,
    [Description] nvarchar(4000) null
);
insert [Declaration].[Classification] ([parentId], [Name], [attributes]) values (0, 'Undefined', 0);
go

create table [Declaration].[DataType]
(
    [id] int not null,
    constraint [PK [Declaration]].[DataType]]([Id]])]
        primary key ([Id]),
    [Name] nvarchar(128) not null,
    constraint [PK [Declaration]].[DataType]]([Name]])]
        unique ([Name]),
    [sqlType] nvarchar(128) not null,
    [clrType] nvarchar(128) not null,
    [attributes] bigint not null, -- system
	[length] smallint null,
	[precision] tinyint null,
	[scale] tinyint null,
    [Description] nvarchar(4000) null
);
insert [Declaration].[DataType] ([id], [Name], [sqlType], [clrType], [attributes]) values (0x00, 'Undefined', '', '', 0);
insert [Declaration].[DataType] ([id], [Name], [sqlType], [clrType], [attributes]) values (0x01, 'Structure', 'struct', 'struct', 0);
insert [Declaration].[DataType] ([id], [Name], [sqlType], [clrType], [attributes]) values (0x02, 'Boolean', 'bit', 'System.Boolean', 0);
insert [Declaration].[DataType] ([id], [Name], [sqlType], [clrType], [attributes]) values (0x03, 'Integer(8)', 'tinyint', 'System.SByte', 0);
insert [Declaration].[DataType] ([id], [Name], [sqlType], [clrType], [attributes]) values (0x04, 'Integer(16)', 'smallint', 'System.Int16', 0);
insert [Declaration].[DataType] ([id], [Name], [sqlType], [clrType], [attributes]) values (0x05, 'Integer(32)', 'tinyint', 'System.Int32', 0);
insert [Declaration].[DataType] ([id], [Name], [sqlType], [clrType], [attributes]) values (0x06, 'Integer(64)', 'bigint', 'System.Int64', 0);
insert [Declaration].[DataType] ([id], [Name], [sqlType], [clrType], [attributes]) values (0x07, 'Single', 'real', 'System.Single', 0);
insert [Declaration].[DataType] ([id], [Name], [sqlType], [clrType], [attributes]) values (0x08, 'Double', 'float', 'System.Double', 0);
insert [Declaration].[DataType] ([id], [Name], [sqlType], [clrType], [attributes]) values (0x09, 'Char', 'nchar', 'System.Char', 0);
insert [Declaration].[DataType] ([id], [Name], [sqlType], [clrType], [attributes], [length]) values (0x0A, 'String', 'nvarchar', 'System.String', 0, 128);
go

create table [Declaration].[Enumeration]
(
    [id] int not null identity(0,1),
    constraint [PK [Declaration]].[Enumeration]]([Id]])]
        primary key ([Id]),
    [Name] nvarchar(128) not null,
    constraint [PK [Declaration]].[Enumeration]]([Name]])]
        unique ([Name]),
    [dataTypeId] int not null,
    constraint [FK [Declaration]].[Enumeration]]([dataTypeId]])]
        foreign key ([dataTypeId])
        references [Declaration].[DataType]([Id]),
    [attributes] bigint not null, -- system
    [Description] nvarchar(4000) null
);
insert [Declaration].[Enumeration] ([Name], [dataTypeId], [attributes]) values ('Undefined', 0, 0);
go

create table [Declaration].[EnumerationValue]
(
    [enumerationId] int not null,
    constraint [FK [Declaration]].[EnumerationValue]]([enumerationId]])]
        foreign key ([enumerationId])
        references [Declaration].[Enumeration]([Id]),
    [id] int not null identity(1,1),
    constraint [PK [Declaration]].[EnumerationValue]]([Id]])]
        primary key ([Id]),
    [Value] sql_variant not null,
    [attributes] bigint not null, -- system
    [Description] nvarchar(4000) null
);
go

create table [Declaration].[Structure]
(
    [classificationId] int not null,
    constraint [FK [Declaration]].[Structure]]([classificationId]])]
        foreign key ([classificationId])
        references [Declaration].[Classification]([Id]),
    [id] int not null identity(0,1),
    constraint [PK [Declaration]].[Structure]]([Id]])]
        primary key ([Id]),
    [Name] nvarchar(128) not null,
    constraint [PK [Declaration]].[Structure]]([classificationId]], [Name]])]
        unique ([classificationId], [Name]),
    [attributes] bigint not null, -- system
    [Description] nvarchar(4000) null
);
insert [Declaration].[Structure] ([classificationId], [Name], [attributes]) values (0, 'Undefined', 0);
go

create table [Declaration].[StructureField]
(
    [structureId] int not null,
    constraint [FK [Declaration]].[StructureField]]([structureId]])]
        foreign key ([structureId])
        references [Declaration].[Structure]([Id]),
    [id] int not null identity(1,1),
    constraint [PK [Declaration]].[StructureField]]([Id]])]
        primary key ([Id]),
    [Name] nvarchar(128) not null,
    constraint [PK [Declaration]].[StructureField]]([Name]])]
        unique ([Name]),
    [attributes] bigint not null, -- systemable, unique
    [dataTypeId] int not null,
    constraint [FK [Declaration]].[StructureField]]([dataTypeId]])]
        foreign key ([dataTypeId])
        references [Declaration].[DataType]([Id]),
    [enumerationId] int not null,
    constraint [FK [Declaration]].[StructureField]]([enumerationId]])]
        foreign key ([enumerationId])
        references [Declaration].[Enumeration]([Id]),
    [maximumCount] tinyint not null,
    [Description] nvarchar(4000) null
);
go

create table [Declaration].[Profile]
(
    [classificationId] int not null,
    constraint [FK [Declaration]].[Profile]]([classificationId]])]
        foreign key ([classificationId])
        references [Declaration].[Classification]([Id]),
    [id] int not null identity(0,1),
    constraint [PK [Declaration]].[Profile]]([Id]])]
        primary key ([Id]),
    [Name] nvarchar(128) not null,
    constraint [PK [Declaration]].[Profile]]([classificationId]], [Name]])]
        unique ([classificationId], [Name]),
    [attributes] bigint not null, -- system, [single-entry, multi-entry-row, multientry-audit, multi-entry-timeseries]}
    [Description] nvarchar(4000) null
);
insert [Declaration].[Profile] ([classificationId], [Name], [attributes]) values (0, 'Undefined', 0);
go

create table [Declaration].[ProfileProperty]
(
    [profileId] int not null,
    [id] int not null identity(1,1),
    constraint [PK [Declaration]].[ProfileProperty]]([Id]])]
        primary key ([Id]),
    [Name] nvarchar(128) not null,
    constraint [PK [Declaration]].[ProfileProperty]]([Name]])]
        unique ([Name]),
    [attributes] bigint not null, -- systemable, unique
    [dataTypeId] int not null,
    constraint [FK [Declaration]].[ProfileProperty]]([dataTypeId]])]
        foreign key ([dataTypeId])
        references [Declaration].[DataType]([Id]),
    [enumerationId] int not null,
    constraint [FK [Declaration]].[ProfileProperty]]([enumerationId]])]
        foreign key ([enumerationId])
        references [Declaration].[Enumeration]([Id]),
    [structureId] int not null,
    constraint [FK [Declaration]].[ProfileProperty]]([structureId]])]
        foreign key ([structureId])
        references [Declaration].[Structure]([Id]),
    [maximumCount] int not null,
    [Description] nvarchar(4000) null
);
go

create table [Declaration].[ProfilePropertyStructureField]
(
    [id] int not null identity(1,1),
    constraint [PK [Declaration]].[ProfilePropertyStructureField]]([Id]])]
        primary key ([Id]),
    [profileId] int not null,
    constraint [FK [Declaration]].[ProfilePropertyStructureField]]([profileId]])]
        foreign key ([profileId])
        references [Declaration].[Profile]([Id]),
    [propertyId] int not null,
    constraint [FK [Declaration]].[ProfilePropertyStructureField]]([propertyId]])]
        foreign key ([propertyId])
        references [Declaration].[ProfileProperty]([Id]),
    [structureId] int not null
    constraint [FK [Declaration]].[ProfilePropertyStructureField]]([structureId]])]
        foreign key ([structureId])
        references [Declaration].[Structure]([Id]),
    [fieldId] int not null
    constraint [FK [Declaration]].[ProfilePropertyStructureField]]([fieldId]])]
        foreign key ([fieldId])
        references [Declaration].[StructureField]([Id])
);

create table [Declaration].[Classification_Profile]
(
    [classificationId] int not null,
    constraint [FK [Declaration]].[Classification_Profile]]([classificationId]])]
        foreign key ([classificationId])
        references [Declaration].[Classification]([Id]),
    [profileId] int not null,
    constraint [FK [Declaration]].[Classification_Profile]]([profileId]])]
        foreign key ([profileId])
        references [Declaration].[Profile]([Id]),
    [attributes] bigint not null -- systemable, unique
);
go

create table [Declaration].[Role]
(
    [id] int not null identity(0,1),
    constraint [PK [Declaration]].[Role]]([Id]])]
        primary key ([Id]),
    [SingularName] nvarchar(128) not null,
    constraint [PK [Declaration]].[Role]]([SingularName]])]
        unique ([SingularName]),
    [PluralName] nvarchar(128) not null,
    constraint [PK [Declaration]].[Role]]([PluralName]])]
        unique ([PluralName]),
    [attributes] bigint not null, -- system
    [Description] nvarchar(4000) null
);
insert [Declaration].[Role] ([SingularName], [PluralName], [Attributes]) values ('Undefined', 'Undefined', 0);
go

create table [Declaration].[Classification_Role]
(
    [classificationId] int not null,
    constraint [FK [Declaration]].[Classification_Role]]([classificationId]])]
        foreign key ([classificationId])
        references [Declaration].[Classification]([Id]),
    [roleId] int not null,
    constraint [FK [Declaration]].[Classification_Role]]([roleId]])]
        foreign key ([roleId])
        references [Declaration].[Role]([Id]),
    [SingularName] nvarchar(128) not null,
    constraint [PK [Declaration]].[Classification_Role]]([SingularName]])]
        unique ([SingularName]),
    [PluralName] nvarchar(128) not null,
    constraint [PK [Declaration]].[Classification_Role]]([PluralName]])]
        unique ([PluralName]),
    [attributes] bigint not null -- system
);
go

create table [Declaration].[RelationshipType]
(
    [id] int not null identity(1,1),
    constraint [PK [Declaration]].[RelationshipType]]([Id]])]
        primary key ([Id]),
    [leftRoleId] int not null,
    constraint [FK [Declaration]].[RelationshipType]]([leftRoleId]])]
        foreign key ([leftRoleId])
        references [Declaration].[Role]([Id]),
    [rightRoleId] int not null,
    constraint [FK [Declaration]].[RelationshipType]]([rightRoleId]])]
        foreign key ([rightRoleId])
        references [Declaration].[Role]([Id]),
    [LeftToRightPreposition] nvarchar(128) not null,
    [RightToLeftPreposition] nvarchar(128) not null,
    [attributes] bigint not null, -- system, parent-child, child-parent, peer-peer, one-one, one-many, many-one, many-many
	[classificationId] int not null,
    constraint [FK [Declaration]].[Relationship]]([classificationId]])]
        foreign key ([classificationId])
        references [Declaration].[Classification]([Id]),
);
go

create table [Declaration].[Classification_RelationshipType]
(
    [relationshipId] int not null,
    constraint [FK [Declaration]].[Classification_RelationshipType]]([relationshipId]])]
        foreign key ([relationshipId])
        references [Declaration].[RelationshipType]([Id]),
    [leftClassificationId] int not null,
    constraint [FK [Declaration]].[Classification_RelationshipType]]([leftClassificationId]])]
        foreign key ([leftClassificationId])
        references [Declaration].[Classification]([Id]),
    [leftRoleId] int not null,
    constraint [FK [Declaration]].[Classification_RelationshipType]]([leftRoleId]])]
        foreign key ([leftRoleId])
        references [Declaration].[Role]([Id]),
    [rightClassificationId] int not null,
    constraint [FK [Declaration]].[Classification_RelationshipType]]([rightClassificationId]])]
        foreign key ([rightClassificationId])
        references [Declaration].[Classification]([Id]),
    [rightRoleId] int not null,
    constraint [FK [Declaration]].[Classification_RelationshipType]]([rightRoleId]])]
        foreign key ([rightRoleId])
        references [Declaration].[Role]([Id]),
    [LeftToRightPreposition] nvarchar(128) null,
    [RightToLeftPreposition] nvarchar(128) null,
    [attributes] bigint not null, -- system
    [LeftToRightPrompt] nvarchar(1024) null,
    [RightToLeftPrompt] nvarchar(1024) null
);
go