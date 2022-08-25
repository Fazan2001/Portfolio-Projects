select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

select location, date, total_cases, new_cases,total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

-- looking at total cases vs total deaths
-- shows likelihod of dying if you contract covid in your country

select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from PortfolioProject..CovidDeaths
and continent is not null
where location like '%kingdom%'

-- Looking at total cases vs Population
-- shows what percentage of population got covid
select location, date, population, total_cases, (total_cases/population)*100 as percentPopulationInfected
from PortfolioProject..CovidDeaths
where location like '%kingdom%'

-- Looking at countries with highest infection rate compared to Population

select location, population, max(total_cases) as Highestinfectioncount, max(total_cases/population)*100 as percentPopulationInfected
from PortfolioProject..CovidDeaths
-- where location like '%kingdom%'
Group by location, population
order by percentPopulationInfected desc

-- Showing Countries with highest death count per population

select	Location, Max(cast (total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
-- where location like '%kingdom%'
where continent is not null
Group by location
order by TotalDeathCount desc

-- LET'S BREAK THINGS DOWN BY CONTINENT

select continent, Max(cast (total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
-- where location like '%kingdom%'
where continent is not null
Group by continent
order by TotalDeathCount desc

-- shwoing the continents with highest death count per population

select continent, Max(cast (total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
-- where location like '%kingdom%'
where continent is not null
Group by continent
order by TotalDeathCount desc

-- Global Numbers

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(New_deaths as int))/sum(New_cases)*100 as deathpercentage
from PortfolioProject..CovidDeaths
--- where location like '%kingdom%'
where continent is not null
--Group by date
order by 1,2


-- looking at total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
, (Rollingpeoplevaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..covidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
order by 2,3

-- use cte

with PopvsVac (Continent, Location, Date, Population, New_vaccinations, Rollingpeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
-- , (Rollingpeoplevaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..covidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
-- order by 2,3
)
select *, (Rollingpeoplevaccinated/Population)*100
from PopvsVac


-- TEMP TABLE
Drop table if exists #PercentPopulstionVaccinated
create Table #PercentPopulstionVaccinated
(
Continent nvarchar(225),
location nvarchar(225),
population numeric,
New_vaccinations numeric
)

Insert into 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
-- , (Rollingpeoplevaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..covidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

select *, (Rollingpeoplevaccinated/Population)*100
from 


-- creating view to store data for later visualisations

create view  as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
-- , (Rollingpeoplevaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..covidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
-- order by 2,3

select * 
from PercentPopulstionVaccinated
