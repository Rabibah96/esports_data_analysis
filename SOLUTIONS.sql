


--CRUD Opertaions
--1.Create: Inserted sample records into the 'highest_earning_teams$' table.
INSERT INTO [esports_db].[dbo].[highest_earning_teams$] 
	(TeamId,TeamName, TotalUSDPrize, TotalTournaments, GameId, Game, Genre)
VALUES
	('100', 'ZGDX', '100000','40','70', 'Fortnite', 'Battle Royale')
SELECT * FROM [esports_db].[dbo].[highest_earning_teams$] 

--2. Update an Existing Player's data
UPDATE [esports_db].[dbo].[highest_earning_players$] 
SET CurrentHandle = 'King'
WHERE PlayerId = '61896'

--3: Delete a Record from the [highest_earning_players$] Table.
DELETE FROM [esports_db].[dbo].[highest_earning_players$]
WHERE PlayerId = '55138'

--4: Retrieve All teams from a country

SELECT 
	* 
FROM [esports_db].[dbo].[highest_earning_players$]
WHERE CountryCode1 ='CN'

--5. COUNT  the number of players that plays DOTA 2
SELECT
	Game,
	GameId,
	COUNT(PlayerId) AS Total_Players
FROM [esports_db].[dbo].[highest_earning_players$]
WHERE Game = 'Dota 2'
GROUP BY Game, GameId

--EDA ANALYSIS 
--1. Which teams are the most successful in terms of total earnings?
--Business Insight: Identify the top-performing teams in esports based on their total earnings to understand who dominates the competitive scene.
SELECT TOP 10
    TeamName, 
    SUM(TotalUSDPrize) AS TotalEarnings 
FROM [esports_db].[dbo].[highest_earning_teams$] 
GROUP BY TeamName 
ORDER BY TotalEarnings DESC;

--2. What are the top-paying games for both teams and players?
--Business Insight: Finding out which games have the highest payouts allows organizations to focus resources on those games for better returns on investment.
SELECT TOP 5
    Game, 
    AVG(TotalUSDPrize) AS AvgPrizeMoney, 
    COUNT(GameId) AS TotalTournaments 
FROM [esports_db].[dbo].[highest_earning_teams$] 
GROUP BY Game 
ORDER BY AvgPrizeMoney DESC;

--3.Which teams have the largest percentage share of the total prize in their respective genres?
 
WITH GenreTotal AS (
    SELECT 
        Genre,
        SUM(TotalUSDPrize) AS TotalGenrePrize
    FROM [esports_db].[dbo].[highest_earning_teams$]
    GROUP BY Genre
),
TeamGenreShare AS (
    SELECT 
        TeamName,
        t.Genre,
        SUM(TotalUSDPrize) AS TeamGenrePrize,
        ROUND((SUM(TotalUSDPrize) / NULLIF(gt.TotalGenrePrize, 0)) * 100,2) AS PrizeShare
    FROM [esports_db].[dbo].[highest_earning_teams$] AS t
    JOIN GenreTotal gt ON t.Genre = gt.Genre
    GROUP BY TeamName, t.Genre, gt.TotalGenrePrize
)
SELECT TOP 5 
* 
FROM TeamGenreShare
ORDER BY PrizeShare DESC;


--4. Which continent and country has the highest representation in top esports competitions?

SELECT 
    c.Continent_Name, 
	c.Country_Name,
    COUNT(DISTINCT p.PlayerId) AS TotalPlayers,
	SUM(p.TotalUSDPrize) AS TotalUSDPrize
FROM [esports_db].[dbo].[highest_earning_players$] p
JOIN [esports_db].[dbo].['country-and-continent-codes-lis$'] c 
ON p.CountryCode1 = c.Two_Letter_Country_Code 
GROUP BY c.Continent_Name, c.Country_Name
ORDER BY TotalPlayers, TotalUSDPrize DESC;

--5. Which individual players are earning the most in a specific game e.g., PUBG?

SELECT TOP 10
    CONCAT(NameFirst,' ',NameLast) as Players, 
    Game, 
    SUM(TotalUSDPrize) AS TotalEarnings 
FROM [esports_db].[dbo].[highest_earning_players$] 
WHERE Game = 'PUBG' 
GROUP BY NameFirst, NameLast, Game 
ORDER BY TotalEarnings DESC;

--6. Which teams perform better in high-stakes tournaments versus low-stakes tournaments?

SELECT 
    TeamName, 
    SUM(CASE WHEN TotalUSDPrize > 1000000 THEN 1 ELSE 0 END) AS HighStakesWins, 
    SUM(CASE WHEN TotalUSDPrize <= 1000000 THEN 1 ELSE 0 END) AS LowStakesWins 
FROM [esports_db].[dbo].[highest_earning_teams$] 
GROUP BY TeamName 
ORDER BY HighStakesWins DESC, LowStakesWins DESC;

--7. What is the impact of tournament size on total prize money in each game?

SELECT 
    Game,
    COUNT(TeamId) AS NumberOfTeams,
    SUM(TotalTournaments) AS TotalTournaments,
    SUM(TotalUSDPrize) AS TotalPrizeMoney,
    (SUM(TotalUSDPrize) / NULLIF(SUM(TotalTournaments), 0)) AS AvgPrizePerTournament
FROM [esports_db].[dbo].[highest_earning_teams$]
GROUP BY Game
ORDER BY TotalTournaments DESC;
;












