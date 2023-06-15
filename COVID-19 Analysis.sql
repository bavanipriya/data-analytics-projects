
# Exploring COVID-19 Data: Trends, Patterns and Insights #

SELECT *
FROM PortfolioProject.covid_deaths;

SELECT *
FROM PortfolioProject.covid_vaccines;


## PRE ANALYSIS ##

-- i. Daily Crude Death Rate and Infection Fatality Rate by Country
SELECT location, date, total_cases, total_deaths, 
	(total_deaths/population)*100 AS crude_death_rate, 
	(total_deaths/total_cases)*100 AS fatality_rate
FROM PortfolioProject.covid_deaths
WHERE continent != ''
ORDER BY location, date;


-- ii. Fatality Rate in Canada
SELECT location, date, total_cases, total_deaths, 
	(total_deaths/total_cases)*100 AS fatality_rate
FROM PortfolioProject.covid_deaths
WHERE location = 'Canada'
ORDER BY date;


-- ii. Fatality Rate in India
SELECT location, date, total_cases, total_deaths, 
	(total_deaths/total_cases)*100 AS fatality_rate
FROM PortfolioProject.covid_deaths
WHERE location like '%india%'
ORDER BY date;


-- iv. Daily Infection Rate by Country
SELECT location, date, population, total_cases, 
	(total_cases/population)*100 AS infection_rate
FROM PortfolioProject.covid_deaths
WHERE continent != ''
ORDER BY location, date;


-- v. Infection Rate in Canada
SELECT location, date, population, total_cases, 
	(total_cases/population)*100 AS infection_rate
FROM PortfolioProject.covid_deaths
WHERE location = 'Canada'
ORDER BY location, date;


-- vi. Infection Rate in India
SELECT location, date, population, total_cases, 
	(total_cases/population)*100 AS infection_rate
FROM PortfolioProject.covid_deaths
WHERE location like '%india%'
ORDER BY location, date;


## MAIN ANALYSIS ##

-- 1. Daily Infection, Fatality and Crude Death Rate by Country
SELECT location, date, population,
	total_cases, total_deaths, 
    (total_cases/population)*100 infection_rate,
    (total_deaths/total_cases)*100 AS fatality_rate,
    (total_deaths/population)*100 AS crude_death_rate
FROM PortfolioProject.covid_deaths
ORDER BY location, date;


-- 2. Max Deaths, Max Fatality Rate, Max Crude Death Rate by Country
SELECT location, population, 
	MAX(total_deaths) AS max_deaths,
	MAX(total_deaths/total_cases)*100 AS max_fatality_rate,
	MAX(total_deaths/population)*100 AS max_crude_death_rate
FROM PortfolioProject.covid_deaths
WHERE continent != ''
GROUP BY location, population
ORDER BY max_deaths DESC;


-- 3. Max Infections and Max Infection Rate by Country
SELECT location, population, MAX(total_cases) AS max_cases, 
	MAX(total_cases/population)*100 AS max_infection_rate
FROM PortfolioProject.covid_deaths
WHERE continent != ''
GROUP BY location, population
ORDER BY max_infection_rate DESC;


-- 4. Max Deaths, Max Fatality Rate, Max Crude Death Rate by Location Group
SELECT location, MAX(total_deaths) AS max_deaths,
	MAX(total_deaths/total_cases)*100 AS max_fatality_rate,
    MAX(total_deaths/population)*100 AS max_crude_death_rate
FROM PortfolioProject.covid_deaths
WHERE continent = ''
GROUP BY location
ORDER BY max_fatality_rate DESC;


-- 5. Max Infections and Max Infection Rate by Location Group
SELECT location, MAX(total_cases) AS max_cases, 
	MAX(total_cases/population)*100 AS max_infection_rate
FROM PortfolioProject.covid_deaths
WHERE continent = ''
GROUP BY location
ORDER BY max_infection_rate DESC;


-- 6. Max Deaths and Max Crude Death Rate by Location Group
SELECT location, MAX(total_deaths) AS max_deaths, 
	MAX(total_deaths/population)*100 AS max_crude_death_rate
FROM PortfolioProject.covid_deaths 
WHERE continent = ''
GROUP BY location
ORDER BY max_deaths DESC;


-- 7. Daily Total Cases, Total Deaths, Fatality Rate and Crude Death Rate Worldwide
SELECT date, SUM(total_cases) AS total_cases_world, 
	SUM(total_deaths) AS total_deaths_world,
    (SUM(total_deaths)/SUM(total_cases))*100 AS fatality_rate_world
FROM PortfolioProject.covid_deaths
WHERE continent != ''
GROUP BY date
ORDER BY date;


-- 8. Daily Total Cases, Total Deaths, Infection Rate Worldwide
SELECT date, SUM(total_cases) AS total_cases_world, 
	SUM(total_deaths) AS total_deaths_world,
    (SUM(total_cases)/MAX(population))*100 AS infection_rate_world
FROM PortfolioProject.covid_deaths
WHERE continent != ''
GROUP BY date
ORDER BY date;


-- 9a. Daily Total New Cases, New Deaths, New Fatality Rate Worldwide
SELECT date, SUM(new_cases) AS total_new_cases_world, 
	SUM(new_deaths) AS total_new_deaths_world,
    (SUM(new_deaths)/SUM(new_cases))*100 AS new_fatality_rate_world
FROM PortfolioProject.covid_deaths
WHERE continent != ''
GROUP BY date
ORDER BY date;


-- 9b. Overall Total New Cases, New Deaths, New Fatality Rate Worldwide
SELECT SUM(new_cases) AS total_new_cases_world,
	SUM(new_deaths) AS total_new_deaths_world,
    (SUM(new_deaths)/SUM(new_cases))*100 AS new_fatality_rate_world
FROM PortfolioProject.covid_deaths
WHERE continent != '';


-- 10a.Total Population by Country as of June 7, 2023
SELECT location, population 
FROM PortfolioProject.covid_deaths
WHERE continent != '' AND date = '2023-06-07 00:00:00'
ORDER BY population DESC;


-- 10b. Total World Population as of June 7, 2023
SELECT SUM(population) AS total_world_population
FROM PortfolioProject.covid_deaths
WHERE continent != '' AND date = '2023-06-07 00:00:00';


-- 11. Number of People Vaccinated and Vaccination Rate by Location Group
SELECT dea.location, SUM(dea.population) AS population, 
	MAX(vac.people_vaccinated) AS total_vaccinated,
    (MAX(vac.people_vaccinated)/MAX(dea.population))*100 AS vaccination_rate
FROM PortfolioProject.covid_deaths dea
JOIN PortfolioProject.covid_vaccines vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent = '' 
GROUP BY dea.location
ORDER BY vaccination_rate DESC;


-- 12. Number of People Vaccinated and Vaccination Rate by Country
SELECT dea.location, MAX(dea.population) AS population, 
	MAX(vac.people_vaccinated) AS total_vaccinated,
    (MAX(vac.people_vaccinated)/MAX(dea.population))*100 AS vaccination_rate
FROM PortfolioProject.covid_deaths dea
JOIN PortfolioProject.covid_vaccines vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent != ''
GROUP BY location
ORDER BY vaccination_rate;


-- 13. Daily Number of Vaccinations by Location Groups
SELECT dea.location, dea.date, MAX(vac.new_vaccinations) as new_vaccinations
FROM PortfolioProject.covid_deaths dea
JOIN PortfolioProject.covid_vaccines vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent = ''
GROUP BY dea.date, dea.location
ORDER BY dea.location;


-- 14. Daily Number of New Vaccinations by Country
SELECT dea.continent, dea.location, dea.date, vac.new_vaccinations
FROM PortfolioProject.covid_deaths dea
JOIN PortfolioProject.covid_vaccines vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent != ''
ORDER BY dea.location;


-- 15. Rolling Count of New and Total Vaccinations by Country
SELECT  dea.continent, dea.location, dea.date, vac.new_vaccinations,
	SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS overall_vaccinated
FROM PortfolioProject.covid_deaths dea
JOIN PortfolioProject.covid_vaccines vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent != ''
ORDER BY dea.location, dea.continent;


-- 16. Rolling Vaccination Rate by Country using CTE
WITH vaccinated_pop (continent, location, population, date, new_vaccinations, overall_vaccinated) AS
(
SELECT  dea.continent, dea.location, dea.population, dea.date, vac.new_vaccinations,
	SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS overall_vaccinated
FROM PortfolioProject.covid_deaths dea
JOIN PortfolioProject.covid_vaccines vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent != ''
-- ORDER BY dea.location, dea.continent;
)
SELECT *, (overall_vaccinated/population)*100 AS vac_rate
FROM vaccinated_pop;


## VIEWS ##

-- 1. Daily Infection, Fatality and Crude Death Rate by Country
USE PortfolioProject;
CREATE OR REPLACE VIEW daily_ifcr_country AS
SELECT location, date, population,
	total_cases, total_deaths, 
    (total_cases/population)*100 infection_rate,
    (total_deaths/total_cases)*100 AS fatality_rate,
    (total_deaths/population)*100 AS crude_death_rate
FROM PortfolioProject.covid_deaths
ORDER BY location, date;


-- 2. Max Deaths, Max Fatality Rate, Max Crude Death Rate by Country
USE PortfolioProject;
CREATE OR REPLACE VIEW max_dfcr_country AS
SELECT location, population, 
	MAX(total_deaths) AS max_deaths,
	MAX(total_deaths/total_cases)*100 AS max_fatality_rate,
	MAX(total_deaths/population)*100 AS max_crude_death_rate
FROM PortfolioProject.covid_deaths
WHERE continent != ''
GROUP BY location, populationmax_dfcr_country
ORDER BY max_deaths DESC;


-- 3. Max Infections and Max Infection Rate by Country
USE PortfolioProject;
CREATE OR REPLACE VIEW max_ifr_country AS
SELECT location, population, MAX(total_cases) AS max_cases, 
	MAX(total_cases/population)*100 AS max_infection_rate
FROM PortfolioProject.covid_deaths
WHERE continent != ''
GROUP BY location, population
ORDER BY max_infection_rate DESC;


-- 4. Max Deaths, Max Fatality Rate, Max Crude Death Rate by Location Group
USE PortfolioProject;
CREATE OR REPLACE VIEW max_dfcr_locgroup AS
SELECT location, MAX(total_deaths) AS max_deaths,
	MAX(total_deaths/total_cases)*100 AS max_fatality_rate,
    MAX(total_deaths/population)*100 AS max_crude_death_rate
FROM PortfolioProject.covid_deaths
WHERE continent = ''
GROUP BY location
ORDER BY max_fatality_rate DESC;


-- 5. Max Infections and Max Infection Rate by Location Group
USE PortfolioProject;
CREATE OR REPLACE VIEW max_ifr_locgroup AS
SELECT location, MAX(total_cases) AS max_cases, 
	MAX(total_cases/population)*100 AS max_infection_rate
FROM PortfolioProject.covid_deaths
WHERE continent = ''
GROUP BY location
ORDER BY max_infection_rate DESC;


-- 6. Max Deaths and Max Crude Death Rate by Location Group
USE PortfolioProject;
CREATE OR REPLACE VIEW max_deaths_locgroup AS
SELECT location, MAX(total_deaths) AS max_deaths, 
	MAX(total_deaths/population)*100 AS max_crude_death_rate
FROM PortfolioProject.covid_deaths 
WHERE continent = ''
GROUP BY location
ORDER BY max_deaths DESC;


-- 7. Daily Total Cases, Total Deaths, Fatality Rate and Crude Death Rate Worldwide
USE PortfolioProject;
CREATE OR REPLACE VIEW daily_fcr_world AS
SELECT date, SUM(total_cases) AS total_cases_world, 
	SUM(total_deaths) AS total_deaths_world,
    (SUM(total_deaths)/SUM(total_cases))*100 AS fatality_rate_world
FROM PortfolioProject.covid_deaths
WHERE continent != ''
GROUP BY date
ORDER BY date;


-- 8. Daily Total Cases, Total Deaths, Infection Rate Worldwide
USE PortfolioProject;
CREATE OR REPLACE VIEW daily_ifr_world AS
SELECT date, SUM(total_cases) AS total_cases_world, 
	SUM(total_deaths) AS total_deaths_world,
    (SUM(total_cases)/MAX(population))*100 AS infection_rate_world
FROM PortfolioProject.covid_deaths
WHERE continent != ''
GROUP BY date
ORDER BY date;


-- 9a. Daily Total New Cases, New Deaths, New Fatality Rate Worldwide
USE PortfolioProject;
CREATE OR REPLACE VIEW daily_new_dfr_world AS
SELECT date, SUM(new_cases) AS total_new_cases_world, 
	SUM(new_deaths) AS total_new_deaths_world,
    (SUM(new_deaths)/SUM(new_cases))*100 AS new_fatality_rate_world
FROM PortfolioProject.covid_deaths
WHERE continent != ''
GROUP BY date
ORDER BY date;


-- 9b. Overall Total New Cases, New Deaths, New Fatality Rate Worldwide
USE PortfolioProject;
CREATE OR REPLACE VIEW overall_new_dfr_world AS
SELECT SUM(new_cases) AS total_new_cases_world,
	SUM(new_deaths) AS total_new_deaths_world,
    (SUM(new_deaths)/SUM(new_cases))*100 AS new_fatality_rate_world
FROM PortfolioProject.covid_deaths
WHERE continent != '';


-- 10a.Total Population by Country as of June 7, 2023
USE PortfolioProject;
CREATE OR REPLACE VIEW total_pop_country AS
SELECT location, population 
FROM PortfolioProject.covid_deaths
WHERE continent != '' AND date = '2023-06-07 00:00:00'
ORDER BY population DESC;


-- 10b. Total World Population as of June 7, 2023
USE PortfolioProject;
CREATE OR REPLACE VIEW total_pop_world AS
SELECT SUM(population) AS total_world_population
FROM PortfolioProject.covid_deaths
WHERE continent != '' AND date = '2023-06-07 00:00:00';


-- 11. Number of People Vaccinated and Vaccination Rate by Location Group
USE PortfolioProject;
CREATE OR REPLACE VIEW vac_locgroup AS
SELECT dea.location, SUM(dea.population) AS population, 
	MAX(vac.people_vaccinated) AS total_vaccinated,
    (MAX(vac.people_vaccinated)/MAX(dea.population))*100 AS vaccination_rate
FROM PortfolioProject.covid_deaths dea
JOIN PortfolioProject.covid_vaccines vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent = '' 
GROUP BY dea.location
ORDER BY vaccination_rate DESC;


-- 12. Number of People Vaccinated and Vaccination Rate by Country
USE PortfolioProject;
CREATE OR REPLACE VIEW vac_country AS
SELECT dea.location, MAX(dea.population) AS population, 
	MAX(vac.people_vaccinated) AS total_vaccinated,
    (MAX(vac.people_vaccinated)/MAX(dea.population))*100 AS vaccination_rate
FROM PortfolioProject.covid_deaths dea
JOIN PortfolioProject.covid_vaccines vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent != ''
GROUP BY location
ORDER BY vaccination_rate DESC;


-- 13. Daily Number of Vaccinations by Location Group
USE PortfolioProject;
CREATE OR REPLACE VIEW daily_new_vac_locgroup AS
SELECT dea.location, dea.date, MAX(vac.new_vaccinations) as new_vaccinations
FROM PortfolioProject.covid_deaths dea
JOIN PortfolioProject.covid_vaccines vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent = ''
GROUP BY dea.date, dea.location
ORDER BY dea.location;


-- 14. Daily Number of New Vaccinations by Country
USE PortfolioProject;
CREATE OR REPLACE VIEW daily_new_vac_country AS
SELECT dea.continent, dea.location, dea.date, vac.new_vaccinations
FROM PortfolioProject.covid_deaths dea
JOIN PortfolioProject.covid_vaccines vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent != ''
ORDER BY dea.location;


-- 15. Rolling Count of New and Total Vaccinations by Country
USE PortfolioProject;
CREATE OR REPLACE VIEW rolling_vac_country AS
SELECT  dea.continent, dea.location, dea.date, vac.new_vaccinations,
	SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS overall_vaccinated
FROM PortfolioProject.covid_deaths dea
JOIN PortfolioProject.covid_vaccines vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent != ''
ORDER BY dea.location, dea.continent;


-- 16. Rolling Vaccination Rate by Country using CTE
USE PortfolioProject;
CREATE OR REPLACE VIEW rolling_vac_rate_country AS
WITH vaccinated_pop (continent, location, population, date, new_vaccinations, overall_vaccinated) AS
(
SELECT  dea.continent, dea.location, dea.population, dea.date, vac.new_vaccinations,
	SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS overall_vaccinated
FROM PortfolioProject.covid_deaths dea
JOIN PortfolioProject.covid_vaccines vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent != ''
-- ORDER BY dea.location, dea.continent;
)
SELECT *, (overall_vaccinated/population)*100 AS vac_rate
FROM vaccinated_pop;