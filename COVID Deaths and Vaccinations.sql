SELECT *
FROM covid_deaths;


-- shows death percentage (likelihood of dying) and percentage of people with covid in India 
SELECT location, date, population,
	total_cases, total_deaths, 
    (total_cases/population)*100 covid_percentage,
    (total_deaths/total_cases)*100 AS death_percentage
FROM covid_deaths
WHERE location = 'India'
ORDER BY location, date;

-- shows death percentage (likelihood of dying) and percentage of people with covid
SELECT location, date, population,
	total_cases, total_deaths, 
    (total_cases/population)*100 covid_percentage,
    (total_deaths/total_cases)*100 AS death_percentage
FROM covid_deaths
ORDER BY location, date;

-- shows the maximum number of infections and maximum infection percentage by country
SELECT location, population, 
	MAX(total_cases) AS maximum_infections, 
	MAX(total_cases)/population*100 AS max_infection_percentage
FROM covid_deaths
WHERE continent != ''
GROUP BY location
ORDER BY max_infection_percentage DESC, location;

--  shows the highest death count and death count percentage of each country
SELECT location, population,
	MAX(total_deaths) AS maximum_deaths, 
	MAX(total_deaths)/population*100 AS max_death_percentage
FROM covid_deaths
WHERE continent != ''
GROUP BY location
ORDER BY maximum_deaths DESC, location;

-- shows the country with the highest deaths and death percentage for each continent
SELECT continent, location, population, MAX(total_deaths) AS max_deaths,
	MAX((total_deaths/population))*100 AS max_death_percentage
FROM covid_deaths
WHERE continent != '' AND date = '2022-06-24 00:00:00'
GROUP BY location
ORDER BY location, max_death_percentage DESC;


-- finding max death percent by continent
SELECT continent, SUM(population) AS population,
	MAX(total_deaths) AS maximum_deaths, 
	MAX((total_deaths/population))*100 AS max_death_percentage
FROM covid_deaths
WHERE continent != ''
GROUP BY continent
ORDER BY max_death_percentage DESC;

-- ordering continents by the number of deaths
SELECT continent, SUM(population) AS population,
	SUM(total_deaths) AS deaths,
    MAX((total_deaths/population))*100 AS max_death_percentage
FROM covid_deaths
WHERE continent != ''
GROUP BY continent
ORDER BY deaths DESC;

-- another way to order the number of deaths by regions
SELECT continent, location, SUM(population) AS population,
	SUM(total_deaths) AS deaths,
    MAX((total_deaths/population))*100 AS max_death_percentage
FROM covid_deaths
WHERE continent = ''
GROUP BY location
ORDER BY deaths DESC;


-- getting max death data by grouping by continents
SELECT continent, MAX(total_deaths) AS max_deaths,
		SUM(new_deaths) AS total_death_count
FROM covid_deaths
WHERE continent != ''
GROUP BY continent
ORDER BY max_deaths DESC;

-- getting max death data from pre combined location data 
SELECT location, MAX(total_deaths) AS max_deaths
FROM covid_deaths
WHERE continent = ''
GROUP BY location
ORDER BY max_deaths DESC;


-- USE THIS (FOR NOW)

-- 1. getting highest death count by continents
SELECT continent, MAX(total_deaths) AS total_death_count
FROM covid_deaths
WHERE continent != ''
GROUP BY continent
ORDER BY total_death_count DESC;

/* 
Actual correct code to get the sum of maximum deaths by continent

SELECT continent, SUM(new_deaths) AS total
FROM covid_deaths
WHERE continent != '' -- AND date = '2022-06-24 00:00:00'
GROUP BY continent
ORDER BY total DESC;
*/

-- 2. drilling down continents to get countries 
SELECT location, continent, MAX(total_deaths) AS total_death_count
FROM covid_deaths
WHERE continent != ''
GROUP BY location
ORDER BY total_death_count DESC;

-- 3. getting total cases and deaths wordlwide by each date
SELECT date, SUM(total_cases) AS total_cases_world, SUM(total_deaths) AS total_deaths_world,
			(SUM(total_deaths)/SUM(total_cases)*100) AS death_percent_world
FROM covid_deaths
WHERE continent != ''
GROUP BY date
ORDER BY date;

-- 4. getting number of new cases and deaths worldwide by each date
SELECT date, SUM(new_cases) AS total_new_cases_world, SUM(new_deaths) AS total_new_deaths_world,
			(SUM(new_deaths)/SUM(new_cases)*100) AS new_death_percent_world
FROM covid_deaths
WHERE continent != ''
GROUP BY date
ORDER BY date;

-- 5. total overall cases and deaths throughout the pandemic
SELECT SUM(new_cases) AS total_new_cases_world, SUM(new_deaths) AS total_new_deaths_world,
		(SUM(new_deaths)/SUM(new_cases)*100) AS new_death_percent_world
FROM covid_deaths
WHERE continent != '';

-- 6. current total population of the world
SELECT SUM(population)
FROM covid_deaths
WHERE continent != '' AND date = '2022-06-24 00:00:00';


SELECT *
FROM covid_vaccinations;


-- JOINS AND CTE

-- 1. total population and vaccinations by continent on 24/06/2022
SELECT dea.continent, SUM(dea.population) AS population, SUM(vac.people_vaccinated) AS vaccinated
FROM covid_deaths dea
JOIN covid_vaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent != '' AND dea.date = '2022-06-24 00:00:00'
GROUP BY continent;

-- 2. population and vaccinations by country everyday
SELECT dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations
FROM covid_deaths dea
JOIN covid_vaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent != ''
ORDER BY dea.location;

-- 3. maintaining a rolling count of vaccinations by country for each date
SELECT dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations,
	SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS overall_vaccinated
FROM covid_deaths dea
JOIN covid_vaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent != ''
ORDER BY dea.location, dea.continent;

-- creating a cte to use the newly formed column in the same query to get vaccinated_percentage
WITH vaccinated_pop (location, continent, date, population, new_vaccinations, overall_vaccinated)
AS 
(
SELECT dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations,
	SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS overall_vaccinated
FROM covid_deaths dea
JOIN covid_vaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent != ''
-- ORDER BY dea.location, dea.continent;
)
SELECT *, (overall_vaccinated/population)*100 AS vaccinated_percentage
FROM vaccinated_pop;


-- CREATING VIEWS FOR VISUALIZATIONS

CREATE VIEW daily_death_percent_india AS
SELECT location, date, population,
	total_cases, total_deaths, 
    (total_cases/population)*100 covid_percentage,
    (total_deaths/total_cases)*100 AS death_percentage
FROM covid_deaths
WHERE location = 'India'
ORDER BY location, date;

CREATE VIEW daily_death_percent_world AS
SELECT location, date, population,
	total_cases, total_deaths, 
    (total_cases/population)*100 covid_percentage,
    (total_deaths/total_cases)*100 AS death_percentage
FROM covid_deaths
ORDER BY location, date;

CREATE VIEW maximum_infection_percent_world AS
SELECT location, population, 
	MAX(total_cases) AS maximum_infections, 
	MAX(total_cases)/population*100 AS max_infection_percentage
FROM covid_deaths
WHERE continent != ''
GROUP BY location
ORDER BY max_infection_percentage DESC, location;

CREATE VIEW maximum_death_percent_world AS
SELECT location, population,
	MAX(total_deaths) AS maximum_deaths, 
	MAX(total_deaths)/population*100 AS max_death_percentage
FROM covid_deaths
WHERE continent != ''
GROUP BY location
ORDER BY maximum_deaths DESC, location;

CREATE VIEW maximum_death_percent_continents AS
SELECT continent, SUM(population) AS population,
	MAX(total_deaths) AS maximum_deaths, 
	MAX((total_deaths/population))*100 AS max_death_percentage
FROM covid_deaths
WHERE continent != ''
GROUP BY continent
ORDER BY max_death_percentage DESC;

CREATE VIEW maximum_deaths_continents AS
SELECT continent, MAX(total_deaths) AS max_deaths,
		SUM(new_deaths) AS total_death_count
FROM covid_deaths
WHERE continent != ''
GROUP BY continent
ORDER BY max_deaths DESC;

CREATE VIEW maximum_deaths_regions AS
SELECT location, MAX(total_deaths) AS max_deaths
FROM covid_deaths
WHERE continent = ''
GROUP BY location
ORDER BY max_deaths DESC;

CREATE VIEW total_deaths_continents AS
SELECT continent, MAX(total_deaths) AS total_death_count
FROM covid_deaths
WHERE continent != ''
GROUP BY continent
ORDER BY total_death_count DESC;

CREATE VIEW total_deaths_countries AS
SELECT location, continent, MAX(total_deaths) AS total_death_count
FROM covid_deaths
WHERE continent != ''
GROUP BY location
ORDER BY total_death_count DESC;

CREATE VIEW cases_deaths_world_datewise AS
SELECT date, SUM(total_cases) AS total_cases_world, SUM(total_deaths) AS total_deaths_world,
			(SUM(total_deaths)/SUM(total_cases)*100) AS death_percent_world
FROM covid_deaths
WHERE continent != ''
GROUP BY date
ORDER BY date;

CREATE VIEW new_cases_deaths_world_datewise AS
SELECT date, SUM(new_cases) AS total_new_cases_world, SUM(new_deaths) AS total_new_deaths_world,
			(SUM(new_deaths)/SUM(new_cases)*100) AS new_death_percent_world
FROM covid_deaths
WHERE continent != ''
GROUP BY date
ORDER BY date;

CREATE VIEW pop_vaccine_world_datewise AS
SELECT dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations
FROM covid_deaths dea
JOIN covid_vaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent != ''
ORDER BY dea.location;

CREATE VIEW pop_vaccine_rolling_world_datewise AS
SELECT dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations,
	SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS overall_vaccinated
FROM covid_deaths dea
JOIN covid_vaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent != ''
ORDER BY dea.location, dea.continent;

CREATE VIEW vaccine_rolling_percent_world_datewise AS
WITH vaccinated_pop (location, continent, date, population, new_vaccinations, overall_vaccinated)
AS 
(
SELECT dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations,
	SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS overall_vaccinated
FROM covid_deaths dea
JOIN covid_vaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent != ''
-- ORDER BY dea.location, dea.continent;
)
SELECT *, (overall_vaccinated/population)*100 AS vaccinated_percentage
FROM vaccinated_pop;
