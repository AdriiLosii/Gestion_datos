-- phpMyAdmin SQL Dump
-- version 5.1.3
-- https://www.phpmyadmin.net/
--
-- Servidor: mysql
-- Tiempo de generación: 05-05-2024 a las 18:59:55
-- Versión del servidor: 5.7.28
-- Versión de PHP: 8.0.15

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `agencia_viajes`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ACTIVIDAD`
--

CREATE TABLE `ACTIVIDAD` (
  `id` int(11) NOT NULL,
  `duracion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `precio` decimal(10,2) NOT NULL,
  `idViaje` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `ACTIVIDAD`
--

INSERT INTO `ACTIVIDAD` (`id`, `duracion`, `precio`, `idViaje`) VALUES
(1, '2024-06-16 14:00:00', '50.00', 1),
(2, '2024-07-21 09:00:00', '30.00', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `CLIENTE`
--

CREATE TABLE `CLIENTE` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `edad` int(11) NOT NULL,
  `genero` enum('Masculino','Femenino','Otro') NOT NULL,
  `idSeguro` int(11) NOT NULL,
  `idViaje` int(11) NOT NULL,
  `fecha` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `CLIENTE`
--

INSERT INTO `CLIENTE` (`id`, `nombre`, `edad`, `genero`, `idSeguro`, `idViaje`, `fecha`) VALUES
(1, 'Juan', 30, 'Masculino', 1, 1, '2024-05-01'),
(2, 'María', 25, 'Femenino', 2, 2, '2024-05-02');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `DESTINO`
--

CREATE TABLE `DESTINO` (
  `id` int(11) NOT NULL,
  `pais` varchar(20) NOT NULL,
  `alojamiento` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `DESTINO`
--

INSERT INTO `DESTINO` (`id`, `pais`, `alojamiento`) VALUES
(1, 'España', 'Hotel Playa'),
(2, 'Italia', 'Apartamento Roma'),
(3, 'Francia', 'Cabaña Montaña');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `GUIA`
--

CREATE TABLE `GUIA` (
  `idActividad` int(11) NOT NULL,
  `genero` enum('Masculino','Femenino','Otro') NOT NULL,
  `edad` int(2) NOT NULL,
  `nombre` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `GUIA`
--

INSERT INTO `GUIA` (`idActividad`, `genero`, `edad`, `nombre`) VALUES
(1, 'Masculino', 35, 'Pedro'),
(2, 'Femenino', 28, 'Ana');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `INCLUYE`
--

CREATE TABLE `INCLUYE` (
  `idPaquete` int(11) NOT NULL,
  `idDestino` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `INCLUYE`
--

INSERT INTO `INCLUYE` (`idPaquete`, `idDestino`) VALUES
(1, 1),
(2, 1),
(1, 2),
(2, 2),
(1, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `INTERNACIONAL`
--

CREATE TABLE `INTERNACIONAL` (
  `idViaje` int(11) NOT NULL,
  `pasaporte` varchar(15) NOT NULL,
  `visado` enum('Vigente','Vencido','En trámite','No requerido') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `INTERNACIONAL`
--

INSERT INTO `INTERNACIONAL` (`idViaje`, `pasaporte`, `visado`) VALUES
(1, 'ABC123', 'Vigente'),
(2, 'XYZ789', 'En trámite');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `NACIONAL`
--

CREATE TABLE `NACIONAL` (
  `idViaje` int(11) NOT NULL,
  `dni` varchar(9) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `NACIONAL`
--

INSERT INTO `NACIONAL` (`idViaje`, `dni`) VALUES
(1, '12345678A'),
(2, '87654321B');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `PAQUETE_VACACIONAL`
--

CREATE TABLE `PAQUETE_VACACIONAL` (
  `id` int(11) NOT NULL,
  `n_destinos` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `PAQUETE_VACACIONAL`
--

INSERT INTO `PAQUETE_VACACIONAL` (`id`, `n_destinos`) VALUES
(1, 3),
(2, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `RECOMIENDA`
--

CREATE TABLE `RECOMIENDA` (
  `idCliente` int(11) NOT NULL,
  `idRecomendado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `RECOMIENDA`
--

INSERT INTO `RECOMIENDA` (`idCliente`, `idRecomendado`) VALUES
(2, 1),
(1, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `SEGURO_VIAJE`
--

CREATE TABLE `SEGURO_VIAJE` (
  `id` int(11) NOT NULL,
  `caducidad` date NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `cancelacion` tinyint(1) NOT NULL,
  `tipo` enum('Básico','A todo riesgo') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `SEGURO_VIAJE`
--

INSERT INTO `SEGURO_VIAJE` (`id`, `caducidad`, `precio`, `cancelacion`, `tipo`) VALUES
(1, '2024-12-31', '100.00', 1, 'Básico'),
(2, '2024-12-31', '200.00', 0, 'A todo riesgo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `VIAJE`
--

CREATE TABLE `VIAJE` (
  `id` int(11) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `duracion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `transporte` enum('Coche','Tren','Barco','Avión','Otro') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `VIAJE`
--

INSERT INTO `VIAJE` (`id`, `precio`, `duracion`, `transporte`) VALUES
(1, '500.00', '2024-06-15 10:00:00', 'Avión'),
(2, '300.00', '2024-07-20 08:00:00', 'Tren');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `ACTIVIDAD`
--
ALTER TABLE `ACTIVIDAD`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idViaje` (`idViaje`);

--
-- Indices de la tabla `CLIENTE`
--
ALTER TABLE `CLIENTE`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idSeguro` (`idSeguro`),
  ADD KEY `idViaje` (`idViaje`);

--
-- Indices de la tabla `DESTINO`
--
ALTER TABLE `DESTINO`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `GUIA`
--
ALTER TABLE `GUIA`
  ADD PRIMARY KEY (`idActividad`);

--
-- Indices de la tabla `INCLUYE`
--
ALTER TABLE `INCLUYE`
  ADD PRIMARY KEY (`idPaquete`,`idDestino`),
  ADD KEY `idDestino` (`idDestino`);

--
-- Indices de la tabla `INTERNACIONAL`
--
ALTER TABLE `INTERNACIONAL`
  ADD PRIMARY KEY (`idViaje`);

--
-- Indices de la tabla `NACIONAL`
--
ALTER TABLE `NACIONAL`
  ADD PRIMARY KEY (`idViaje`);

--
-- Indices de la tabla `PAQUETE_VACACIONAL`
--
ALTER TABLE `PAQUETE_VACACIONAL`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `RECOMIENDA`
--
ALTER TABLE `RECOMIENDA`
  ADD PRIMARY KEY (`idCliente`,`idRecomendado`),
  ADD KEY `idRecomendado` (`idRecomendado`);

--
-- Indices de la tabla `SEGURO_VIAJE`
--
ALTER TABLE `SEGURO_VIAJE`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `VIAJE`
--
ALTER TABLE `VIAJE`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `ACTIVIDAD`
--
ALTER TABLE `ACTIVIDAD`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `CLIENTE`
--
ALTER TABLE `CLIENTE`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `DESTINO`
--
ALTER TABLE `DESTINO`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `INTERNACIONAL`
--
ALTER TABLE `INTERNACIONAL`
  MODIFY `idViaje` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `NACIONAL`
--
ALTER TABLE `NACIONAL`
  MODIFY `idViaje` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `PAQUETE_VACACIONAL`
--
ALTER TABLE `PAQUETE_VACACIONAL`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `SEGURO_VIAJE`
--
ALTER TABLE `SEGURO_VIAJE`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `VIAJE`
--
ALTER TABLE `VIAJE`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `ACTIVIDAD`
--
ALTER TABLE `ACTIVIDAD`
  ADD CONSTRAINT `ACTIVIDAD_ibfk_1` FOREIGN KEY (`idViaje`) REFERENCES `VIAJE` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `CLIENTE`
--
ALTER TABLE `CLIENTE`
  ADD CONSTRAINT `CLIENTE_ibfk_1` FOREIGN KEY (`idSeguro`) REFERENCES `SEGURO_VIAJE` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `CLIENTE_ibfk_2` FOREIGN KEY (`idViaje`) REFERENCES `VIAJE` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `GUIA`
--
ALTER TABLE `GUIA`
  ADD CONSTRAINT `GUIA_ibfk_1` FOREIGN KEY (`idActividad`) REFERENCES `ACTIVIDAD` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `INCLUYE`
--
ALTER TABLE `INCLUYE`
  ADD CONSTRAINT `INCLUYE_ibfk_1` FOREIGN KEY (`idPaquete`) REFERENCES `PAQUETE_VACACIONAL` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `INCLUYE_ibfk_2` FOREIGN KEY (`idDestino`) REFERENCES `DESTINO` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `INTERNACIONAL`
--
ALTER TABLE `INTERNACIONAL`
  ADD CONSTRAINT `INTERNACIONAL_ibfk_1` FOREIGN KEY (`idViaje`) REFERENCES `VIAJE` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `NACIONAL`
--
ALTER TABLE `NACIONAL`
  ADD CONSTRAINT `NACIONAL_ibfk_1` FOREIGN KEY (`idViaje`) REFERENCES `VIAJE` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `RECOMIENDA`
--
ALTER TABLE `RECOMIENDA`
  ADD CONSTRAINT `RECOMIENDA_ibfk_1` FOREIGN KEY (`idCliente`) REFERENCES `CLIENTE` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `RECOMIENDA_ibfk_2` FOREIGN KEY (`idRecomendado`) REFERENCES `CLIENTE` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
