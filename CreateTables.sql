USE [ProyectoBD]
GO

/****** Object:  Table [dbo].[Puesto]    Script Date: 4/5/2022 4:35:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MovimientoCredito](
	[ID] [int] NOT NULL,
	[Fecha] [date] NULL,
	[Monto] [money] NULL,
	[IdAsistencia] [int] NULL,
 CONSTRAINT [PK_MovimientoCredito] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Jornada](
	[ID] [int] NOT NULL,
	[TipoJornada] [int] NOT NULL,
	[IdAsistencias] [int] NOT NULL,
 CONSTRAINT [PK_Jornada] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TipoDocIdentidad](
	[ID] [int] NOT NULL,
	[NombreTip] [varchar](128) NOT NULL,
 CONSTRAINT [PK_TipoDocIdentidad] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Departamentos](
	[ID] [int] NOT NULL,
	[NombreDep] [varchar](128) NOT NULL,
 CONSTRAINT [PK_Departamentos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Puesto](
	[ID] [int] NOT NULL,
	[NombreP] [varchar](128) NOT NULL,
	[SalarioXHora] [money] NOT NULL,
	[Borrado] [bit] NOT NULL DEFAULT 1,
 CONSTRAINT [PK_Puesto] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
)ON [PRIMARY]
GO

CREATE TABLE [dbo].[Obrero](
	[ID] [int] IDENTITY(1,1)NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
	[IdTipoDocIdentidad] [int] NOT NULL,
	[ValorDocIdentidad] [int] NOT NULL,
	[IdPuesto] [int] NOT NULL,
	[FechaNacimiento] [date] NOT NULL,
	[IdDepartamento] [int] NOT NULL,
	[Borrado] [bit] NOT NULL DEFAULT 1,
	[IdJornada] [int] NOT NULL,
	[Username][varchar](128) NOT NULL,
	[Password][varchar](128) NOT NULL,
 CONSTRAINT [PK_Obrero] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Deducciones](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IdObrero] [int] NOT NULL,
	[IdTipoDeduccion] [int] NOT NULL,
	[Monto] [money] NOT NULL,
	[Fecha] [date] NULL,
 CONSTRAINT [PK_Deducciones] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Feriados](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
	[Fecha] [date] NOT NULL,
 CONSTRAINT [PK_Feriados] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[MarcasDeAsistencia](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ValorTipoDocu] [int] NOT NULL,
	[HoraEntrada] [time](7) NOT NULL,
	[HoraSalida] [time](7) NOT NULL,
 CONSTRAINT [PK_MarcasDeAsistencia] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Movimiento](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [date] NOT NULL,
	[Monto] [money] NOT NULL,
	[IdPlanilla] [int] NOT NULL,
	[TipoMovimiento] [int] NOT NULL,
 CONSTRAINT [PK_Movimiento] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PlanillaMes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FechaInicio] [date] NOT NULL,
	[FechaFinal] [date] NOT NULL,
	[SalarioNeto] [money] NOT NULL,
	[SalarioTotal] [money] NOT NULL,
	[TotalDeducciones] [int] NOT NULL,
 CONSTRAINT [PK_PlanillaMes] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PlanillaSemanaXEmpleado](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FechaInicio] [date] NOT NULL,
	[FechaFinal] [date] NOT NULL,
	[SalarioNeto] [money] NOT NULL,
	[TotalDeducciones] [int] NOT NULL,
	[SalarioBruto] [money] NOT NULL,
	[IdObrero] [int] NOT NULL,
	[IdPlanillaMes] [int] NOT NULL,
	[IdPlanillaSemana] [int] NOT NULL,
 CONSTRAINT [PK_PlanillaSemanaXEmpleado] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PlanillaSemana](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FechaInicio] [date] NOT NULL,
	[FechaFinal] [date] NOT NULL,
	[SalarioNeto] [money] NOT NULL,
	[TotalDeducciones] [int] NOT NULL,
 CONSTRAINT [PK_PlanillaSemana] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TipoDeduccion](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
	[Obligatorio] [varchar](128) NOT NULL,
	[Porcentual] [varchar](128) NOT NULL,
	[Valor] [decimal](5, 5) NOT NULL,
 CONSTRAINT [PK_TipoDeduccion] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[MovimientoDebito](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [date] NOT NULL,
	[Monto] [money] NOT NULL,
	[IdDeduccion] [int] NOT NULL,
 CONSTRAINT [PK_MovimientoDebito] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TipoJornada](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NombreJ] [varchar](128) NOT NULL,
	[HoraEntrada] [time](7) NOT NULL,
	[HoraSalida] [time](7) NOT NULL,
 CONSTRAINT [PK_TipoJornada] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TipoMovimiento](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
 CONSTRAINT [PK_TipoMovimiento] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Obrero]  WITH CHECK ADD  CONSTRAINT [FK_Obrero_Departamentos] FOREIGN KEY([IdDepartamento])
REFERENCES [dbo].[Departamentos] ([ID])
GO

ALTER TABLE [dbo].[Obrero] CHECK CONSTRAINT [FK_Obrero_Departamentos]
GO

ALTER TABLE [dbo].[Obrero]  WITH CHECK ADD  CONSTRAINT [FK_Obrero_TipoDocIdentidad] FOREIGN KEY([IdTipoDocIdentidad])
REFERENCES [dbo].[TipoDocIdentidad] ([ID])
GO

ALTER TABLE [dbo].[Obrero] CHECK CONSTRAINT [FK_Obrero_TipoDocIdentidad]
GO

ALTER TABLE [dbo].[Obrero]  WITH CHECK ADD  CONSTRAINT [FK_Obrero_Puesto] FOREIGN KEY([IdPuesto])
REFERENCES [dbo].[Puesto] ([ID])
GO

ALTER TABLE [dbo].[Obrero] CHECK CONSTRAINT [FK_Obrero_Puesto]
GO

ALTER TABLE [dbo].[Obrero]  WITH CHECK ADD  CONSTRAINT [FK_Obrero_Jornada] FOREIGN KEY([IdJornada])
REFERENCES [dbo].[Jornada] ([ID])
GO

ALTER TABLE [dbo].[Obrero] CHECK CONSTRAINT [FK_Obrero_Jornada]
GO

ALTER TABLE [dbo].[Deducciones]  WITH CHECK ADD  CONSTRAINT [FK_Deducciones_Obrero] FOREIGN KEY([IdObrero])
REFERENCES [dbo].[Obrero] ([ID])
GO

ALTER TABLE [dbo].[Deducciones] CHECK CONSTRAINT [FK_Deducciones_Obrero]
GO

ALTER TABLE [dbo].[Deducciones]  WITH CHECK ADD  CONSTRAINT [FK_Deducciones_TipoDeduccion] FOREIGN KEY([IdTipoDeduccion])
REFERENCES [dbo].[TipoDeduccion] ([ID])
GO

ALTER TABLE [dbo].[Deducciones] CHECK CONSTRAINT [FK_Deducciones_TipoDeduccion]
GO

ALTER TABLE [dbo].[Jornada]  WITH CHECK ADD  CONSTRAINT [FK_Jornada_MarcasDeAsistencia] FOREIGN KEY([IdAsistencias])
REFERENCES [dbo].[MarcasDeAsistencia] ([ID])
GO

ALTER TABLE [dbo].[Jornada] CHECK CONSTRAINT [FK_Jornada_MarcasDeAsistencia]
GO

ALTER TABLE [dbo].[Jornada]  WITH CHECK ADD  CONSTRAINT [FK_Jornada_TipoJornada] FOREIGN KEY([TipoJornada])
REFERENCES [dbo].[TipoJornada] ([ID])
GO

ALTER TABLE [dbo].[Jornada] CHECK CONSTRAINT [FK_Jornada_TipoJornada]
GO

ALTER TABLE [dbo].[Movimiento]  WITH CHECK ADD  CONSTRAINT [FK_Movimiento_PlanillaSemanaXEmpleado] FOREIGN KEY([IdPlanilla])
REFERENCES [dbo].[PlanillaSemanaXEmpleado] ([ID])
GO

ALTER TABLE [dbo].[Movimiento] CHECK CONSTRAINT [FK_Movimiento_PlanillaSemanaXEmpleado]
GO

ALTER TABLE [dbo].[Movimiento]  WITH CHECK ADD  CONSTRAINT [FK_Movimiento_TipoMovimiento] FOREIGN KEY([TipoMovimiento])
REFERENCES [dbo].[TipoMovimiento] ([ID])
GO

ALTER TABLE [dbo].[Movimiento] CHECK CONSTRAINT [FK_Movimiento_TipoMovimiento]
GO

ALTER TABLE [dbo].[MovimientoCredito]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoCredito_MarcasDeAsistencia] FOREIGN KEY([IdAsistencia])
REFERENCES [dbo].[MarcasDeAsistencia] ([ID])
GO

ALTER TABLE [dbo].[MovimientoCredito] CHECK CONSTRAINT [FK_MovimientoCredito_MarcasDeAsistencia]
GO

ALTER TABLE [dbo].[MovimientoDebito]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoDebito_Deducciones] FOREIGN KEY([IdDeduccion])
REFERENCES [dbo].[Deducciones] ([ID])
GO

ALTER TABLE [dbo].[MovimientoDebito] CHECK CONSTRAINT [FK_MovimientoDebito_Deducciones]
GO

ALTER TABLE [dbo].[PlanillaSemanaXEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_PlanillaSemanaXEmpleado_Obrero] FOREIGN KEY([IdObrero])
REFERENCES [dbo].[Obrero] ([ID])
GO

ALTER TABLE [dbo].[PlanillaSemanaXEmpleado] CHECK CONSTRAINT [FK_PlanillaSemanaXEmpleado_Obrero]
GO

ALTER TABLE [dbo].[PlanillaSemanaXEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_PlanillaSemanaXEmpleado_PlanillaMes] FOREIGN KEY([IdPlanillaMes])
REFERENCES [dbo].[PlanillaMes] ([ID])
GO

ALTER TABLE [dbo].[PlanillaSemanaXEmpleado] CHECK CONSTRAINT [FK_PlanillaSemanaXEmpleado_PlanillaMes]
GO

ALTER TABLE [dbo].[PlanillaSemanaXEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_PlanillaSemanaXEmpleado_PlanillaSemana] FOREIGN KEY([IdPlanillaSemana])
REFERENCES [dbo].[PlanillaSemana] ([ID])
GO

ALTER TABLE [dbo].[PlanillaSemanaXEmpleado] CHECK CONSTRAINT [FK_PlanillaSemanaXEmpleado_PlanillaSemana]
GO

