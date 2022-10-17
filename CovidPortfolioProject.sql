--Checking Data from CovidDeaths Table

SELECT *
FROM CovidPortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3, 4

--Checking Data from CovidVaccinations Table

SELECT *
FROM CovidPortfolioProject..CovidVaccinations
WHERE continent IS NOT NULL
ORDER BY 3, 4

--Viewing Specific Data

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidPortfolioProject..CovidDeaths
WHERE continent IS NOT NULL


-- Covid Death Percentage per day by country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage
FROM CovidPortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2


--Covid Affected Percentage per day by country

SELECT location, date, total_cases, population, (total_cases/population)*100 AS Affected_Percentage
FROM CovidPortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2


--Highest Covid Positive percentage by Country

SELECT location, MAX(total_cases) AS Total_Cases, population, MAX((total_cases/population)*100) AS Covid_Affected_Percentage
FROM CovidPortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY Covid_Affected_Percentage DESC


--Highest Death Rate by Country

SELECT location, MAX(CAST(total_deaths AS int)) AS Total_Death_Count, population, MAX((total_deaths/population)*100) AS Death_Percentage
FROM CovidPortfolioProject..CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY location, population
ORDER BY Death_Percentage DESC

CREATE VIEW CountryDeathRates AS
SELECT location, MAX(CAST(total_deaths AS int)) AS Total_Death_Count, population, MAX((total_deaths/population)*100) AS Death_Percentage
FROM CovidPortfolioProject..CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY location, population


--Death Count by Continent

SELECT continent, SUM(CAST(new_deaths AS INT)) AS Total_Death_Count
FROM CovidPortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Total_Death_Count DESC

CREATE VIEW ContinentCovidStats AS
SELECT continent, SUM(CAST(new_deaths AS INT)) AS Total_Death_Count
FROM CovidPortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent


--Global Covid Cases per Day

SELECT date, SUM(new_cases) AS New_Cases, SUM(CAST(new_deaths AS INT)) AS New_deaths, (SUM(CAST(new_deaths AS INT))/SUM(new_cases))*100 AS Death_Percentage
FROM CovidPortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1

CREATE VIEW DailyGlobalCovidData AS
SELECT date, SUM(new_cases) AS New_Cases, SUM(CAST(new_deaths AS INT)) AS New_deaths, (SUM(CAST(new_deaths AS INT))/SUM(new_cases))*100 AS Death_Percentage
FROM CovidPortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date

SELECT SUM(new_cases) AS New_Cases, SUM(CAST(new_deaths AS INT)) AS New_deaths, (SUM(CAST(new_deaths AS INT))/SUM(new_cases))*100 AS Death_Percentage
FROM CovidPortfolioProject..CovidDeaths
WHERE continent IS NOT NULL



--Checking Vaccination Status

SELECT *
FROM CovidPortfolioProject..CovidDeaths deaths
JOIN CovidPortfolioProject..CovidVaccinations vaccin
	ON deaths.date = vaccin.date
	AND deaths.location = vaccin.location


--Creating CTE 

WITH VacStatus(Date, Continent, Location, Population, New_Vaccinations, Updated_Vaccinated_Count)
AS
(
SELECT  deaths.date, deaths.continent, deaths.location, deaths.population, vaccin.new_vaccinations,
SUM(CAST(vaccin.new_vaccinations AS INT)) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) AS Updated_Vaccinated_Count
FROM CovidPortfolioProject..CovidDeaths deaths
JOIN CovidPortfolioProject..CovidVaccinations vaccin
	ON deaths.date = vaccin.date
	AND deaths.location = vaccin.location
WHERE deaths.continent IS NOT NULL
)
SELECT *, (Updated_Vaccinated_Count/Population)*100 AS Vaccinated_Population_Percentage
FROM VacStatus
ORDER BY 3, 2, 1


CREATE VIEW GlobalVaccStatus as
SELECT  deaths.date, deaths.continent, deaths.location, deaths.population, vaccin.new_vaccinations,
SUM(CAST(vaccin.new_vaccinations AS INT)) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) AS Updated_Vaccinated_Count
FROM CovidPortfolioProject..CovidDeaths deaths
JOIN CovidPortfolioProject..CovidVaccinations vaccin
	ON deaths.date = vaccin.date
	AND deaths.location = vaccin.location
WHERE deaths.continent IS NOT NULL