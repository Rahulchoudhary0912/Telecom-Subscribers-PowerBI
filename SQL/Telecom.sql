
CREATE DATABASE powerbi;

use powerbi;
#table creation 


CREATE TABLE telecom_raw (
    country VARCHAR(50),
    state VARCHAR(100),
    year INT,
    month DATE,
    telecom_circle VARCHAR(100),
    service_provider VARCHAR(150),
    wireless DECIMAL(20,6),
    vlr_peak_percent DECIMAL(15,9),
    wireline DECIMAL(20,6)
);

#describe the table
DESCRIBE telecom_raw;

#load the data 

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/telecom_clean.csv'
INTO TABLE telecom_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    country,
    state,
    year,
    month,
    telecom_circle,
    service_provider,
    @wireless,
    @vlr,
    @wireline
)
SET
    wireless = NULLIF(TRIM(@wireless), ''),
    vlr_peak_percent = NULLIF(TRIM(@vlr), ''),
    wireline = NULLIF(TRIM(@wireline), '');
    
#total records 
SELECT COUNT(*) AS total_rows
FROM telecom_raw;
    
    
# viewing the data till 10 rows 
SELECT *
FROM telecom_raw
LIMIT 10;


#distinct states
SELECT DISTINCT state
FROM telecom_raw;


# DISTINCT service_provider
SELECT DISTINCT service_provider
FROM telecom_raw;

# viewing the years
SELECT DISTINCT year
FROM telecom_raw
ORDER BY year;

#Check the total Wireless subscribers
SELECT
    SUM(wireless) AS total_wireless
FROM telecom_raw;

#Total Wireline subscribers
SELECT
    SUM(wireline) AS total_wireline
FROM telecom_raw;

#Total subscribers
SELECT
    SUM(wireless) + SUM(wireline) AS total_subscribers
FROM telecom_raw;

#Wireless subscribers in each state

SELECT
    state,
    SUM(wireless) AS total_wireless
FROM telecom_raw
GROUP BY state;


#Wireline subscribers in each state
SELECT
    state,
    SUM(wireline) AS total_wireline
FROM telecom_raw
GROUP BY state;

#State-wise Total Subscribers
SELECT
    state,
    SUM(wireless) + SUM(wireline) AS total_subscribers
FROM telecom_raw
GROUP BY state;


#Top 5 states
SELECT
    state,
    SUM(wireless) + SUM(wireline) AS total_subscribers
FROM telecom_raw
GROUP BY state
ORDER BY total_subscribers DESC
LIMIT 5;


#State-wise Average VLR

SELECT
    state,
    AVG(vlr_peak_percent) AS avg_vlr
FROM telecom_raw
GROUP BY state
ORDER BY avg_vlr DESC;


# selected state 
SELECT *
FROM telecom_raw
WHERE state = 'Karnataka';

# selected state total users
SELECT
    SUM(wireless) AS total_wireless
FROM telecom_raw
WHERE state = 'Karnataka';


#GROUP BY Provider
SELECT
    service_provider,
    SUM(wireless) AS total_wireless
FROM telecom_raw
GROUP BY service_provider
ORDER BY total_wireless DESC;

#Provider Total Users
SELECT
    service_provider,
    SUM(wireless) + SUM(wireline) AS total_users
FROM telecom_raw
GROUP BY service_provider
ORDER BY total_users DESC;