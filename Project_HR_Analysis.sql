SELECT * FROM adviti_hr_data;

-- Problem Statement 1: Identify Factors Influencing Employee Attrition 
-- Problem Statement 2: Enhance Employee Engagement 

SELECT COUNT(DISTINCT Employee_ID) FROM adviti_hr_data;
-- 628

SELECT DISTINCT Age FROM adviti_hr_data ORDER BY Age;
-- age = 19 to 50
SELECT Age, COUNT(DISTINCT Employee_ID) FROM adviti_hr_data GROUP BY Age; -- frequency table

SELECT Years_of_Service, COUNT(DISTINCT Employee_ID) FROM adviti_hr_data GROUP BY Years_of_Service;

SELECT DISTINCT Position FROM adviti_hr_data WHERE Years_of_Service = 0;

SELECT Position, COUNT(DISTINCT Employee_ID) FROM adviti_hr_data GROUP BY Position;

SELECT Gender, COUNT(DISTINCT Employee_ID) FROM adviti_hr_data GROUP BY Gender;

SELECT Department, COUNT(DISTINCT Employee_ID) FROM adviti_hr_data GROUP BY Department;

SELECT Salary, COUNT(DISTINCT Employee_ID) FROM adviti_hr_data GROUP BY Salary;

SELECT Work_Hours, COUNT(DISTINCT Employee_ID) FROM adviti_hr_data GROUP BY Work_Hours;

SELECT Attrition, COUNT(DISTINCT Employee_ID) FROM adviti_hr_data GROUP BY Attrition;

SELECT Training_Hours, COUNT(DISTINCT Employee_ID) FROM adviti_hr_data GROUP BY Training_Hours;

SELECT Education_Level, COUNT(DISTINCT Employee_ID) FROM adviti_hr_data GROUP BY Education_Level;

SELECT Absenteeism, COUNT(DISTINCT Employee_ID) FROM adviti_hr_data GROUP BY Absenteeism;

SELECT Distance_from_Work, COUNT(DISTINCT Employee_ID) FROM adviti_hr_data GROUP BY Distance_from_Work;

SELECT COUNT(*) FROM adviti_hr_data WHERE Employee_ID is null;

-- CREATE AGE GROUPS
-- CLUB POSITIONS: Account Exec., Account Executive, AccountExec., AccountExecutive
-- CLUB POSITIONS: Content Creator, Creator
-- CLUB POSITIONS: Data Analyst, DataAnalyst
-- CLUB POSITIONS: Analytics Intern, Intern, SE Interns
-- CLUB Gender
-- CREATE SALARY BUCKETS 
-- CREATE TRAINING HOURS CATEGORY
-- CREATE ABSENTEEISM CATEGORY
-- CREATE CATEGORY FOR DISTANCE FROM WORK
-- new columns %JOBSatisfaction and %EmployeeBenefit

CREATE TABLE adviti_hr_data_analysis AS 
SELECT 
Employee_ID,
Employee_Name,
Age,
CASE 
	WHEN Age BETWEEN 21 AND 25 THEN '21-25'
	WHEN Age BETWEEN 26 AND 30 THEN '26-30'
    WHEN Age BETWEEN 31 AND 35 THEN '31-35'
    WHEN Age BETWEEN 36 AND 40 THEN '36-40'
    WHEN Age BETWEEN 41 AND 45 THEN '41-45'
    WHEN Age BETWEEN 46 AND 50 THEN '46-50'
    ELSE '<=20'
END AS AgeGroup,
Years_of_Service,
Position,
CASE 
	WHEN Position IN ('Account Exec.', 'Account Executive', 'AccountExec.', 'AccountExecutive') THEN 'Account Executive'
    WHEN Position IN ('Content Creator', 'Creator') THEN 'Content Creator'
    WHEN Position IN ('DataAnalyst', 'Data Analyst') THEN 'Data Analyst'
    WHEN Position IN ('Analytics Intern', 'Intern', 'SE Interns') THEN 'Interns'
    ELSE Position
END AS Position_updated,
REPLACE(REPLACE(REPLACE(REPLACE(Gender, 'Male', 'M'), 'Female', 'F'), 'M', 'Male'), 'F', 'Female') AS Gender,
CASE 
	WHEN Department = '' THEN 'Management' 
    ELSE Department 
END AS Department,
Salary,
    CASE 
		WHEN Salary >= 5000000 THEN '> 50L'
        WHEN Salary >= 4000000 THEN '40L - 50L'
        WHEN Salary >= 3000000 THEN '30L - 40L'
        WHEN Salary >= 2000000 THEN '20L - 30L'
        WHEN Salary >= 1000000 THEN '10L - 20L' 
        ELSE '< 10L'
	END AS Salary_Buckets,
Performance_Rating,
Work_Hours,
Attrition,
Promotion,
Training_Hours,
CASE 
	WHEN Training_Hours >= 40 THEN '40+ Hours'
	WHEN Training_Hours >= 30 THEN '30 - 40 Hours'
	WHEN Training_Hours >= 20 THEN '20 - 30 Hours'
	WHEN Training_Hours >= 10 THEN '10 - 20 Hours'
	ELSE '< 10 Hours'
END AS Training_Hours_Buckets,
Satisfaction_Score,
Education_Level,
Employee_Engagement_Score,
Absenteeism,
CASE
	WHEN Absenteeism = 0 THEN 'No Leaves'
	WHEN Absenteeism BETWEEN 1 AND 5 THEN '1-5 days'
	WHEN Absenteeism BETWEEN 6 AND 10 THEN '6-10 days'
	WHEN Absenteeism BETWEEN 11 AND 15 THEN '11-15 days'
	ELSE '15+ days'
END AS Absenteeism_Buckets,
Distance_from_Work,
CASE 
	WHEN Distance_from_Work >= 40 THEN '40+ Kms'
	WHEN Distance_from_Work >= 30 THEN '30 - 40 Kms'
	WHEN Distance_from_Work >= 20 THEN '20 - 30 Kms'
	WHEN Distance_from_Work >= 10 THEN '10 - 20 Kms'
	ELSE '< 10 Kms'
END AS Distance_from_Work_Buckets,
JobSatisfaction_PeerRelationship,
JobSatisfaction_WorkLifeBalance,
JobSatisfaction_Compensation,
JobSatisfaction_Management,
JobSatisfaction_JobSecurity,
(JobSatisfaction_PeerRelationship +
JobSatisfaction_WorkLifeBalance +
JobSatisfaction_Compensation +
JobSatisfaction_Management +
JobSatisfaction_JobSecurity)/5*100 AS JobSatisfaction_rate,    
EmployeeBenefit_HealthInsurance,
EmployeeBenefit_PaidLeave,
EmployeeBenefit_RetirementPlan,
EmployeeBenefit_GymMembership,
EmployeeBenefit_ChildCare,
(EmployeeBenefit_HealthInsurance +
EmployeeBenefit_PaidLeave +
EmployeeBenefit_RetirementPlan +
EmployeeBenefit_GymMembership +
EmployeeBenefit_ChildCare)/5*100 AS EmployeeBenefit_Satisfaction_rate
FROM adviti_hr_data;

SELECT MIN(Salary), MAX(Salary) FROM adviti_hr_data;
/*
Salary - 0-10, 11-20, 21-30, 31-40, 40+
Training hours - 10-20, 20-30, .... 40+
absentisem - 0, 1-5, 6-10,..10+
distanct - 0-5, 5-10.. 

SELECT Gender, 
REPLACE(REPLACE(REPLACE(REPLACE(Gender, 'Male', 'M'), 'Female', 'F'), 'M', 'Male'), 'F', 'Female')
FROM adviti_hr_data;

SELECT Department, CASE WHEN Department = '' THEN 'Management' ELSE Department END AS dept
FROM adviti_hr_data;
*/
SELECT *,
    (JobSatisfaction_PeerRelationship +
    JobSatisfaction_WorkLifeBalance +
    JobSatisfaction_Compensation +
    JobSatisfaction_Management +
    JobSatisfaction_JobSecurity) * 100.0 / 5 AS JobSatisfaction_percentage
FROM adviti_hr_data;

SELECT * FROM adviti_hr_data_analysis;

-- Problem Statement 1: Identify Factors Influencing Employee Attrition 
-- To check the total attrition 
SELECT 
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'; 
-- Attrition rate of the company is 48%

-- DEMOGRAPHICS
-- Total Attrition Gender-wise 
SELECT Gender, 
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Gender;
-- There is no effect of Gender on Attriton

-- Age Group
SELECT AgeGroup, 
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY AgeGroup;

SELECT AgeGroup, Years_of_Service,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns' AND AgeGroup='21-25'
GROUP BY AgeGroup, Years_of_Service; 

SELECT AgeGroup, Years_of_Service, Promotion,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns' AND AgeGroup='21-25' AND Promotion='NO'
GROUP BY AgeGroup, Years_of_Service, Promotion; 

-- Distance 
SELECT Distance_from_Work_Buckets, 
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Distance_from_Work_Buckets;

-- Education level
SELECT Education_Level, 
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Education_Level;

-- JOB RELATED FACTORS
-- Position 
SELECT Position_updated, 
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Position_updated
ORDER BY "Attrition_Yes_%" DESC;

-- Department 
SELECT Department, 
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Department
ORDER BY "Attrition_Yes_%" DESC;

-- Salary_Buckets 
SELECT Salary_Buckets, 
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Salary_Buckets
ORDER BY "Attrition_Yes_%" DESC;

SELECT Salary_Buckets, 
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Salary_Buckets
ORDER BY "Attrition_Yes_%" DESC;

-- Promotion 
SELECT Promotion, 
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Promotion
ORDER BY "Attrition_Yes_%" DESC;

SELECT Promotion, Years_of_Service,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns' and Promotion='no'
GROUP BY Promotion, Years_of_Service
ORDER BY "Attrition_Yes_%" DESC;

-- Years of Service
SELECT Years_of_Service, 
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Years_of_Service;

-- Work Hours
SELECT Work_Hours, 
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Work_Hours;

-- Training_Hours_Buckets
SELECT Training_Hours_Buckets, 
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Training_Hours_Buckets;

-- SATISFACTION AND ENGAGEMENT
-- Satisfaction_Score
SELECT Satisfaction_Score, 
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Satisfaction_Score;

-- Employee_Engagement_Score
SELECT Employee_Engagement_Score, 
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Employee_Engagement_Score;

-- JobSatisfaction_rate
SELECT JobSatisfaction_rate, 
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY JobSatisfaction_rate; 

-- PERFORMANCE AND BEHAVIOUR
-- Performance_Rating
SELECT Performance_Rating, 
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Performance_Rating;

-- Absenteeism_Buckets
SELECT Absenteeism_Buckets,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Absenteeism_Buckets;

-- BENEFITS
SELECT EmployeeBenefit_Satisfaction_rate,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY EmployeeBenefit_Satisfaction_rate;


SELECT Satisfaction_Score, 
COUNT(Employee_ID) AS TotalEmployee
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns' AND Years_of_Service = 1 
GROUP BY Satisfaction_Score;

/*
SELECT Satisfaction_Score, 
COUNT(Employee_ID) AS TotalEmployee,
COUNT(Employee_ID)*100/(SELECT COUNT(Employee_ID) FROM adviti_hr_data_analysis WHERE Position_updated <> 'Interns' AND Years_of_Service = 1) AS Percentage
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns' AND Years_of_Service = 1
GROUP BY Satisfaction_Score;

SELECT *, Total_Employee *100/total_sum
FROM (
SELECT *,
SUM(Total_Employee) OVER() AS total_sum
FROM(
SELECT Satisfaction_Score,
COUNT(Employee_ID) AS Total_Employee
FROM adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns'AND Years_of_Service = 1
GROUP BY Satisfaction_Score) d1) d2;
*/

SELECT 
    Satisfaction_score, Department,
    COUNT(Employee_ID) AS Total_employee ,
    (COUNT(Employee_ID) * 100.0 / SUM(COUNT(Employee_ID)) OVER ()) AS PercentageOfTotal
FROM 
    adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns'AND Years_of_Service = 1
GROUP BY 
    Satisfaction_score,Department;

SELECT 
    Performance_Rating, 
    COUNT(Employee_ID) AS Total_employee ,
    (COUNT(Employee_ID) * 100.0 / SUM(COUNT(Employee_ID)) OVER ()) AS PercentageOfTotal
FROM 
    adviti_hr_data_analysis
WHERE Position_Updated <> 'Interns'AND Years_of_Service = 1
GROUP BY 
    Performance_Rating;

-- bivariate
-- Promotion, Years_of_Service
SELECT Promotion, Years_of_Service,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Promotion, Years_of_Service
ORDER BY "Attrition_Yes_%" DESC;

-- avg on promotion
with prom as (SELECT Promotion, Years_of_Service,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS Attrition_Yes_,
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS Attrition_No_
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Promotion, Years_of_Service
ORDER BY "Attrition_Yes_%" DESC)
select Promotion, avg(Attrition_Yes_) from prom group by Promotion
;

SELECT Department, Years_of_Service, Satisfaction_Score,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Department, Years_of_Service, Satisfaction_Score
ORDER BY "Attrition_Yes_%" DESC;

-- Salary_Buckets, Years_of_Service
SELECT Salary_Buckets, Years_of_Service,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Salary_Buckets, Years_of_Service
ORDER BY "Attrition_Yes_%" DESC;

-- Salary and Work hour
SELECT Salary_Buckets, Work_Hours,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns' and Years_of_Service in (3,4,5)
GROUP BY Salary_Buckets, Work_Hours
ORDER BY "Attrition_Yes_%" DESC;

-- Salary_Buckets, Promotion
SELECT Salary_Buckets, Promotion,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Salary_Buckets, Promotion
ORDER BY "Attrition_Yes_%" DESC;

-- Salary_Buckets, Education_Level
SELECT Salary_Buckets, Education_Level,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Salary_Buckets, Education_Level
ORDER BY "Attrition_Yes_%" DESC;

SELECT Salary_Buckets, JobSatisfaction_rate,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Salary_Buckets, JobSatisfaction_rate
ORDER BY "Attrition_Yes_%" DESC;

SELECT Work_Hours, JobSatisfaction_rate,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Work_Hours, JobSatisfaction_rate
ORDER BY "Attrition_Yes_%" DESC;


SELECT Training_Hours_Buckets, JobSatisfaction_rate,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Training_Hours_Buckets, JobSatisfaction_rate
ORDER BY "Attrition_Yes_%" DESC;

SELECT GENDER, AVG(JobSatisfaction_rate)
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY GENDER;


SELECT Work_Hours, Satisfaction_Score,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Work_Hours, Satisfaction_Score
ORDER BY "Attrition_Yes_%" DESC;

SELECT Distance_from_Work_Buckets, Work_Hours,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns' 
GROUP BY Distance_from_Work_Buckets, Work_Hours
ORDER BY "Attrition_Yes_%" DESC;

SELECT Department, Work_Hours, 
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns' 
GROUP BY Department, Work_Hours
ORDER BY "Attrition_Yes_%" DESC;

-- Department, Employee_Engagement_Score
SELECT Department, Employee_Engagement_Score,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS Attrition_Yes_P,
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Department, Employee_Engagement_Score
HAVING Attrition_Yes_P=100
ORDER BY Attrition_Yes_P DESC;
select distinct Department from adviti_hr_data_analysis;


SELECT Performance_Rating, Education_Level,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Performance_Rating, Education_Level
ORDER BY "Attrition_Yes_%" DESC;



--- 3 variables
-- Years_of_Service, Department, Promotion
SELECT Years_of_Service, Department,Promotion,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Years_of_Service,Department,Promotion
ORDER BY "Attrition_Yes_%" DESC;

-- Salary, Years of Service, JobSatisfaction_rate
SELECT Salary_Buckets, Years_of_Service, JobSatisfaction_rate,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Salary_Buckets, Years_of_Service, JobSatisfaction_rate
ORDER BY "Attrition_Yes_%" DESC;

-- Salary, Work Hours, Satisfaction score
SELECT Salary_Buckets, Work_Hours,Satisfaction_Score,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Salary_Buckets, Work_Hours,Satisfaction_Score
ORDER BY "Attrition_Yes_%" DESC;

-- Distance_from_Work_Buckets, Work_Hours, EmployeeBenefit_Satisfaction_rate
SELECT Distance_from_Work_Buckets, Work_Hours,EmployeeBenefit_Satisfaction_rate,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Distance_from_Work_Buckets, Work_Hours,EmployeeBenefit_Satisfaction_rate
ORDER BY "Attrition_Yes_%" DESC;


-- Years_of_Service, Department,Satisfaction_Score
SELECT Years_of_Service, Department, Satisfaction_Score,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Years_of_Service, Department,Satisfaction_Score
HAVING (SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100>=50
ORDER BY "Attrition_Yes_%" DESC;

SELECT Department, AVG(Satisfaction_Score)
FROM (SELECT Years_of_Service, Department, Satisfaction_Score,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Years_of_Service, Department,Satisfaction_Score
HAVING (SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100>=50
ORDER BY "Attrition_Yes_%" DESC) AS A
GROUP BY Department
ORDER BY AVG(Satisfaction_Score);

SELECT Years_of_Service, AVG(Satisfaction_Score)
FROM (SELECT Years_of_Service, Department, Satisfaction_Score,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Years_of_Service, Department,Satisfaction_Score
HAVING (SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100>=50
ORDER BY "Attrition_Yes_%" DESC) AS A
GROUP BY Years_of_Service
ORDER BY AVG(Satisfaction_Score);

-- Department, Employee_Engagement_Score, Absenteeism_Buckets
SELECT Department, Employee_Engagement_Score, Absenteeism_Buckets,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Department, Employee_Engagement_Score, Absenteeism_Buckets
ORDER BY "Attrition_Yes_%" DESC;

SELECT Department, Salary_Buckets, Work_Hours, Years_of_Service, Promotion,Employee_Engagement_Score,JobSatisfaction_rate,EmployeeBenefit_Satisfaction_rate,
COUNT(Employee_ID) AS TotalEmployee,
-- SuM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
-- SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns' and Years_of_Service in (3,4,5) and Promotion='no' AND Employee_Engagement_Score in (1,2,3) -- AND JobSatisfaction_rate in (20,40,60) AND EmployeeBenefit_Satisfaction_rate in (20,40,60)
GROUP BY Department, Salary_Buckets, Work_Hours, Years_of_Service, Promotion,Employee_Engagement_Score,JobSatisfaction_rate,EmployeeBenefit_Satisfaction_rate
ORDER BY "Attrition_Yes_%" DESC;

SELECT Salary_Buckets, Work_Hours, Years_of_Service, Promotion,Employee_Engagement_Score,JobSatisfaction_rate,EmployeeBenefit_Satisfaction_rate,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_Yes_%",
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns' and Years_of_Service in (3,4,5) and Promotion='YES' AND Employee_Engagement_Score in (1,2,3) AND JobSatisfaction_rate in (80,100) AND EmployeeBenefit_Satisfaction_rate in (80,100)
GROUP BY Salary_Buckets, Work_Hours, Years_of_Service, Promotion,Employee_Engagement_Score,JobSatisfaction_rate,EmployeeBenefit_Satisfaction_rate
ORDER BY "Attrition_Yes_%" DESC;

SELECT Employee_Engagement_Score,Attrition_Yes_, COUNT(Absenteeism_Buckets) FROM (SELECT Department, Employee_Engagement_Score,Absenteeism_Buckets,
COUNT(Employee_ID) AS TotalEmployee,
SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)) AS Attrition_Yes,
SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)) AS Attrition_No,
(SUM((CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS Attrition_Yes_,
(SUM((CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END))/COUNT(Employee_ID))*100 AS "Attrition_No_%"
FROM adviti_hr_data_analysis
WHERE Position_updated <> 'Interns'
GROUP BY Department, Employee_Engagement_Score,Absenteeism_Buckets
HAVING Attrition_Yes_<>0.0000
ORDER BY Attrition_Yes_ DESC) AS A
GROUP BY Employee_Engagement_Score, Attrition_Yes_;


-- EMPLOYEE ENGAGEMENT SCORE
-- WITH DEPARTMENT
SELECT Employee_Engagement_Score, Department,
COUNT(Employee_ID) AS TOTAL
FROM adviti_hr_data_analysis
WHERE Position_updated<>'INTERNS' AND Employee_Engagement_Score IN (1,2)
GROUP BY Employee_Engagement_Score, Department;

SELECT Department, SUM(TOTAL) 
FROM (SELECT Employee_Engagement_Score, Department,
		COUNT(Employee_ID) AS TOTAL
		FROM adviti_hr_data_analysis
		WHERE Position_updated<>'INTERNS' AND Employee_Engagement_Score IN (1,2) 
		GROUP BY Employee_Engagement_Score, Department) AS A
GROUP BY Department;

-- Salary_Buckets
SELECT Employee_Engagement_Score, Salary_Buckets,
COUNT(Employee_ID) AS TOTAL
FROM adviti_hr_data_analysis
WHERE Position_updated<>'INTERNS' AND Employee_Engagement_Score IN (1,2)
GROUP BY Employee_Engagement_Score, Salary_Buckets;

-- Employee_Engagement_Score,Department, Salary_Buckets
SELECT Department, Salary_Buckets,
COUNT(Employee_ID) AS TOTAL
FROM adviti_hr_data_analysis
WHERE Position_updated<>'INTERNS' AND Employee_Engagement_Score IN (1,2)
GROUP BY Department, Salary_Buckets;

SELECT Salary_Buckets, SUM(TOTAL) FROM (SELECT Employee_Engagement_Score,Department, Salary_Buckets,
COUNT(Employee_ID) AS TOTAL
FROM adviti_hr_data_analysis
WHERE Position_updated<>'INTERNS' AND Employee_Engagement_Score IN (1,2)
GROUP BY Employee_Engagement_Score,Department, Salary_Buckets)AS S
GROUP BY Salary_Buckets;

-- Absenteeism_Buckets
SELECT Employee_Engagement_Score, Absenteeism_Buckets,
COUNT(Employee_ID) AS TOTAL
FROM adviti_hr_data_analysis
WHERE Position_updated<>'INTERNS' AND Employee_Engagement_Score IN (1,2)
GROUP BY Employee_Engagement_Score, Absenteeism_Buckets;

-- JobSatisfaction_rate
SELECT Employee_Engagement_Score, JobSatisfaction_rate,
COUNT(Employee_ID) AS TOTAL
FROM adviti_hr_data_analysis
WHERE Position_updated<>'INTERNS' 
GROUP BY Employee_Engagement_Score, JobSatisfaction_rate;

SELECT JobSatisfaction_rate, SUM(TOTAL)
FROM(SELECT Employee_Engagement_Score, JobSatisfaction_rate,
COUNT(Employee_ID) AS TOTAL
FROM adviti_hr_data_analysis
WHERE Position_updated<>'INTERNS' 
GROUP BY Employee_Engagement_Score, JobSatisfaction_rate) AS A
WHERE Employee_Engagement_Score IN (1,2)
GROUP BY JobSatisfaction_rate;

SELECT JobSatisfaction_rate, SUM(TOTAL)
FROM(SELECT Employee_Engagement_Score, JobSatisfaction_rate,
COUNT(Employee_ID) AS TOTAL
FROM adviti_hr_data_analysis
WHERE Position_updated<>'INTERNS' 
GROUP BY Employee_Engagement_Score, JobSatisfaction_rate) AS A
WHERE Employee_Engagement_Score IN (3,4,5)
GROUP BY JobSatisfaction_rate;

-- EmployeeBenefit_Satisfaction_rate
SELECT EmployeeBenefit_Satisfaction_rate, Employee_Engagement_Score,
COUNT(Employee_ID) AS TOTAL
FROM adviti_hr_data_analysis
WHERE Position_updated<>'INTERNS' 
GROUP BY EmployeeBenefit_Satisfaction_rate, Employee_Engagement_Score;

SELECT EmployeeBenefit_Satisfaction_rate, SUM(TOTAL)
FROM(SELECT Employee_Engagement_Score, EmployeeBenefit_Satisfaction_rate,
COUNT(Employee_ID) AS TOTAL
FROM adviti_hr_data_analysis
WHERE Position_updated<>'INTERNS' 
GROUP BY Employee_Engagement_Score, EmployeeBenefit_Satisfaction_rate) AS A
WHERE Employee_Engagement_Score IN (1,2,3)
GROUP BY EmployeeBenefit_Satisfaction_rate;

SELECT EmployeeBenefit_Satisfaction_rate, SUM(TOTAL)
FROM(SELECT Employee_Engagement_Score, EmployeeBenefit_Satisfaction_rate,
COUNT(Employee_ID) AS TOTAL
FROM adviti_hr_data_analysis
WHERE Position_updated<>'INTERNS' 
GROUP BY Employee_Engagement_Score, EmployeeBenefit_Satisfaction_rate) AS A
WHERE Employee_Engagement_Score IN (4,5)
GROUP BY EmployeeBenefit_Satisfaction_rate;

-- Training_Hours_Buckets
SELECT Training_Hours_Buckets, Employee_Engagement_Score,
COUNT(Employee_ID) AS TOTAL
FROM adviti_hr_data_analysis
WHERE Position_updated<>'INTERNS' 
GROUP BY Training_Hours_Buckets, Employee_Engagement_Score;

SELECT Training_Hours_Buckets, SUM(TOTAL)
FROM(SELECT Employee_Engagement_Score, Training_Hours_Buckets,
COUNT(Employee_ID) AS TOTAL
FROM adviti_hr_data_analysis
WHERE Position_updated<>'INTERNS' 
GROUP BY Employee_Engagement_Score, Training_Hours_Buckets) AS A
WHERE Employee_Engagement_Score IN (1,2,3)
GROUP BY Training_Hours_Buckets;

SELECT Training_Hours_Buckets, SUM(TOTAL)
FROM(SELECT Employee_Engagement_Score, Training_Hours_Buckets,
COUNT(Employee_ID) AS TOTAL
FROM adviti_hr_data_analysis
WHERE Position_updated<>'INTERNS' 
GROUP BY Employee_Engagement_Score, Training_Hours_Buckets) AS A
WHERE Employee_Engagement_Score IN (4,5)
GROUP BY Training_Hours_Buckets;

-- Work_Hours
SELECT Work_Hours, Employee_Engagement_Score,
COUNT(Employee_ID) AS TOTAL
FROM adviti_hr_data_analysis
WHERE Position_updated<>'INTERNS' 
GROUP BY Work_Hours, Employee_Engagement_Score;

SELECT Work_Hours, SUM(TOTAL)
FROM(SELECT Employee_Engagement_Score, Work_Hours,
COUNT(Employee_ID) AS TOTAL
FROM adviti_hr_data_analysis
WHERE Position_updated<>'INTERNS' 
GROUP BY Employee_Engagement_Score, Work_Hours) AS A
WHERE Employee_Engagement_Score IN (4,5)
GROUP BY Work_Hours;

SELECT Work_Hours, SUM(TOTAL)
FROM(SELECT Employee_Engagement_Score, Work_Hours,
COUNT(Employee_ID) AS TOTAL
FROM adviti_hr_data_analysis
WHERE Position_updated<>'INTERNS' 
GROUP BY Employee_Engagement_Score, Work_Hours) AS A
WHERE Employee_Engagement_Score IN (1,2,3)
GROUP BY Work_Hours;
