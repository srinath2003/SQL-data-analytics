-- Create table
CREATE TABLE cricket_data (
    ids INT,
    inning INT,
    overs INT,
    ball INT,
    batsman VARCHAR(255),
    non_striker VARCHAR(255),
    bowler VARCHAR(255),
    batsman_runs INT,
    extra_runs INT,
    total_runs INT,
    is_wicket INT,
    dismissal_kind VARCHAR(255),
    player_dismissed VARCHAR(255),
    fielder VARCHAR(255),
    extras_type VARCHAR(255),
    batting_team VARCHAR(255),
    bowling_team VARCHAR(255)
);

-- Import data from CSV
COPY cricket_data FROM 'C:\Program Files\PostgreSQL\12\data\IPL_Ball.csv' DELIMITER ',' CSV HEADER;

select * from cricket_data ;


CREATE TABLE cricket_matches (
    ids INT,
    city VARCHAR(255),
    date VARCHAR(10),
    player_of_match VARCHAR(255),
    venue VARCHAR(255),
    neutral_venue INT,
    team1 VARCHAR(255),
    team2 VARCHAR(255),
    toss_winner VARCHAR(255),
    toss_decision VARCHAR(10),
    winner VARCHAR(255),
    results VARCHAR(20),
    result_margin INT,
    eliminator VARCHAR(255),
    methods VARCHAR(3),
    umpire1 VARCHAR(255),
    umpire2 VARCHAR(255)
);
COPY cricket_matches FROM 'C:\Program Files\PostgreSQL\12\data\IPL_matches.csv' DELIMITER ',' CSV HEADER;


ALTER TABLE cricket_matches RENAME TO matches;

ALTER TABLE cricket_data RENAME TO deliveries;


SELECT *
FROM deliveries
ORDER BY ids, inning, overs, ball
LIMIT 20;

SELECT *
FROM matches
LIMIT 20;


SELECT *
FROM matches
WHERE date = '2013-05-02';





UPDATE matches
SET date = TO_DATE(date, 'DD-MM-YYYY') WHERE date ~ '\d{2}-\d{2}-\d{4}';
UPDATE matches
SET date = TO_DATE(date, 'DD/MM/YYYY') WHERE date ~ '\d{1,2}/\d{1,2}/\d{4}';

ALTER TABLE matches
ALTER COLUMN date TYPE DATE USING date::DATE;

--7
SELECT *
FROM matches
WHERE date = '2013-05-02';

--8
SELECT *
FROM matches
WHERE results = 'runs' AND result_margin > 100;

--9
SELECT *
FROM matches
WHERE results = 'tie' 
ORDER BY date DESC;







