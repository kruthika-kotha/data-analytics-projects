create database Energy_Consumption;
use Energy_Consumption;
select* from consum_3;
select* from country_3;
select* from emission_3;
select* from gdp_3;
select* from population_3;
select* from production_3;

alter table country_3
modify country varchar(50) unique;
alter table emission_3
modify country varchar(50);
alter table consum_3
modify country varchar(50);
alter table gdp_3
modify country varchar(50);
alter table population_3
modify countries varchar(50);
alter table production_3
modify country varchar(50);

DESC COUNTRY_3;
desc emission_3;
desc consum_3;
desc gdp_3;
desc population_3;
desc production_3;

SHOW CREATE TABLE country_3;

ALTER TABLE country_3
DROP PRIMARY KEY ;
alter table country_3
modify CID varchar(50);

ALTER TABLE country_3
ADD PRIMARY KEY (CID);

alter table emission_3
add constraint fk_emission
foreign key (country)
references country_3(country);

select* from emission_3;


alter table CONSUM_3
add constraint fk_consum
foreign key (country)
references country_3(country);


alter table gdp_3
add constraint fk_gdp
foreign key (country)
references country_3(country);


alter table population_3
add constraint fk_pop
foreign key (countries)
references country_3(country);


alter table production_3
add constraint fk_product
foreign key (country)
references country_3(country);


-- GENERAL & COMPARITIVE ANALYSIS
-- 1
select max(year) from emission_3;
select country,sum(emission) as total_emission from 
emission_3 where year =(select max(year) from emission_3)
and emission != 0
group by country
order by total_emission desc
limit 10; 



-- 2 

select max(year) from gdp_3;

alter table gdp_3
rename column Value to gdp_value;

select country,gdp_value from gdp_3
where year= (select max(year) from gdp_3)
order by gdp_value desc
limit 5;

-- 3
select * from production_3;
select * from consum_3;
select p.country,
p.year,
sum(p.production) as total_production,
sum(c.consumption) as total_consumption 
from production_3 p
join consum_3 c
on p.country=c.country
and p.year = c.year
group by p.country,p.year
order by p.country,p.year;

 -- 4
 alter table emission_3
 rename column `energy type` to energy_type;
 
 select energy_type ,sum(emission) as total_emission from emission_3
 group by energy_type 
 order by total_emission desc; 
 
 -- TREND ANALYSIS OVER TIME
 
 
 -- 1
 select year, sum(emission) as total_emission from emission_3
 group by year;
 
-- 2
select country,year,sum(gdp_value) as total_gdp_value from gdp_3
group by country,year
order by  total_gdp_value desc;


-- 3

select p.countries,p.year,sum(p.value) as total_pop,
sum(e.emission) as total_emission from population_3 p
join emission_3 e
on p.countries = e.country
and p.year = e.year
group by p.countries,p.year
order by total_emission desc;

-- 4

select country,year,sum(consumption) as total_energy_consumption from consum_3
group by country,year
having total_energy_consumption >0
order by total_energy_consumption,country ;

-- 5

alter table emission_3
rename column `per capita emission` to per_capita_emission;


select country,year,avg(per_capita_emission) 
from emission_3 
group by country,year 
order by year;

-- RATIO & PER CAPIT ANALYSIS

-- 1
 select e.country,e.year,sum(e.emission) as total_emission,
 sum(g.gdp_value) as total_gdp,
 sum(e.emission)/sum(g.gdp_value) as emission_gdp_ratio 
 from emission_3 e
 join gdp_3 g
 on e.country = g.country
 and e.year = g.year
 group by e.country,e.year
 order by emission_gdp_ratio desc;
 
-- 2 
select c.country,c.year,sum(c.consumption) as total_consumption,
sum(p.value) as totl_pop,
sum(c.consumption)/sum(p.value) as consumption_per_capita
from consum_3 c
join population_3 p
on c.country = p.countries
and c.year = p.year
group by c.country,c.year
order by c.country,c.year;

-- 3

select p.country,p.year,sum(p.production) as total_production,
sum(pop.value) as totl_pop,
sum(p.production)/sum(pop.value) as production_per_capita
from production_3 p
join population_3 as pop
on p.country = pop.countries
and p.year = pop.year
group by p.country,p.year
order by p.country,p.year;



-- 4
select c.country,c.year,sum(c.consumption) as total_consumption,
sum(g.gdp_value) as totl_gdp,
sum(c.consumption)/sum(g.gdp_value) as consumption_gdp
from consum_3 c
join gdp_3 g
on c.country = g.country
and c.year = g.year
group by c.country,c.year
order by consumption_gdp;



-- 5


select g.country,g.year,g.gdp_value, 
sum(p.production) as total_production 
from gdp_3 g 
join production_3 p 
on g.country = p.country
and g.year = p.year
group by g.country, g.year, g.gdp_value
order by g.country, g.year;


-- global comparisons

-- 1

select p.countries,p.year,p.value,
sum(e.emission) as total_emission
from population_3 p
join emission_3 e
on p.countries=e.country
and p.year= e.year
where p.year = 2023
group by p.countries,p.year,p.value
order by p.value desc
limit 10;

-- 2

select e1.country,e1.per_capita_emission as 2020_emission,
e2.per_capita_emission as 2023_emission,
(e1.per_capita_emission - e2.per_capita_emission) as reduction
from emission_3 e1
join emission_3 e2
on e1.country=e2.country
where e1.year=2020
and e2.year=2023
order by reduction desc;

-- 3 
select 
country,
sum(emission) as country_emission,
(sum(emission) / (select sum(emission) from emission_3)) * 100 
as global_share_percent
from emission_3
group by country
order by global_share_percent;


-- 4
select p.year,avg(g.gdp_value) as avg_gdp,
avg(e.emission) as avg_emission,
avg(p.value) as avg_pop
from population_3 p
join emission_3 e
on p.countries = e.country
and p.year = e.year
join gdp_3 g
on p.countries = g.country
and p.year = g.year
group by p.year
order by p.year;

