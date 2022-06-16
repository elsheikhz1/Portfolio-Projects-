Select* 
from PortfolioProject..CovidDeath
order by 3,4

--Select* 
--from PortfolioProject..CovidVaccinations
--order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeath
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Chances of death of covid cases in Australia on a specific date
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from PortfolioProject..CovidDeath
where location = 'Australia'
order by 1,2

-- Looking at Total Cases vs Population 
-- Shows percentage of population infected by COVID 
Select location, date, total_cases, population, (total_cases/population)*100 as infectionpercentage
from PortfolioProject..CovidDeath
where location = 'Australia'
order by 1,2

-- Looking at Countries with Highest Infection Rate compared to Population 
Select location, population, MAX(total_cases) AS HighestInfectionCount, Max((total_cases/population))*100 as infectionpercentage
from PortfolioProject..CovidDeath
--where location = 'Australia'
Group by location, population
order by infectionpercentage desc

-- Looking at Countries with Highest Death Count Per Population 

Select location, population, MAX(cast(total_deaths as int)) AS TotalDeathCount --we used cast function to change from nvarchar to int
from PortfolioProject..CovidDeath
where continent is not null -- Due to some location is not written as countries on the data
Group by location, population
order by TotalDeathCount desc

-- Looking at Continent with Highest Death Count Per Population 
Select	continent, MAX(cast(total_deaths as int)) AS TotalDeathCount --we used cast function to change from nvarchar to int
from PortfolioProject..CovidDeath
where continent is not null
Group by continent
order by TotalDeathCount desc

-- Looking at the daily Total new Cases and Total Deaths
Select date, SUM(new_cases) as Totalnewcases, SUM(cast(new_deaths as int)) as TotalDeath, SUM(cast(new_deaths as int))/Sum(new_cases)*100 as Deathpercentage -- we used cast function to change from nvarchar to int
from PortfolioProject..CovidDeath
where continent is not null
Group by date
order by 1,2 

-- Looking at Total amount of people in the world that has been vaccinated

With PopvsVac (Continent, location, date, population, new_vaccinations, peoplevaccinated)
as -- we use CTE to use peoplevaccinated coloumn, because it's a new column 
(

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as Peoplevaccinated-- so everytime location is changed the count starts all over again 
-- bigint used due to the SUM function
-- order by dea.location and dea.date so we add each day only same location
From PortfolioProject..CovidDeath dea
Join PortfolioProject..CovidVaccinations vac
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null -- dea.contintent because it's only on CovidDeath Table
--order by 2,3
)

Select*, (peoplevaccinated/population)*100 as percentvacinated 
From PopvsVac

--Create View for later visulisation 
Create view TotalDeathCount2 as

Select location, population, MAX(cast(total_deaths as int)) AS TotalDeathCount --we used cast function to change from nvarchar to int
from PortfolioProject..CovidDeath
where continent is not null -- Due to some location is not written as countries on the data
Group by location, population
--order by TotalDeathCount desc
 
 -- For tableu Visulazation 

 Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeath
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeath
--Where location like '%Australia%'
Where continent is null 
and location not in ('World', 'European Union', 'International', 'upper middle income', 'High income', 'Lower middle income', 'Low income')
Group by location
order by TotalDeathCount desc

Select location, population, MAX(total_cases) AS HighestInfectionCount, Max((total_cases/population))*100 as infectionpercentage
from PortfolioProject..CovidDeath
--where location = 'Australia'
Group by location, population
order by infectionpercentage desc

Select location, population, date, MAX(total_cases) AS HighestInfectionCount, Max((total_cases/population))*100 as infectionpercentage
from PortfolioProject..CovidDeath
--where location = 'Australia'
Group by location, population, date
order by infectionpercentage desc