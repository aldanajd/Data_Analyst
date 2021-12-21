/* Problems that I faced
1 - Wizard is extremely slow and bugged, had to use LOAD statement which loads as text, therefore had to change the columns datatype
2 - To load the data you have to config MySQL
3 - The String Format: '%m/%d/%Y' must have the 'Y' in uppercase
4 - population.world wouldnt fit, have to be BIGINT
5 - covid_vaccinations.new_vaccinations exceeds the population in some scenarios, which means it counts #N of dose

Note: Developing this project in BIGQUERY was way easier than developing it in MYSQL, would've skipped problems # 1,2,3, 4 and 5,
but BIQUERY is a browser IDE which makes it tough to work with.
*/

USE covid_project;

DROP TABLE IF EXISTS `covid_vaccinations`;
DROP TABLE IF EXISTS `covid_deaths`;

CREATE TABLE `covid_deaths` (
  `iso_code` text,
  `continent` text,
  `location` text,
  `date` text,
  `population` text,
  `total_cases` text,
  `new_cases` text,
  `new_cases_smoothed` text,
  `total_deaths` text,
  `new_deaths` text,
  `new_deaths_smoothed` text,
  `total_cases_per_million` text,
  `new_cases_per_million` text,
  `new_cases_smoothed_per_million` text,
  `total_deaths_per_million` text,
  `new_deaths_per_million` text,
  `new_deaths_smoothed_per_million` text,
  `reproduction_rate` text,
  `icu_patients` text,
  `icu_patients_per_million` text,
  `hosp_patients` text,
  `hosp_patients_per_million` text,
  `weekly_icu_admissions` text,
  `weekly_icu_admissions_per_million` text,
  `weekly_hosp_admissions` text,
  `weekly_hosp_admissions_per_million` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `covid_vaccinations` (
  `iso_code` text,
  `continent` text,
  `location` text,
  `date` text,
  `new_tests` text,
  `total_tests` text,
  `total_tests_per_thousand` text,
  `new_tests_per_thousand` text,
  `new_tests_smoothed` text,
  `new_tests_smoothed_per_thousand` text,
  `positive_rate` text,
  `tests_per_case` text,
  `tests_units` text,
  `total_vaccinations` text,
  `people_vaccinated` text,
  `people_fully_vaccinated` text,
  `total_boosters` text,
  `new_vaccinations` text,
  `new_vaccinations_smoothed` text,
  `total_vaccinations_per_hundred` text,
  `people_vaccinated_per_hundred` text,
  `people_fully_vaccinated_per_hundred` text,
  `total_boosters_per_hundred` text,
  `new_vaccinations_smoothed_per_million` text,
  `new_people_vaccinated_smoothed` text,
  `new_people_vaccinated_smoothed_per_hundred` text,
  `stringency_index` text,
  `population_density` text,
  `median_age` text,
  `aged_65_older` text,
  `aged_70_older` text,
  `gdp_per_capita` text,
  `extreme_poverty` text,
  `cardiovasc_death_rate` text,
  `diabetes_prevalence` text,
  `female_smokers` text,
  `male_smokers` text,
  `handwashing_facilities` text,
  `hospital_beds_per_thousand` text,
  `life_expectancy` text,
  `human_development_index` text,
  `excess_mortality_cumulative_absolute` text,
  `excess_mortality_cumulative` text,
  `excess_mortality` text,
  `excess_mortality_cumulative_per_million` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/* Loading the Data as "Text" because BUG with MySQL Import WIZARD

mysql> SET GLOBAL local_infile=1;
Database > Manage Connection > Advanced Tab > Others > OPT_LOCAL_INFILE=1  
*/

LOAD DATA LOCAL INFILE 'C:/Users/aldan/Desktop/Data Analysis and Science/Data Analysis/Data Analysis Projects/SQL Projects/COVID - Exploration with SQL/covid_deaths.csv'
INTO TABLE covid_deaths FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS; 

LOAD DATA LOCAL INFILE 'C:/Users/aldan/Desktop/Data Analysis and Science/Data Analysis/Data Analysis Projects/SQL Projects/COVID - Exploration with SQL/covid_vaccinations.csv'
INTO TABLE covid_vaccinations FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

### Data Cleaning ###

-- Blanks to Null and String to Date
UPDATE covid_deaths 
	SET 
		date = STR_TO_DATE(date, '%m/%d/%Y'),
        continent = NULLIF(continent, ""),
        population = NULLIF(population, ""),
        total_cases = NULLIF(total_cases, ""),
        new_cases = NULLIF(new_cases, ""),
        new_cases_smoothed = NULLIF(new_cases_smoothed, ""),
        continent = NULLIF(continent, ""),
        total_deaths = NULLIF(total_deaths, ""),
        new_deaths = NULLIF(new_deaths, ""),
        new_deaths_smoothed = NULLIF(new_deaths_smoothed, ""),
        total_cases_per_million = NULLIF(total_cases_per_million, ""),
        new_cases_per_million = NULLIF(new_cases_per_million, ""),
        new_cases_smoothed_per_million = NULLIF(new_cases_smoothed_per_million, ""),
        total_deaths_per_million = NULLIF(total_deaths_per_million, ""),
        new_deaths_per_million = NULLIF(new_deaths_per_million, ""),
        new_deaths_smoothed_per_million = NULLIF(new_deaths_smoothed_per_million, ""),
        reproduction_rate = NULLIF(reproduction_rate, ""),
        icu_patients = NULLIF(icu_patients, ""),
        icu_patients_per_million = NULLIF(icu_patients_per_million, ""),
        hosp_patients = NULLIF(hosp_patients, ""),
        hosp_patients_per_million = NULLIF(hosp_patients_per_million, ""),
        weekly_icu_admissions = NULLIF(weekly_icu_admissions, ""),
        weekly_icu_admissions_per_million = NULLIF(weekly_icu_admissions_per_million, ""),
        weekly_hosp_admissions = NULLIF(weekly_hosp_admissions, ""),
        weekly_hosp_admissions_per_million = NULLIF(weekly_hosp_admissions_per_million, "");

UPDATE covid_vaccinations 
	SET date = STR_TO_DATE(date,'%m/%d/%Y'), 
    new_vaccinations = NULLIF(new_vaccinations,"");
 
-- Changing the Columns Datatype 
ALTER TABLE covid_vaccinations 
    #CHANGE date date DATE DEFAULT NULL,
	CHANGE new_vaccinations new_vaccinations INT DEFAULT NULL;

ALTER TABLE covid_deaths  
	CHANGE date date DATE DEFAULT NULL,
	CHANGE population population BIGINT DEFAULT NULL,
	CHANGE total_cases total_cases INT DEFAULT NULL,
	CHANGE new_cases new_cases INT DEFAULT NULL,
	CHANGE new_cases_smoothed new_cases_smoothed INT DEFAULT NULL,
	CHANGE total_deaths total_deaths INT DEFAULT NULL,
	CHANGE new_deaths new_deaths INT DEFAULT NULL,
	CHANGE new_deaths_smoothed new_deaths_smoothed FLOAT DEFAULT NULL,
	CHANGE total_cases_per_million total_cases_per_million FLOAT DEFAULT NULL,
	CHANGE new_cases_per_million new_cases_per_million FLOAT DEFAULT NULL,
	CHANGE new_cases_smoothed_per_million new_cases_smoothed_per_million FLOAT DEFAULT NULL,
	CHANGE total_deaths_per_million total_deaths_per_million FLOAT DEFAULT NULL,
	CHANGE new_deaths_per_million new_deaths_per_million FLOAT DEFAULT NULL,
	CHANGE new_deaths_smoothed_per_million new_deaths_smoothed_per_million FLOAT DEFAULT NULL,
	CHANGE reproduction_rate reproduction_rate FLOAT DEFAULT NULL,
    CHANGE icu_patients icu_patients FLOAT DEFAULT NULL,
	CHANGE icu_patients_per_million icu_patients_per_million FLOAT DEFAULT NULL,
	CHANGE hosp_patients hosp_patients FLOAT DEFAULT NULL,
	CHANGE hosp_patients_per_million hosp_patients_per_million FLOAT DEFAULT NULL,
	CHANGE weekly_icu_admissions weekly_icu_admissions FLOAT DEFAULT NULL,
	CHANGE weekly_icu_admissions_per_million weekly_icu_admissions_per_million FLOAT DEFAULT NULL,
	CHANGE weekly_hosp_admissions weekly_hosp_admissions MEDIUMINT DEFAULT NULL,
	CHANGE weekly_hosp_admissions_per_million weekly_hosp_admissions_per_million FLOAT DEFAULT NULL;
    
/* Adding and Dropping and Index when Needed. MySQL doesnt auto-index the table
ALTER TABLE covid_deaths ADD COLUMN idx_number INT NOT NULL PRIMARY KEY AUTO_INCREMENT FIRST;
ALTER TABLE covid_deaths DROP idx_number; */

########################### Queries ###########################

(#Select the Data we are going to Use
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid_project.covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1, 2);

(#Death Percentage: Total Deaths vs Total Cases
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM covid_project.covid_deaths
WHERE continent IS NOT NULL
#WHERE location like "%Venezuela%"
ORDER BY location, date);

(#Infected Population Percentage: Total Cases vs Population
SELECT location, date, population, total_cases, CONVERT((total_cases/population)*100, DECIMAL(8,5)) as infected_population_percentage
FROM covid_project.covid_deaths
WHERE continent IS NOT NULL 
#WHERE location like "%Venezuela%"
ORDER BY location, date); 

(#Countries with Highest Infection Rate compared to Population
SELECT location, population, MAX(total_cases) AS highest_infection_count , CONVERT(MAX((total_cases/population)*100), DECIMAL(8,5)) AS infected_population_percentage
FROM covid_project.covid_deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY infected_population_percentage DESC);

(#Countries with Highest Death Count per Population
SELECT location, population, MAX(CAST(total_deaths AS UNSIGNED)) as total_death_count, CONVERT(MAX((total_deaths/population)*100), DECIMAL(8,5)) as death_percentage
FROM covid_project.covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC, location);

(#Total Deaths by Continents with Percentage
SELECT location, population, MAX(CAST(total_deaths AS UNSIGNED)) as total_death_count, CONVERT(MAX((total_deaths/population)*100), DECIMAL(8,5)) as death_percentage
FROM covid_deaths
WHERE continent IS NULL AND location IN ("Europe", "North America", "Asia", "South America", "Oceania", "Africa")
GROUP BY location, population
ORDER BY total_death_count DESC);

(#Breaking Global Numbers
SELECT date, SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, (SUM(new_deaths)/SUM(new_cases))*100 as death_probability
FROM covid_project.covid_deaths
WHERE continent IS NOT NULL
GROUP BY date 
ORDER BY 1, 2 DESC);

#USE Common Table Expressions (CTE) : Rolling Count for Vaccines Applied (Including # of Doses) and the Average Vaccines per Population
WITH PopvsVac (continent, location, date, population, new_vaccinations, vaccines_applied)
AS
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations)
OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS vaccines_applied
FROM covid_project.covid_deaths dea
JOIN covid_project.covid_vaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date

WHERE dea.continent IS NOT NULL
#ORDER BY 2,3
)
SELECT * , (vaccines_applied/population) AS vaccines_applied_per_person 
FROM PopvsVac;

