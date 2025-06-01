SELECT * FROM regions
ALTER TABLE regions ADD CONSTRAINT pk_regions PRIMARY KEY (region, country)

DELETE FROM regions WHERE country = 'Burkina'
ALTER TABLE regions ADD COLUMN region_id SERIAL;
ALTER TABLE regions ADD CONSTRAINT pk_regions PRIMARY KEY (region_id)
ALTER TABLE regions ADD FOREIGN KEY (country) REFERENCES countries(country)
--ALTER TABLE regions ADD PRIMARY KEY (region)
ALTER TABLE regions ADD PRIMARY KEY (country)




SELECT * FROM countries 
ALTER TABLE countries ADD PRIMARY KEY (country)
ALTER TABLE countries ADD Foreign KEY (country) REFERENCES regions(country)


SELECT * FROM life_expectancy 
ALTER TABLE life_expectancy ADD PRIMARY KEY (country, year)
ALTER TABLE life_expectancy ADD FOREIGN KEY (country) REFERENCES countries(country);
--ALTER TABLE life_expectancy ADD FOREIGN KEY (country) REFERENCES countries(country)

--ALTER TABLE life_expectancy ADD FOREIGN KEY (country) REFERENCES countries(country);



SELECT * FROM countries_selection 
ALTER TABLE countries_selection ADD PRIMARY KEY (state)
ALTER TABLE countries_selection ADD FOREIGN KEY (state) REFERENCES regions(country);

--ALTER TABLE countries_selection ADD Foreign KEY (state) REFERENCES countries(country);
--ALTER TABLE countries_selection ADD Foreign KEY (state) REFERENCES regions(country);




ALTER TABLE life_expectancy DROP CONSTRAINT life_expectancy_country_fkey

ALTER TABLE regions DROP CONSTRAINT pk_regions
