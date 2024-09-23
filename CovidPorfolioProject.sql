
-- looking at total cases vs total deaths  
SELECT 
 location, date, total_cases, total_deaths, total_deaths/total_cases*100 as death_percentage
FROM CovidDeaths
where location = 'Canada'
order by 1,3;


-- looking at total cases vs population
 -- show what percent of population has gotten covid
SELECT 
 location, date,population total_cases, (total_cases/population*100) as percentageWithCovid
FROM CovidDeaths
where location = 'United States'
order by 1,3;

-- Looking at countries with highest infection rate compared to population
SELECT 
 Location, population, Max(total_cases) as HighestInfectionCount, MAX(total_cases/population*100) as percentageWithCovid
FROM CovidDeaths
group by Location, Population
order by percentageWithCovid desc;

-- showing countries with highest death count per population
SELECT 
Location, Max(total_deaths) as TotalDeathCount
FROM CovidDeaths
where continent is not null
group by Location
order by TotalDeathCount desc;

-- break down by continent
-- Showing continents with highest death count per population
SELECT 
continent, Max(total_deaths) as TotalDeathCount
FROM CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc;


-- GLOBAL NUMBERS
SELECT 
 SUM(new_cases) as totalCases, SUM(new_deaths) as totalDeaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM CovidDeaths
-- where location = 'Canada'
where continent is not null
group by date
order by 1,2;

-- Total of people vs Vaccinated
SELECT 
    d.continent, 
    d.location, 
    d.date, 
    d.population, 
    v.new_vaccinations,
    SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS rollingPeopleVaccinated, 
    SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, d.date) / d.population * 100 AS percentOfPeople
FROM 
    coviddeaths AS d  
JOIN 
    covidvaccination AS v  
ON 
    d.location = v.location AND d.date = v.date 
WHERE 
    d.continent IS NOT NULL 
    AND d.location = 'Canada'
ORDER BY 
    d.location, d.date;
    


-- USE CTE

with PopvsVac(continent,location, date, population, new_vaccinations, rollingPeopleVaccinated)
as 
(
SELECT 
    d.continent, 
    d.location, 
    d.date, 
    d.population, 
    v.new_vaccinations,
    SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS rollingPeopleVaccinated
FROM 
    coviddeaths AS d  
JOIN 
    covidvaccination AS v  
ON 
    d.location = v.location AND d.date = v.date 
WHERE 
    d.continent IS NOT NULL 
    
ORDER BY 
    d.location, d.date

)
select *, (rollingpeoplevaccinated/population)*100 from popvsvac;




-- Temp table
Drop table if exists PercentPopulationVaccinated;
Create temporary table PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(255),
Date text,
Population int,
new_vaccinations int,
rollingpeoplevaccinated int);
Insert into PercentPopulationVaccinated
SELECT 
    d.continent, 
    d.location, 
    d.date, 
    d.population, 
    v.new_vaccinations,
    SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS rollingPeopleVaccinated
FROM 
    coviddeaths AS d  
JOIN 
    covidvaccination AS v  
ON 
    d.location = v.location AND d.date = v.date 
WHERE 
    d.continent IS NOT NULL 
    
ORDER BY 
    d.location, d.date
;
select *, (rollingpeoplevaccinated/population)*100 from PercentPopulationVaccinated;

-- Creating view to store data for later visualizations
Create View PercentPopulationVaccinated as
SELECT 
    d.continent, 
    d.location, 
    d.date, 
    d.population, 
    v.new_vaccinations,
    SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS rollingPeopleVaccinated
FROM 
    coviddeaths AS d  
JOIN 
    covidvaccination AS v  
ON 
    d.location = v.location AND d.date = v.date 
WHERE 
    d.continent IS NOT NULL ;
    
-- ORDER BY 
--     d.location, d.date

select * from PercentpopulationVaccinated

