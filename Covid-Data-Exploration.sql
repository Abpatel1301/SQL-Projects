select * 
from SQLProject..CovidDeaths
order by 3,4

--select * 
--from SQLProject..CovidVaccinations
--order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from SQLProject..CovidDeaths
order by 1,2

--total case vs total deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage 
from SQLProject..CovidDeaths
where location  like '%state%'
order by 2

-- total cases vs population

select location, date, population, total_cases,  (total_cases/population)*100 as CasePercentage 
from SQLProject..CovidDeaths
where location  like 'India'
order by 5 desc

--country's with highest infecton rate compare to population 

select location,  population, Max(total_cases) as HigestINfectionCount,  max((total_cases/population))*100 as InfectionPercentage 
from SQLProject..CovidDeaths
where location='india'
group by location,population
order by InfectionPercentage desc


--country's with highest Death rate compare to population 

select location, date,  population, Max(total_deaths) as HigestDeathCount,  max((total_deaths/population))*100 as DeathPercentage 
from SQLProject..CovidDeaths
--where location='india'
group by location,population, date
order by population desc

--Countries with highest Deth count per Population

select location,  Max(cast(total_deaths as int)) as TotalDeathcount
from SQLProject..CovidDeaths
--where location='india'
where continent is not null
group by location
order by TotalDeathcount desc


-- By continent

select continent,  Max(cast(total_deaths as int)) as TotalDeathcount
from SQLProject..CovidDeaths
--where location='india'
where continent is not null
group by continent
order by TotalDeathcount desc

 
 -- Global group by date

select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage 
from SQLProject..CovidDeaths
where continent is not null
group by date
order by 1,2

--total global number

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage 
from SQLProject..CovidDeaths
where continent is not null
--group by date
order by 1,2




select *
from SQLProject..CovidDeaths dea
join SQLProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

-- population vs vaccinations


select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
from SQLProject..CovidDeaths dea
join SQLProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where  dea.continent is not null 
and dea.location = 'india'
and vac.new_vaccinations is not null


-- Max vaccination number with date in india

SELECT dea.location, dea.date, dea.population, vac.new_vaccinations
FROM SQLProject..CovidDeaths dea
JOIN SQLProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
    AND dea.location = 'india'
    AND vac.new_vaccinations = (
        SELECT MAX(new_vaccinations)
        FROM SQLProject..CovidVaccinations
        WHERE location = 'india'
    );


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From SQLProject..CovidDeaths dea
Join SQLProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

-- Common table ecpression (CTE) for perform RollingPeopleVaccinated

WITH VaccinationData AS (
    SELECT 
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        ROW_NUMBER() OVER (PARTITION BY dea.location, dea.date ORDER BY dea.date) AS RowNum
    FROM 
        SQLProject..CovidDeaths dea
    JOIN 
        SQLProject..CovidVaccinations vac ON dea.location = vac.location
                                            AND dea.date = vac.date
    WHERE  
        dea.continent IS NOT NULL 
        --AND vac.new_vaccinations IS NOT NULL
)

SELECT 
        continent,
        location,
        date,
        population,
        new_vaccinations,
    SUM(CAST(new_vaccinations AS INT)) OVER (PARTITION BY location ORDER BY date ROWS UNBOUNDED PRECEDING) AS RollingPeopleVaccinated
FROM 
    VaccinationData
WHERE 
    RowNum = 1
ORDER BY 
    location, date;



-- Using CTE to perform Calculation on Partition By in RollingPeopleVaccinated

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From SQLProject..CovidDeaths dea
Join SQLProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
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
From SQLProject..CovidDeaths dea
Join SQLProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated







