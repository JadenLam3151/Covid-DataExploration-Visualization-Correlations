Select *
From CovidProject..CovidDeaths
Where continent is not null 
order by 3,4


Select Location, date, total_cases, new_cases, total_deaths, population
From CovidProject..CovidDeaths
Where continent is not null 
order by 1,2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select location, date, total_cases,total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS DeathPercentage
from CovidProject..covidDeaths
--Where location like '%states%'
order by 1,5

-- Total Cases vs Population
-- Shows what % of population got Covid

Select Location, date, Population, total_cases,  (CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) *100 as PercentPopulationInfected
From CovidProject..CovidDeaths
order by 1,5


-- Countries with Highest Infection Rate compared to Population
Select Location, Population, MAX(CONVERT(bigint, total_cases)) as HighestInfectionCount, MAX((CONVERT(bigint, total_cases) / NULLIF(CONVERT(float, population), 0))) *100 as PercentPopulationInfected
From CovidProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- Locations with Highest Death Count per Population
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From CovidProject..CovidDeaths
Group by Location
order by TotalDeathCount desc


-- Showing continents with the highest death count
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From CovidProject..CovidDeaths
Where NULLIF(TRIM(continent),'') IS NULL
and location not in ('World', 'European Union', 'International')
Group by location 
order by TotalDeathCount desc

-- Test
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From CovidProject..CovidDeaths
Where NULLIF(TRIM(continent),'') IS NOT NULL
Group by continent
order by TotalDeathCount desc

-- Global Numbers
Select SUM(CONVERT(float, new_cases)) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(CONVERT(float, new_deaths))/SUM(NULLIF(CONVERT(float, new_cases), 0))*100 as DeathPercentage
From CovidProject..CovidDeaths
Where NULLIF(TRIM(continent),'') IS NOT NULL
Group By date
order by 1,2

--Total death percentage of about 2.11%
Select SUM(CONVERT(float, new_cases)) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(CONVERT(float, new_deaths))/SUM(NULLIF(CONVERT(float, new_cases), 0))*100 as DeathPercentage
From CovidProject..CovidDeaths
Where NULLIF(TRIM(continent),'') IS NOT NULL
--Group By date
order by 1,2

--Daily Percent Population Infected by Country
Select Location, Population, date, MAX(CONVERT(bigint, total_cases)) as HighestInfectionCount, MAX((CONVERT(bigint, total_cases) / NULLIF(CONVERT(float, population), 0))) *100 as PercentPopulationInfected
From CovidProject..CovidDeaths
Group by Location, Population, date
order by PercentPopulationInfected desc


-- Total Population vs Vaccinations: Population that has received at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidProject..CovidDeaths dea
Join CovidProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where NULLIF(TRIM(dea.continent),'') is not null
and NULLIF(TRIM(new_vaccinations),'') is not null
order by 2, cast(dea.date as datetime) 


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidProject..CovidDeaths dea
Join CovidProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where NULLIF(TRIM(dea.continent),'') is not null
)
Select *, (RollingPeopleVaccinated/(NULLIF(CONVERT(float, population), 0)))*100
From PopvsVac


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidProject..CovidDeaths dea
Join CovidProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where NULLIF(TRIM(dea.continent),'') is not null

Create View GlobalDeathPercentage as
Select SUM(CONVERT(float, new_cases)) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(CONVERT(float, new_deaths))/SUM(NULLIF(CONVERT(float, new_cases), 0))*100 as DeathPercentage
From CovidProject..CovidDeaths
Where NULLIF(TRIM(continent),'') IS NOT NULL
Group By date

Create View ContinentDeathCount as
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From CovidProject..CovidDeaths
Where NULLIF(TRIM(continent),'') IS NULL
Group by location --Empty continent cell is "World"

Create View LocationDeathCount as
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From CovidProject..CovidDeaths
Group by Location

Create View LocationInfectionRate as
Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))) *100 as PercentPopulationInfected
From CovidProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population

Create View LocationDeathRate as
Select location, date, total_cases,total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS DeathPercentage
from CovidProject..covidDeaths

