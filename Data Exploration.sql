Select *
From PP_Covid19..CovidDeaths
Where continent is not null


--Select *
--From PP_Covid19..CovidVaccinations
--Where continent is not null



Select Location,date, total_cases, new_cases, total_deaths, population
From PP_Covid19..CovidDeaths
Where continent is not null
Order By 1,2


-- Total Cases Vs. Total Deaths

Select Location,date, total_cases, total_deaths, (total_deaths*100.0/total_cases)  AS DeathPercentage
From PP_Covid19..CovidDeaths
Where continent is not null
-- location = 'Philippines'


--Total Cases Vs. Population

Select Location,date, population, total_cases, (total_cases*100.0/population)  AS InfectedPopulationPercentage
From PP_Covid19..CovidDeaths
Where continent is not null
-- location = 'Philippines'


--Countries with Highest Infection Rate vs. Population

Select Location, population, MAX( total_cases) AS HighestInfectionCount, MAX(total_cases*100.0/population)  AS InfectedPopulationPercentage
From PP_Covid19..CovidDeaths
Where continent is not null
Group by Location, population
Order by InfectedPopulationPercentage DESC


--Coutries with Highest Death Count per Population

Select Location, MAX( total_deaths) AS HighestDeathCount
From PP_Covid19..CovidDeaths
Where continent is not null
Group by Location, population
Order by HighestDeathCount DESC


--Highest Death Count per Continent

Select continent, MAX( total_deaths) AS TotalDeathCount
From PP_Covid19..CovidDeaths
Where continent is not null
Group by continent
Order by TotalDeathCount DESC


--Global Numbers
Select SUM(new_cases) AS TotalCases, SUM(new_deaths) AS TotalDeaths, (SUM(new_deaths*100.0)/SUM(new_cases))  AS GlobalDeathPercentage
From PP_Covid19..CovidDeaths
Where continent is not null
Order by 1, 2


--Global Numbers -per date

Select date, SUM(new_cases) AS TotalCases, SUM(new_deaths) AS TotalDeaths, (SUM(new_deaths*100.0)/SUM(new_cases))  AS GlobalDeathPercentage
From PP_Covid19..CovidDeaths
Where continent is not null
Group by date
Order by 1, 2


---
Select*
From PP_Covid19..CovidDeaths AS dea
Join PP_Covid19..CovidVaccinations AS vac
On dea.location = vac.location
and dea.date = vac.date


--Total Population Vs. Vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PP_Covid19..CovidDeaths AS dea
Join PP_Covid19..CovidVaccinations AS vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
Order by 1, 2


--Rolling Count of Vaccinated People by Location
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PP_Covid19..CovidDeaths AS dea
Join PP_Covid19..CovidVaccinations AS vac
On dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
Order by 2,3


-- Rolling Count Rate of Vaccinated People Using CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PP_Covid19..CovidDeaths dea
Join PP_Covid19..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 AS PercentagePeopleVaccinated
From PopvsVac


--Using Temp Table
Drop Table if exists PopvsVac
Create Table PopvsVac (Continent nvarchar(255), Location nvarchar(255), Date datetime, Population bigint, New_Vaccinations bigint, RollingPeopleVaccinated float)
Insert Into PopvsVac
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PP_Covid19..CovidDeaths dea
Join PP_Covid19..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100 AS PercentPeopleVaccinated
From PopvsVac


-- Creating View to store data for later visualizations
Create View PercentPeopleVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PP_Covid19..CovidDeaths dea
Join PP_Covid19..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 