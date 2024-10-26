# Esports Data Analysis Using SQL
## Project Overview
Esports short for electronic sports, is a form of competition using video games. Esports often takes the form of organized, multiplayer video game competitions, particularly between professional players, played individually or as teams. This project includes CRUD operations and EDA Analysis. It analyzes the earnings of players and teams accross different regions, in different games and tournaments. 

**Level:** Beginner 
## Dataset

The data for this project is sourced from the Kaggle dataset:

 - **Dataset Link:** [esports_earnings](https://www.kaggle.com/datasets/jackdaoud/esports-earnings-for-players-teams-by-game)

## Objectives: 
1. **CRUD Operations:** Perform Create, Read, Update and Delete operations.
2. **EDA Analysis:** Analyzing the earnings of players and teams in esports, identify the market trends and geographical distribution of the talant and teams
   and identify which genres and games offer highest monetary rewards.

## CRUD Operations
- **Create:** Inserted sample records into the 'highest_earning_teams$' table.
- **Read:** Retrieved and displayed data from different tables.
- **Update:** Updated records in the 'highest_earning_players$' table.
- **Delete:** Deleted a record from 'highest_earning_players$' table.

**1. Create: Inserted sample records into the 'highest_earning_teams$' table.**

```sql
INSERT INTO [esports_db].[dbo].[highest_earning_teams$] 
	(TeamId,TeamName, TotalUSDPrize, TotalTournaments, GameId, Game, Genre)
VALUES
	('100', 'ZGDX', '100000','40','70', 'Fortnite', 'Battle Royale')
SELECT * FROM [esports_db].[dbo].[highest_earning_teams$];
```

**2. Update an Existing Player's data**

```sql
UPDATE [esports_db].[dbo].[highest_earning_players$] 
SET CurrentHandle = 'King'
WHERE PlayerId = '61896';
```

**3. Delete a Record from the [highest_earning_players$] Table.**

```sql
DELETE FROM [esports_db].[dbo].[highest_earning_players$]
WHERE PlayerId = '55138';
```

**4. Retrieve all teams from a country e.g, CN**

```sql
SELECT 
	* 
FROM [esports_db].[dbo].[highest_earning_players$]
WHERE CountryCode1 ='CN';
```

**5. COUNT the number of players that play DOTA 2**

```sql
SELECT
	Game,
	GameId,
	COUNT(PlayerId) AS Total_Players
FROM [esports_db].[dbo].[highest_earning_players$]
WHERE Game = 'Dota 2'
GROUP BY Game, GameId;
```

## Data Analysis and Findings
**1. Which top 10 teams are the most successful in terms of total earnings?**

```sql
SELECT TOP 10
    TeamName, 
    SUM(TotalUSDPrize) AS TotalEarnings 
FROM [esports_db].[dbo].[highest_earning_teams$] 
GROUP BY TeamName 
ORDER BY TotalEarnings DESC;
```

**Business Insight:** Identify the top-performing teams in esports based on their total earnings to understand who dominates the competitive scene.

**2. What are the top-paying games for teams?**

```sql
SELECT TOP 5
    Game, 
    AVG(TotalUSDPrize) AS AvgPrizeMoney, 
    COUNT(GameId) AS TotalTournaments 
FROM [esports_db].[dbo].[highest_earning_teams$] 
GROUP BY Game 
ORDER BY AvgPrizeMoney DESC;
```

**Business Insight:** Finding out which games have the highest payouts allows organizations to focus resources on those games for better returns on investment.

**3. Which teams have the largest percentage share of the total prize in their respective genres?**

```sql
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
```
**Business Insight:** Understanding from which genres teams get the highest percentage of their monetary rewards.

**4. Which continent and country has the highest representation in top esports competitions?**

```sql
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
```

**Business Insight:** Helps identify market trends and the geographical distribution of talent and teams.

**5. Which Top 10 players are earning the most in a specific game e.g., PUBG?**

```sql
SELECT TOP 10
    CONCAT(NameFirst,' ',NameLast) as Players, 
    Game, 
    SUM(TotalUSDPrize) AS TotalEarnings 
FROM [esports_db].[dbo].[highest_earning_players$] 
WHERE Game = 'PUBG' 
GROUP BY NameFirst, NameLast, Game 
ORDER BY TotalEarnings DESC;
```

**Business Insight:** Useful for evaluating which players are worth sponsorships or collaborations in certain games or genres.

**6. Which teams perform better in high-stakes tournaments versus low-stakes tournaments?**

```sql
SELECT 
    TeamName, 
    SUM(CASE WHEN TotalUSDPrize > 1000000 THEN 1 ELSE 0 END) AS HighStakesWins, 
    SUM(CASE WHEN TotalUSDPrize <= 1000000 THEN 1 ELSE 0 END) AS LowStakesWins 
FROM [esports_db].[dbo].[highest_earning_teams$] 
GROUP BY TeamName 
ORDER BY HighStakesWins DESC, LowStakesWins DESC;
```

**Business Insight:** Analyze how players/teams handle high-pressure environments (high-payout tournaments) versus smaller ones, giving insight into their resilience and performance consistency.

**7. What is the impact of tournament size on total prize money in each game?**

```sql
SELECT 
    Game,
    COUNT(TeamId) AS NumberOfTeams,
    SUM(TotalTournaments) AS TotalTournaments,
    SUM(TotalUSDPrize) AS TotalPrizeMoney,
    (SUM(TotalUSDPrize) / NULLIF(SUM(TotalTournaments), 0)) AS AvgPrizePerTournament
FROM [esports_db].[dbo].[highest_earning_teams$]
GROUP BY Game
ORDER BY TotalTournaments DESC;
```

**Business Insight:** Determine if larger tournaments yield significantly higher rewards.

## Findings

