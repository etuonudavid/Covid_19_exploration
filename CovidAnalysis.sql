-- Select the data we are going to be using

Select *
From covidanalysis.coviddeaths1
Order by 1, 2;


-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract covid in your country
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From covidanalysis.coviddeaths1
-- Where Location ='Nigeria'
Order by 1, 2;

-- Looking at Total Cases vs Population
-- Shows what percentage of population got covid

Select Location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
From covidanalysis.coviddeaths1
-- Where Location ='Nigeria'
order by 1, 2;

-- Looking at countries with highest infection rate compared to population
Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentPopulationInfected
From covidanalysis.coviddeaths1
Group by Location, population
Order by PercentPopulationInfected desc;

-- Showing the countries with the highest death count per population
Select Location, MAX(cast(total_cases as unsigned)) as TotalDeathCount
From covidanalysis.coviddeaths1
Where continent is not null
Group by Location
Order by TotalDeathCount desc;


-- LET'S BREAK THINGS DOWN BY CONTINENT
-- showing continents with the highest death count per population
Select continent, MAX(cast(total_cases as unsigned)) as TotalDeathCount
From covidanalysis.coviddeaths1
where continent is not null
Group by continent
Order by TotalDeathCount desc;


-- Global Numbers
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as unsigned)) as total_deaths, SUM(cast(new_deaths as unsigned))/SUM(new_cases)*100 as DeathPercentage
From covidanalysis.coviddeaths1
where continent is not null
Group by date
order by 1, 2;


-- Looking at Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From covidanalysis.coviddeaths1 as dea
Join covidanalysis.covidvaccinations1 as vac
	on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
order by 2, 3;


-- Looking at Total Population vs Vaccinations
-- CTE
With PopVsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		SUM(cast(vac.new_vaccinations as unsigned)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From covidanalysis.coviddeaths1 as dea
INNER Join covidanalysis.covidvaccinations1 as vac
	ON dea.location = vac.location
    and dea.date = vac.date
Where dea.continent IS NOT NULL

)

Select *, (RollingPeopleVaccinated/Population)
From PopVsVac




























