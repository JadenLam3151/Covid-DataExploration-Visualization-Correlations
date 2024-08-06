/*

Queries used for Tableau Project

*/



-- 1. 

SELECT SUM(CONVERT(float, new_cases)) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(CONVERT(float, new_deaths))/SUM(NULLIF(CONVERT(float, new_cases), 0))*100 as DeathPercentage
FROM CovidProject..CovidDeaths
WHERE NULLIF(TRIM(continent),'') IS NOT NULL
--GROUP By date
ORDER BY 1,2

-- 2. 

-- take these out as they are not inluded in the above queries
-- European Union is part of Europe

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM CovidProject..CovidDeaths
WHERE NULLIF(TRIM(continent),'') IS NULL
and location not in ('World', 'European Union', 'International')
GROUP BY location 
ORDER BY TotalDeathCount desc


-- 3.

SELECT Location, Population, MAX(CONVERT(bigint, total_cases)) as HighestInfectionCount, MAX((CONVERT(bigint, total_cases) / NULLIF(CONVERT(float, population), 0))) *100 as PercentPopulationInfected
FROM CovidProject..CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected desc


-- 4.

SELECT Location, Population, date, MAX(CONVERT(bigint, total_cases)) as HighestInfectionCount, MAX((CONVERT(bigint, total_cases) / NULLIF(CONVERT(float, population), 0))) *100 as PercentPopulationInfected
FROM CovidProject..CovidDeaths
GROUP BY Location, Population, date
ORDER BY PercentPopulationInfected desc

-- 5.
SELECT location, MAX(Stringency_Index) as Stringency_Index, MAX(cast(total_tests as int)) as Total_Tests, MAX(cast(population_density as float)) as Population_Density, MAX(cast(people_vaccinated as int)) as Max_Vaccinations
FROM CovidProject..CovidVaccinations
WHERE location not in ('World', 'European Union', 'International', 'Asia', 'North America', 'Europe', 'Africa', 'South America')
GROUP BY location
ORDER BY Max_Vaccinations desc;



Select * From CovidProject..CovidVaccinations





