SELECT * FROM Portfolio_Project_Alex..CovidDeaths
WHERE continent is not null
ORDER BY 3,4

--SELECT * FROM Portfolio_Project_Alex..CovidVaccinations
--ORDER BY 3,4

-- Select data that we are using

-- Total Cases vs Total Deaths

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS deathrate_percentage
FROM Portfolio_Project_Alex..CovidDeaths
Where location like '%states%'
ORDER BY 1,2


-- Total Cases vs Population
SELECT Location, date, total_cases, population, (total_cases/population)*100 AS pop_deathrate
FROM Portfolio_Project_Alex..CovidDeaths
ORDER BY 1,2


-- Countries with Highest Infection Rate by Population
SELECT Location, population, MAX(total_cases) as HighestInfection, MAX((total_cases/population))*100 as PercentPopulation
FROM Portfolio_Project_Alex..CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulation desc


-- Countries Death Toll
SELECT Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM Portfolio_Project_Alex..CovidDeaths
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount desc


-- Continents Death Toll
SELECT Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM Portfolio_Project_Alex..CovidDeaths
WHERE continent is null
GROUP BY Location
ORDER BY TotalDeathCount desc


-- New cases:deaths percentage
SELECT date, SUM(new_cases), SUM(cast(new_deaths as int)), SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM Portfolio_Project_Alex..CovidDeaths
WHERE continent is not null
Group by date
ORDER BY 1


-- Total Population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
FROM Portfolio_Project_Alex..CovidDeaths dea 
JOIN Portfolio_Project_Alex..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
FROM Portfolio_Project_Alex..CovidDeaths dea 
JOIN Portfolio_Project_Alex..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
-- order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


-- Using Temp Table to perform Calculation on Partition By in previous query
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Portfolio_Project_Alex..CovidDeaths dea
Join Portfolio_Project_Alex..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


--Create view to store data for later visualizations
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Portfolio_Project_Alex..CovidDeaths dea
Join Portfolio_Project_Alex..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

Select *
From PercentPopulationVaccinated