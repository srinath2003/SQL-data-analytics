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










select * from matches ;
select * from deliveries ;

--10
SELECT COUNT(DISTINCT city) AS city_count
FROM matches;  -- Replace 'your_table_name' with the actual name of your table


--11
CREATE TABLE deliveries_v02 AS
SELECT *, 
       CASE 
           WHEN total_runs >= 4 THEN 'boundary'
           WHEN total_runs = 0 THEN 'dot'
           ELSE 'other'
       END AS ball_result
FROM deliveries;
select * from deliveries_v02 ;


--12
SELECT 
    ball_result,
    COUNT(*) AS count_of_balls
FROM deliveries_v02
WHERE ball_result IN ('boundary', 'dot')
GROUP BY ball_result;


--13

SELECT
    batting_team,
    COUNT(*) AS total_boundaries
FROM deliveries_v02
WHERE ball_result = 'boundary'
GROUP BY batting_team
ORDER BY total_boundaries DESC;


--14

SELECT
    bowling_team,
    COUNT(*) AS total_dot_balls
FROM deliveries_v02
WHERE ball_result = 'dot'
GROUP BY bowling_team
ORDER BY total_dot_balls DESC;

--15
SELECT
    dismissal_kind,
    COUNT(*) AS total_dismissals
FROM deliveries_v02
WHERE dismissal_kind IS NOT NULL AND dismissal_kind <> 'NA'
GROUP BY dismissal_kind
ORDER BY total_dismissals DESC;


--16
SELECT
    bowler,
    SUM(extra_runs) AS total_extra_runs
FROM deliveries
GROUP BY bowler
ORDER BY total_extra_runs DESC
LIMIT 5;


--17

CREATE TABLE deliveries_v03 AS
SELECT
    dv02.*,
    m.venue,
    m.date AS match_date
FROM deliveries_v02 dv02
JOIN matches m ON dv02.ids = m.ids;


select * from deliveries_v03;

--18
SELECT
    venue,
    SUM(total_runs) AS total_runs_scored
FROM deliveries_v03
GROUP BY venue
ORDER BY total_runs_scored DESC;


--19
SELECT
    EXTRACT(YEAR FROM match_date) AS year,
    SUM(total_runs) AS total_runs_scored
FROM deliveries_v03  -- Use the correct table name, assumed as deliveries_v03
WHERE venue = 'Eden Gardens'
GROUP BY year
ORDER BY total_runs_scored DESC, year DESC;


--20

CREATE TABLE matches_corrected AS
SELECT
    *,
    CASE WHEN team1 = 'Rising Pune Supergiants' THEN 'Rising Pune Supergiant' ELSE team1 END AS team1_corr,
    CASE WHEN team2 = 'Rising Pune Supergiants' THEN 'Rising Pune Supergiant' ELSE team2 END AS team2_corr
FROM matches;

-- Unique team1 names
SELECT DISTINCT team1_corr FROM matches_corrected;

-- Unique team2 names
SELECT DISTINCT team2_corr FROM matches_corrected;
select * from matches_corrected;




--21
CREATE TABLE deliveries_v04 AS
SELECT
    CONCAT(ids, '-', inning, '-', overs, '-', ball) AS ball_id,
    dv03.*
FROM deliveries_v03 dv03;
select * from deliveries_v04;


--22
-- Total count of rows
SELECT COUNT(*) AS total_rows FROM deliveries_v04;

-- Total count of distinct ball_id
SELECT COUNT(DISTINCT ball_id) AS distinct_ball_id_count FROM deliveries_v04;



--23
CREATE TABLE deliveries_v05 AS
SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY ball_id ORDER BY (SELECT NULL)) AS r_num
FROM deliveries_v04;

select * from deliveries_v05;


--24
SELECT *
FROM deliveries_v05
WHERE r_num > 1;

--25
SELECT *
FROM deliveries_v05
WHERE ball_id IN (SELECT ball_id FROM deliveries_v05 WHERE r_num > 1);








