CREATE DATABASE Portfolio_Project;
USE Portfolio_Project;
select * from Portfolio_Project . covid_deaths
order by 3,4;
-- The data that we are going to be using

select location, date, total_cases, new_cases, total_deaths population 
from Portfolio_Project . covid_deaths
order by 1,2;

-- Looking at total cases vs total deaths
-- shows the likelihood of daying if you contract 
select location, date, total_cases, total_deaths, 
(total_deaths/total_cases)*100 as Death_Percentage
from Portfolio_Project . covid_deaths
where location like '%kingdom%'
order by 1,2;

-- Looking at the total cases vs the population
-- Shows percentage of population got covid

select location, date, population, total_cases, (total_cases/population)*100 as Death_Percentage
from Portfolio_Project . covid_deaths
where location like '%kingdom%'
order by 1,2;

-- Looking at contraies with highest infection rate compared topopulation 

 select location, population, max(total_cases) as Highest_Infection_Count, max((total_cases/population))*100 as Percentage_Population_Infected
from Portfolio_Project . covid_deaths
--  where location like '%kigdom%'
group by location, population
order by Percentage_Population_Infected desc;

-- Showing countries with highest death count per population

 select location, max((total_deaths ))as Total_Death_Count
from Portfolio_Project . covid_deaths
--  where location like '%kigdom%'
where continent is not null
group by location
order by Total_Death_Count desc; 

-- Showing the continants with the highest 

 select continent, max((total_deaths ))as Total_Death_Count
from Portfolio_Project . covid_deaths
--  where location like '%kigdom%'
where continent is not null
group by continent
order by Total_Death_Count desc; 

-- Global Numbers
select date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum((new_deaths)/(new_cases))*100 as Death_Persontage
from Portfolio_Project . covid_deaths
where continent is not null
group by date
order by 1,2;

select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum((new_deaths)/(new_cases))*100 as Death_Persontage
from Portfolio_Project . covid_deaths
where continent is not null
-- group by date;
order by 1,2;

-- Looking at the total population vs vaccinations
 
select * from Portfolio_Project .covid_deaths dea
join Portfolio_Project . covid_vaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date;

select dea.continent, dea.date, dea.location, dea.population, vac.new_vaccinations
from Portfolio_Project . covid_deaths dea
join Portfolio_Project . covid_vaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
order by 1,2;

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (Partition by dea.location order by dea.location, dea.date) 
as Rolling_Peaple_vaccinated
from Portfolio_Project . covid_deaths dea
join Portfolio_Project . covid_vaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
order by 2,3;


-- use cte
with popVSvac (continent, location, date, population, new_vaccinations, 
Rolling_Peaple_vaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (Partition by dea.location order by dea.location, dea.date) 
as Rolling_Peaple_vaccinated
from Portfolio_Project . covid_deaths dea
join Portfolio_Project . covid_vaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
-- order by 2,3
)

select * , (Rolling_Peaple_vaccinated/population)*100
from popVSvac;



-- Time table
drop table if exists Persont_Population_Vaccinated;
create table Persont_Population_Vaccinated
(continent varchar(255),
location varchar(225),
date datetime,
population numeric,
new_vaccinations numeric,
Rolling_Peaple_vaccinated numeric);

select * from Persont_Population_Vaccinated;


insert into Persont_Population_Vaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (Partition by dea.location order by dea.location, 
dea.date) 
as Rolling_Peaple_vaccinated
from Portfolio_Project . covid_deaths dea
join Portfolio_Project . covid_vaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null;
-- order by 2,3;

select * , (Rolling_Peaple_vaccinated/population)*100
from Persont_Population_Vaccinated;


