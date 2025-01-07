DESCRIBE customer_churn;

UPDATE customer_churn
SET Churn_Reason = 'Not Applicable'
WHERE Churn_Reason IS NULL;

UPDATE customer_churn
SET Churn_Category = 'Not Applicable'
WHERE Churn_Category IS NULL;


SELECT * FROM customer_churn LIMIT 10;


SELECT COUNT(*) AS total_rows FROM customer_churn;


SELECT 'Customer ID', COUNT(*)
FROM customer_churn
GROUP BY 'Customer ID'
HAVING COUNT(*) > 1;


SHOW COLUMNS FROM customer_churn;


SELECT 
    'Customer ID' AS Column_Name, 
    COUNT(*) AS Total_Rows, 
    SUM(CASE WHEN 'Customer ID' IS NULL THEN 1 ELSE 0 END) AS Missing_Values
FROM customer_churn
UNION ALL
SELECT 
    'Age' AS Column_Name, 
    COUNT(*) AS Total_Rows, 
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Missing_Values
FROM customer_churn
UNION ALL
SELECT 
    'Subscription Status' AS Column_Name, 
    COUNT(*) AS Total_Rows, 
    SUM(CASE WHEN 'Subscription Status' IS NULL THEN 1 ELSE 0 END) AS Missing_Values
FROM customer_churn;

SELECT COUNT(*) AS 'Missing Values'
FROM customer_churn
WHERE 'Monthly Charge' IS NULL;

SELECT COUNT(*) AS 'Missing Values'
FROM customer_churn
WHERE 'Internet Type' IS NULL;


SHOW COLUMNS FROM customer_churn;

SELECT 
    'Customer Status',
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN 'Customer Status' IS NULL THEN 1 ELSE 0 END) AS Missing_Values
FROM customer_churn
GROUP BY 'Customer Status';

SELECT 
    'Churn Category',
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN 'Churn Category' IS NULL THEN 1 ELSE 0 END) AS Missing_Values
FROM customer_churn
GROUP BY 'Churn Category';


SELECT *
FROM customer_churn
WHERE 'Monthly Charge' IS NULL OR 'Internet Type' IS NULL OR 'Tenure in Months' IS NULL;




UPDATE customer_churn 
SET `Unlimited Data` = CASE 
    WHEN `Unlimited Data` = 'Yes' THEN 1 
    WHEN `Unlimited Data` = 'No' THEN 0 
END;


ALTER TABLE customer_churn ADD Churn_Flag INT;

SET SQL_SAFE_UPDATES = 0;  -- Disable safe updates

UPDATE customer_churn 
SET Churn_Flag = CASE
    WHEN `Customer Status` = 'Churned' THEN 1
    ELSE 0
END
WHERE `Customer ID` IS NOT NULL;  -- Use backticks for the column name

SET SQL_SAFE_UPDATES = 1;


ALTER TABLE customer_churn ADD Tenure_Group VARCHAR(20);

SET SQL_SAFE_UPDATES = 0;

UPDATE customer_churn 
SET Tenure_Group = CASE 
    WHEN `Tenure in Months` <= 12 THEN '0-12 Months' 
    WHEN `Tenure in Months` BETWEEN 13 AND 24 THEN '13-24 Months' 
    WHEN `Tenure in Months` > 24 THEN '24+ Months' 
END;

SET SQL_SAFE_UPDATES = 1;

UPDATE customer_churn
SET `Churn Reason` = 'Not Applicable'
WHERE 'Churn Reason' IS NULL;

UPDATE customer_churn
SET `Churn Category` = 'Not Applicable'
WHERE 'Churn Category' IS NULL;

# Calculate Overall Churn Rate
SELECT 
    COUNT(*) AS 'Total Customers',
    SUM(CASE WHEN Churn_Flag = 1 THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND(SUM(CASE WHEN Churn_Flag = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Churn_Rate
FROM customer_churn;

# Churn Rate by Tenure Group

SELECT Tenure_Group, 
       COUNT(*) AS 'Total Customers', 
       SUM(Churn_Flag) AS 'Churned Customers', 
       ROUND(SUM(Churn_Flag) / COUNT(*) * 100, 2) AS Churn_Rate
FROM customer_churn
GROUP BY Tenure_Group;

#Churn Rate by Internet Type

SELECT 'Internet Type', 
       COUNT(*) AS 'Total Customers', 
       SUM(Churn_Flag) AS 'Churned Customers', 
       ROUND(SUM(Churn_Flag) / COUNT(*) * 100, 2) AS Churn_Rate
FROM customer_churn
GROUP BY 'Internet Type';

# Analyze Monthly Charges
#Monthly Charges Distribution

SELECT 
    'Monthly Charge',
    COUNT(*) AS Customer_Count
FROM customer_churn
GROUP BY 'Monthly Charge'
ORDER BY 'Monthly Charge';

 #Churn Rate by Monthly Charges
 
SELECT CASE
           WHEN 'Monthly Charge' <= 50 THEN 'Low (<= 50)'
           WHEN 'Monthly Charge' BETWEEN 51 AND 100 THEN 'Medium ($51-$100)'
           ELSE 'High (>$100)'
       END AS 'Charge Group',
       COUNT(*) AS 'Total Customers',
       SUM(Churn_Flag) AS Churned_Customers,
       ROUND(SUM(Churn_Flag) / COUNT(*) * 100, 2) AS Churn_Rate
FROM customer_churn
GROUP BY 'Charge Group';

#Analyze Churn by Gender
SELECT 
    Gender,
    COUNT(*) AS Total_Customers,
    SUM(Churn_Flag) AS Churned_Customers,
    ROUND(SUM(Churn_Flag) / COUNT(*) * 100, 2) AS Churn_Rate
FROM customer_churn
GROUP BY Gender;

#  Analyze Churn by Age Group
SELECT 
    CASE 
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 35 THEN '25-35'
        WHEN Age BETWEEN 36 AND 50 THEN '36-50'
        ELSE 'Over 50'
    END AS Age_Group,
    COUNT(*) AS Total_Customers,
    SUM(Churn_Flag) AS Churned_Customers,
    ROUND(SUM(Churn_Flag) / COUNT(*) * 100, 2) AS Churn_Rate
FROM customer_churn
GROUP BY Age_Group;


#Churn Rate by Contract Type
SELECT 
    'Contract Type', 
    COUNT(*) AS Total_Customers, 
    SUM(Churn_Flag) AS Churned_Customers, 
    ROUND(SUM(Churn_Flag) / COUNT(*) * 100, 2) AS Churn_Rate
FROM customer_churn
GROUP BY 'Contract Type';


SELECT 
    Churn_Flag, 
    COUNT(*) AS Count
FROM customer_churn
GROUP BY Churn_Flag;

SELECT DISTINCT Churn_Flag
FROM customer_churn;

SELECT 
    Tenure_Group,
    COUNT(*) AS Total_Customers,
    SUM(Churn_Flag) AS Churned_Customers,
    ROUND(SUM(Churn_Flag) / COUNT(*) * 100, 2) AS Churn_Rate
FROM customer_churn
GROUP BY Tenure_Group
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/churn_by_tenure.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';



##-5.Create a Query to Identify Contract Types Most Prone to Churn



SELECT 
    Contract,
    COUNT(CASE WHEN Churn_Flag = 1 THEN 1 END) AS Churned_Customers,
    COUNT(*) AS Total_Customers,
    ROUND(COUNT(CASE WHEN Churn_Flag = 1 THEN 1 END) / COUNT(*) * 100, 2) AS Churn_Rate_Percentage
FROM customer_churn
GROUP BY Contract
ORDER BY Churn_Rate_Percentage DESC;


#----7. Calculate the Total Charges Distribution for Churned and Non-Churned Customers

SELECT 
    Churn_Flag,
    MIN(`Total Charges`) AS Min_TotalCharges,
    MAX(`Total Charges`) AS Max_TotalCharges,
    AVG(`Total Charges`) AS Avg_TotalCharges,
    SUM(`Total Charges`) AS Total_Sum
FROM customer_churn
GROUP BY Churn_Flag;

##8. Calculate the Average Monthly Charges for Different Contract Types Among Churned Customers


SELECT 
    Contract,
    AVG(`Monthly Charge`) AS Avg_MonthlyCharges
FROM customer_churn
WHERE Churn_Flag = 1
GROUP BY Contract;

# 9.Identify Customers with Both Online Security and Online Backup Services and Have Not Churned

SELECT 
    `Customer ID`
FROM customer_churn
WHERE `Online Security` = 'Yes' AND `Online Backup` = 'Yes' AND Churn_Flag = 0;

# 10. Determine the Most Common Combinations of Services Among Churned Customers

SELECT 
    `Online Security`, `Online Backup`, `Streaming TV`, `Streaming Movies`,
    COUNT(*) AS Count
FROM customer_churn
WHERE Churn_Flag = 1
GROUP BY `Online Security`,`Online Backup`, `Streaming TV`, `Streaming Movies`
ORDER BY Count DESC;

# 13. Determine the Average Age and Total Charges for Customers with Multiple Lines and Online Backup

SELECT 
    AVG(Age) AS AvgAge, 
    AVG(`Total Charges`) AS AvgTotalCharges
FROM customer_churn
WHERE `Multiple Lines` = 'Yes' AND `Online Backup` = 'Yes';

# 14. Identify the Contract Types with the Highest Churn Rate Among Senior Citizens (Age 65 and Over)

SELECT 
    Contract, 
    COUNT(*) AS Total, 
    SUM(CASE WHEN Churn_Flag = 1 THEN 1 ELSE 0 END) AS Churned,
    SUM(CASE WHEN Churn_Flag = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100 AS ChurnRate
FROM customer_churn
WHERE Age >= 65
GROUP BY Contract
ORDER BY ChurnRate DESC;

#15. Calculate the Average Monthly Charges for Customers Who Have Multiple Lines and Streaming TV

SELECT 
    AVG(`Monthly Charge`) AS AvgMonthlyCharges
FROM customer_churn
WHERE `Multiple Lines` = 'Yes' AND `Streaming TV` = 'Yes';

#16. Identify the Customers Who Have Churned and Used the Most Online Services

SELECT 
    `Customer ID`, 
    (CASE WHEN `Online Security` = 'Yes' THEN 1 ELSE 0 END +
     CASE WHEN `Online Backup` = 'Yes' THEN 1 ELSE 0 END +
     CASE WHEN `Device Protection Plan` = 'Yes' THEN 1 ELSE 0 END +
     CASE WHEN `Premium Tech Support` = 'Yes' THEN 1 ELSE 0 END) AS OnlineServicesCount
FROM customer_churn
WHERE Churn_Flag = 1
ORDER BY OnlineServicesCount DESC
LIMIT 10;

#17. Calculate the Average Age and Total Charges for Customers with Different Combinations of Streaming Services

SELECT 
    `Streaming TV`, 
    `Streaming Movies`, 
    AVG(Age) AS AvgAge, 
    AVG(`Total Charges`) AS AvgTotalCharges
FROM customer_churn
GROUP BY `Streaming TV`, `Streaming Movies`;

#18. Identify the Gender Distribution Among Customers Who Have Churned and Are on Yearly Contracts

SELECT 
    Gender, 
    COUNT(*) AS Count
FROM customer_churn
WHERE Churn_Flag = 1 AND Contract = 'One Year' & 'Two year'
GROUP BY Gender;

#19. Average Monthly and Total Charges for Churned Customers Grouped by Contract Type and Internet Service Type

SELECT 
    Contract, 
    `Internet Service`, 
    AVG(`Monthly Charge`) AS AvgMonthlyCharges, 
    AVG(`Total Charges`) AS AvgTotalCharges
FROM customer_churn
WHERE Churn_Flag = 1
GROUP BY Contract, `Internet Service`;

#20. Identify Churned Customers Not Using Online Services and Their Average Total Charges

SELECT 
    AVG(`Total Charges`) AS AvgTotalCharges
FROM customer_churn
WHERE Churn_Flag = 1 AND `Premium Tech Support` = 'No';

#21. Average Monthly and Total Charges for Churned Customers Grouped by Number of Dependents

SELECT 
    `Number of Dependents`, 
    AVG(`Monthly Charge`) AS AvgMonthlyCharges, 
    AVG(`Total Charges`) AS AvgTotalCharges
FROM customer_churn
WHERE Churn_Flag = 1
GROUP BY `Number of Dependents`;

#22. Contract Duration in Months for Churned Customers with Monthly Contracts

SELECT 
    `Customer ID`, 
    `Tenure in Months` AS ContractDurationMonths
FROM customer_churn
WHERE Churn_Flag = 1 AND Contract = 'Month-to-Month';

#23. Determine the Average Age and Total Charges for Customers Who Have Churned, Grouped by Internet Service and Phone Service

SELECT 
    `Internet Service`, 
    `Phone Service`, 
    AVG(Age) AS AvgAge, 
    AVG(`Total Charges`) AS AvgTotalCharges
FROM customer_churn
WHERE Churn_Flag = 1
GROUP BY `Internet Service`, `Phone Service`;

#24. Create a View to Find the Customers with the Highest Monthly Charges in Each Contract Type

CREATE VIEW HighestMonthlyCharges AS
SELECT 
    Contract, 
    `Customer ID`, 
    `Monthly Charge`
FROM customer_churn c1
WHERE `Monthly Charge` = (
    SELECT MAX(`Monthly Charge`)
    FROM customer_churn c2
    WHERE c1.Contract = c2.Contract
);

SELECT * FROM HighestMonthlyCharges ;


#25. Create a View to Identify Customers Who Have Churned and the Average Monthly Charges Compared to the Overall Average

CREATE VIEW ChurnedVsOverallAvg AS
SELECT 
    `Customer ID`, 
    `Monthly Charge`, 
    (SELECT AVG(`Monthly Charge`) FROM customer_churn) AS OverallAvgMonthlyCharges
FROM customer_churn
WHERE Churn_Flag = 1;

SELECT * FROM ChurnedVsOverallAvg;

#26. Create a View to Find the Customers Who Have Churned and Their Cumulative Total Charges Over Time

CREATE VIEW CumulativeTotalCharges AS
SELECT 
    `Customer ID`, 
    `Tenure in Months`, 
    SUM(`Total Charges`) OVER (PARTITION BY `Customer ID` ORDER BY `Tenure in Months`) AS CumulativeTotalCharges
FROM customer_churn
WHERE Churn_Flag = 1;

SELECT * FROM CumulativeTotalCharges;

#27. Stored Procedure to Calculate Churn Rate

DELIMITER $$

CREATE PROCEDURE CalculateChurnRate()
BEGIN
    SELECT 
        (SUM(CASE WHEN Churn_Flag = 1 THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS ChurnRate
    FROM customer_churn;
END $$

DELIMITER ;
CALL CalculateChurnRate();

#28. Stored Procedure to Identify High-Value Customers at Risk of Churning

DELIMITER $$

CREATE PROCEDURE IdentifyHighValueChurnRisk()
BEGIN
    SELECT 
        `Customer ID`, 
        `Total Charges`, 
         `Monthly Charge`, 
        Contract
    FROM customer_churn
    WHERE Churn_Flag = 1 AND `Total Charges` > (
        SELECT AVG(`Total Charges`) FROM customer_churn
    )
    ORDER BY `Total Charges` DESC;
END $$

DELIMITER ;

CALL IdentifyHighValueChurnRisk();
