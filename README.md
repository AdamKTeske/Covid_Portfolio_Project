# Covid Data Exploration 

## Introduction

This project is an in-depth exploration of ourworldindata.org’s open-source data on COVID infection rates, death rates, and vaccination rates across the globe. 
I used SQL to clean, filter, and separate the data and then imported the individual queries into Tableau for visualization.

![Dashboard.png](https://github.com/AdamKTeske/Covid_Portfolio_Project/blob/main/Covid%20Dashboard.png)

## Exploration

### Total Cases vs Total Deaths
Simple percentage calculation inside SELECT statement.
- Found that the US started with a fatality rate of 10%, and hovered around 5-6% for several weeks before eventually dropping down to 1-2% for the remainder of 2020. 

### Total Cases vs Population
Simple percentage calculation inside SELECT statement.
- US has shockingly high case percentage compared to population, with 10% of all people infected by 2021.
- Brazil and Mexico also had very large numbers of infected people, but their rate of infection compared to their population was not as high as the US.

### Countries with Highest Infection Rate by Population
Percentage calculation and group by statement for country
- The highest infection rate was Andorra, with a staggering 17%. 
- United States trails close behind at number 9, right behind Serbia and Bahrain.

### Countries / Continents Death Toll
MAX(total deaths) in SELECT statement. Had to recast datatype to integer and exclude all “locations” that aren’t explicitly countries.
- United States has most cases (27 million), followed by Brazil, Mexico, and India. 
- Out of all the continents, Europe actually has the most cases but North and South America are not far behind.

### Global Death Percentages
Multiple SUM cases to get total cases, total deaths, and calculate death percentage
- Found that global fatality rate was around 2.1% by April of 2021.


### Total Population vs Vaccinations
Performed left join to combine the deaths and vaccinations datasets. Used date as key. Used OVER to get a running total of vaccinations.
- Most vaccinations started between November of 2020 and March 2021


### Total Population Vaccination Rates
Used CTE to perform calculation on the partition in previous query.
- Vaccination rate in US exploded in 2021, hitting 50% of the population (150,000,000) by June. 



## Post Analysis
- Created view to store data for visualizations
- Saved new data to CSV files
- Created new Tableau dashboard using my findings.
