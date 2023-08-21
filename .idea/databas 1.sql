-- Drop bestaande tabellen als ze al bestaan
DROP TABLE IF EXISTS pool;
DROP TABLE IF EXISTS game;
DROP TABLE IF EXISTS team;

-- Maak de tabel "game" aan
CREATE TABLE game (
    gameid SERIAL PRIMARY KEY,
    round INT,
    gamedate DATE,
    team_home TEXT,
    team_out TEXT,
    goal_team1 INT DEFAULT 0,
    goal_team2 INT DEFAULT 0
);

-- Maak de tabel "team" aan
CREATE TABLE team (
    teamid SERIAL PRIMARY KEY,
    team_name TEXT,
    goals_scored INT DEFAULT 0,
    goals_conceded INT DEFAULT 0
);

-- Maak de tabel "pool" aan
CREATE TABLE pool (
    poolid SERIAL PRIMARY KEY,
    gameid INT,
    team_home_id INT,
    team_out_id INT,
    CONSTRAINT fk_gameid FOREIGN KEY (gameid) REFERENCES game (gameid),
    CONSTRAINT fk_team_home FOREIGN KEY (team_home_id) REFERENCES team (teamid),
    CONSTRAINT fk_team_out FOREIGN KEY (team_out_id) REFERENCES team (teamid)
);

-- Voeg gegevens toe aan de tabel "game"
INSERT INTO game (round, gamedate, team_home, team_out, goal_team1, goal_team2)
VALUES (1, '2012-12-12', 'fcpukkel', 'club dopje', 1, NULL);

-- Voeg gegevens toe aan de tabel "team"
INSERT INTO team (team_name)
VALUES ('fc pukkel'), ('club dopje');

-- Voeg gegevens toe aan de tabel "pool" met verwijzing naar bestaande game en teams
INSERT INTO pool (gameid, team_home_id, team_out_id)
VALUES ((SELECT gameid FROM game WHERE team_home = 'fc pukkel' AND team_out = 'club dopje'), 
        (SELECT teamid FROM team WHERE team_name = 'fc pukkel'),
        (SELECT teamid FROM team WHERE team_name = 'club dopje'));

-- Selecteer alle gegevens uit de tabel "game"
SELECT * FROM game;

-- Selecteer alle gegevens uit de tabel "team"
SELECT * FROM team;

-- Selecteer alle gegevens uit de tabel "pool" met JOIN tussen "game" en "pool"
SELECT g.*, p.*, th.team_name AS team_home_name, to_.team_name AS team_out_name
FROM game g
JOIN pool p ON g.gameid = p.gameid
JOIN team th ON p.team_home_id = th.teamid
JOIN team to_ ON p.team_out_id = to_.teamid;
