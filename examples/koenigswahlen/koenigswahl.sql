SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `koenigswahl_kandidaten`
-- ----------------------------
DROP TABLE IF EXISTS `koenigswahl_kandidaten`;
CREATE TABLE `koenigswahl_kandidaten` (
  `candidate_id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) DEFAULT NULL,
  `votes` int(11) DEFAULT '0',
  `empire` int(11) DEFAULT NULL,
  `candidate_date` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`candidate_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of koenigswahl_kandidaten
-- ----------------------------

-- ----------------------------
-- Table structure for `koenigswahl_votes`
-- ----------------------------
DROP TABLE IF EXISTS `koenigswahl_votes`;
CREATE TABLE `koenigswahl_votes` (
  `vote_id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) DEFAULT NULL,
  `vote_for_pid` int(11) DEFAULT NULL,
  `vote_date` varchar(50) DEFAULT NULL,
  `empire` int(2) DEFAULT NULL,
  PRIMARY KEY (`vote_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of koenigswahl_votes
-- ----------------------------

-- ----------------------------
-- Table structure for `koenig_derzeitig`
-- ----------------------------
DROP TABLE IF EXISTS `koenig_derzeitig`;
CREATE TABLE `koenig_derzeitig` (
  `monarch_id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) DEFAULT NULL,
  `empire` int(2) DEFAULT NULL,
  `vote_date` varchar(50) DEFAULT NULL,
  `votes` int(11) DEFAULT NULL,
  PRIMARY KEY (`monarch_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of koenig_derzeitig
-- ----------------------------
