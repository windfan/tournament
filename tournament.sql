-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.


CREATE TABLE players (	id SERIAL primary key, 
						name TEXT);

CREATE TABLE matches ( 	id SERIAL REFERENCES players(id),
						result VARCHAR(4));

CREATE VIEW winCounter AS 
	SELECT matches.id as id, COUNT(*) as winCount
	FROM matches
	WHERE matches.result = 'Win'
	GROUP BY matches.id
	ORDER BY winCount DESC;

CREATE VIEW matchCounter AS 
	SELECT matches.id as id, COUNT(*) as matchCount
	FROM matches
	GROUP BY matches.id
	ORDER BY matchCount DESC;

CREATE VIEW matchWinCounter AS
	SELECT matchCounter.id, COUNT(matchCounter.matchCount) as matchCount, COUNT(winCounter.winCount) as winCount
	FROM matchCounter LEFT JOIN winCounter
	ON matchCounter.id = winCounter.id
	GROUP BY matchCounter.id
	ORDER BY winCount;

CREATE VIEW standings AS
	SELECT players.id, players.name, coalesce(matchWinCounter.winCount, 0) as wins, coalesce(matchWinCounter.matchCount, 0) AS matches
    FROM players LEFT JOIN matchWinCounter
    ON players.id = matchWinCounter.id
    ORDER BY wins DESC;