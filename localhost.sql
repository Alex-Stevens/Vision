-- phpMyAdmin SQL Dump
-- version 3.3.8.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Apr 28, 2011 at 11:05 AM
-- Server version: 5.1.30
-- PHP Version: 5.2.16

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `visiondb14`
--
CREATE DATABASE `visiondb14` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `visiondb14`;

-- --------------------------------------------------------

--
-- Table structure for table `basketitem`
--

CREATE TABLE IF NOT EXISTS `basketitem` (
  `TransactionID` int(5) NOT NULL,
  `ProductID` int(5) NOT NULL,
  `QuantitySold` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `basketitem`
--

INSERT INTO `basketitem` (`TransactionID`, `ProductID`, `QuantitySold`) VALUES
(1, 1, 2),
(1, 3, 1),
(2, 10, 3),
(3, 7, 1);

-- --------------------------------------------------------

--
-- Table structure for table `productdetails`
--

CREATE TABLE IF NOT EXISTS `productdetails` (
  `ProductID` int(5) NOT NULL AUTO_INCREMENT,
  `ProductName` varchar(100) NOT NULL,
  `Brand` varchar(50) NOT NULL,
  `Range` varchar(50) NOT NULL,
  `Supplier` varchar(50) NOT NULL,
  `RestockDate` date NOT NULL,
  `SalePrice` float NOT NULL,
  `PurchaseCost` float NOT NULL,
  `Category` varchar(25) NOT NULL,
  `ProductQuantity` int(25) NOT NULL,
  `Information` varchar(500) NOT NULL,
  `Image` varchar(500) NOT NULL,
  PRIMARY KEY (`ProductID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=18 ;

--
-- Dumping data for table `productdetails`
--

INSERT INTO `productdetails` (`ProductID`, `ProductName`, `Brand`, `Range`, `Supplier`, `RestockDate`, `SalePrice`, `PurchaseCost`, `Category`, `ProductQuantity`, `Information`, `Image`) VALUES
(1, 'Scooter', 'Bobby`s Scooters', 'Ultra Xtreme', 'HTI', '2011-03-31', 24.99, 14.75, 'Outdoor', 2, 'Red and blue scooter. Large.', 'images/database/Scooter.jpg'),
(3, 'Wooden Blocks', 'Plan Toys', 'Simple', 'HTI', '2011-03-31', 9.99, 5.45, 'Traditional', 5, 'Simple wooden blocks intended for stacking', 'images/database/WoodenBlocks.jpg'),
(5, 'Starter Wooden Train Set', 'John Crane', 'None', 'Mulberry Bush', '2011-10-31', 27.99, 14.75, 'Wooden Trains', 2, 'Wooden 50 piece set. Ideal first train set. Made and screen printed with 17 interlocking tracks, including popular bridge, engine, 3 carriages, 5 people, 4 buildings, plus even more -animals, trees and traffic signs!', 'images/database/Starter Wooden Train Set.jpeg'),
(6, 'Vintage Pedal Car Yellow', 'None', 'None', 'Great Gizmos', '2011-05-31', 124.99, 75.45, 'Push and Ride', 0, 'Real metal pedal car called Harry from a byegone age. Suitable for any young girl or boy in yellow. Made in strong steel with vintage styling, chrome grille and a crank handle! Partially assembled - some assembly of wheels and fittings is required.', 'images/database/Vintage Pedal Car Yellow.jpeg'),
(7, 'Alarm Clock Cow', 'None', 'Room Mates', 'Mulberry Bush', '2011-03-31', 14.99, 9.75, 'Alarm Clocks', 8, 'Wake up to the sound of mooing cows and pretend you''re in the country with novel retro-style alarm clock and never be late for school or work again! With large easy to read face, robust metal body and 3 x AAA batteries included. Age 3 - Adult.', 'images/database/Alarm Clock Cows.jpeg'),
(8, 'Baby Stella', 'None', 'Dolls', 'Manhattan Toy', '2011-04-30', 19.99, 7.85, 'Toys for Younger Children', 8, 'She has a removable pink velour dress and nappy, with a dummy that attaches magnetically to her mouth. Toddlers will love caring for their very own baby! Ht 38 cms. Age 18 months +', 'images/database/Baby Stella.jpeg'),
(9, 'Bathtub Shapes My Farm', 'None', 'None', 'Great Gizmos', '2011-05-31', 7.99, 3.75, 'Pocket Money Toys', 0, 'Great imaginative fun for boys and girls. Set contains approx 12 foam pieces with pictures of farm animals, vehicles etc. stored in a mesh bag, which can itself attach to the bath with 2 suction cups.', 'images/database/Bathtub Shapes My Farm.jpeg'),
(10, 'Battery Engine Red / Yellow', 'None', 'None', 'HTI', '2011-05-31', 7.99, 3.5, 'Wooden Trains', 40, 'Battery powered engine. Length 8.5 cms. Requires 1 x AAA battery (not included). Age 3+ (Fully compatible with all leading brands). (Design is slightly different to original image and will be either red or yellow in colour)', 'images/database/Battery Engine.jpeg'),
(11, 'Hello Kitty 28cm Soft Toy', 'Hello Kitty', 'None', 'Back of a van', '2011-07-31', 9.99, 4.95, 'Soft Toys', 0, 'Hello Kitty fans will love this large Hello Kitty Soft Toy! Colourful and soft.', 'images/database/Hello Kitty 28cm Soft Toy.jpg'),
(12, 'My First Hello Kitty Kitchen', 'Hello Kitty', 'None', 'Back of a van', '2011-07-27', 24.99, 17.85, 'Role Play', 0, 'Children will love this pretty pink My First Hello Kitty kitchen, decorated with your favourite Hello Kitty designs! In pink and purple, it features a cooker, sink, hob, lots of storage and an oven door that can be opened and closed. With 15 play accessories, this is ideal for any Hello Kitty fan!', 'images/database/My First Hello Kitty Kitchen.jpg'),
(13, 'Hello Kitty Cosmetic Vanity Case', 'Hello Kitty', 'None', 'Back of a van', '2011-11-30', 19.99, 11.45, 'Role Play', 0, 'Make yourself gorgeous with this great Hello Kitty Vanity Case. This modern designed vanity case comes packed with an array of make up and accessories and features a light up function. A must have for any Hello Kitty fan.', 'images/database/Hello Kitty Cosmetic Vanity Case.jpg'),
(14, 'Peppa Pig 35 Piece Jigsaw Puzzle', 'Peppa Pig', 'None', 'Puzzle Go!', '2011-09-23', 5.99, 2.75, 'Jigsaws & Puzzles', 4, 'Peppa Pig fans will love this 35 piece puzzle of Peppa. The Peppa Pig jigsaw is bright, colourful and features everyone’s favourite pig which will help young children learning how to develop their problem solving skills.', 'images/database/Peppa Pig 35 Piece Jigsaw Puzzle.jpg'),
(15, 'Peppa Pig Trio Puzzle', 'Peppa Pig', 'None', 'Puzzle Go!', '2011-05-25', 6.99, 2.75, 'Jigsaws & Puzzles', 10, 'Set of 3 Peppa Pig jigsaw puzzles with 6, 9 and 12 pieces. Great puzzle fun featuring all your favourite Peppa Pig characters! Piece together fun pictures of Peppa with her family and friends.', 'images/database/Peppa Pig Trio Puzzle.jpg'),
(16, 'Nerf N Strike Barrel Break Blaster', 'Nerf', 'N Strike', 'HTI', '2011-04-30', 24.99, 13.95, 'Outdoor & Sports', 19, 'Any Nerf N-Strike Officer knows that he needs to be ready for quick, close-range work at a moment''s notice! With the ability to fire one or both barrels at the same time, the Barrel Break IX-2 is the perfect blaster for clearing out the last few targets! Features 2 Blasting Modes: Fire one dart, or blast both barrels at once!', 'images/database/Nerf N Strike Barrel Break Blaster.jpg'),
(17, 'Nerf N Strike Raider Rapid Fire CS-35 Blaster', 'Nerf', 'N Strike', 'HTI', '2011-04-28', 29.97, 20.1, 'Outdoor & Sports', 10, 'Have great adventure fun with this Nerf N Strike Raider Rapid Fire CS-35 blaster and its special drum magazine! Drum holds a total of 35 darts and features a clear window so you can see when you need to reload.    Pump action handle lets you control your rate of fire and choose between blasting mode or multi-shot. This Rapid Fire CS-35 is defiantly the ultimate choice for any battle.', 'images/database/Nerf N Strike Raider Rapid Fire CS-35 Blaster.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `transactiondetails`
--

CREATE TABLE IF NOT EXISTS `transactiondetails` (
  `TransactionID` int(5) NOT NULL,
  `SaleTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Total` float NOT NULL,
  `AmountGiven` float NOT NULL,
  `ChangeDue` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `transactiondetails`
--

INSERT INTO `transactiondetails` (`TransactionID`, `SaleTime`, `Total`, `AmountGiven`, `ChangeDue`) VALUES
(1, '2011-04-27 19:31:30', 59.97, 60, 0.03),
(2, '2011-04-27 19:32:20', 23.97, 25, 1.03),
(3, '2011-04-27 19:32:54', 14.99, 20, 5.01);
