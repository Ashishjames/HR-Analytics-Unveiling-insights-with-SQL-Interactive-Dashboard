SELECT *
FROM HR_Analytics

-- Data Cleaning & Preprocessing --


SELECT *
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'HR_Analytics' 
--AND COLUMN_NAME = 'Attrition';


-- Removing NULL Values 

DELETE FROM HR_analytics
WHERE YearsWithCurrManager IS NULL;


-- Removing Duplicate Values

WITH CTE AS (
    SELECT EmpID,
           ROW_NUMBER() OVER (PARTITION BY EmpID ORDER BY EmpID) AS rn
    FROM HR_analytics
)

SELECT *
FROM CTE
WHERE rn > 1

DELETE FROM CTE
WHERE rn > 1;


-- Updating Values 

SELECT DISTINCT BusinessTravel
FROM HR_Analytics

UPDATE HR_analytics
SET BusinessTravel = 'Travel_Rarely'
WHERE BusinessTravel = 'TravelRarely';


-- New Column

ALTER TABLE HR_analytics
ADD attrition_count INT;

UPDATE HR_analytics
SET attrition_count = CASE 
                        WHEN attrition = 'Yes' THEN 1
                        ELSE 0
                      END;

SELECT Attrition, attrition_count 
FROM HR_Analytics


-- 1. Total Employees in Company 

SELECT COUNT(EmpID) AS Total_Employees
FROM HR_Analytics

-- 2. Attrition in Company

SELECT SUM(attrition_count) AS Attrition
FROM HR_Analytics

-- 3. Attrition Rate in Company

SELECT ROUND((SUM(attrition_count)*1.0/ COUNT(EmpID)),4)*100 AS Attrition_Rate
FROM HR_Analytics

-- 4. Average Age of Employees in Company

SELECT ROUND(AVG(Age),0) AS Average_Age
FROM HR_Analytics

-- 5. Average Salary of Employees in Company

SELECT ROUND(AVG(MonthlyIncome),0) AS Average_Salary
FROM HR_Analytics


-- 6. Average Years of Employees at Company

SELECT ROUND(AVG(YearsAtCompany),0) AS Average_YearsAtCompany
FROM HR_Analytics

-- 7. Attrition by Gender

SELECT gender, COUNT(*) as Attrition_count
FROM HR_analytics
WHERE attrition = 'Yes'
GROUP BY gender;

-- 8. Attrition by Education Field

SELECT EducationField, COUNT(*) as Attrition_count
FROM HR_analytics
WHERE attrition = 'Yes'
GROUP BY EducationField
ORDER BY Attrition_count DESC;

-- 9. Attrition by YearsAtCompany

SELECT YearsAtCompany, COUNT(*) as Attrition_count
FROM HR_analytics
WHERE attrition = 'Yes'
GROUP BY YearsAtCompany
ORDER BY Attrition_count DESC;

-- 10. Attrition by Salary

SELECT SalarySlab, COUNT(*) as Attrition_count
FROM HR_analytics
WHERE attrition = 'Yes'
GROUP BY SalarySlab
ORDER BY Attrition_count DESC;


-- 11. Attrition by JobRole

SELECT JobRole, COUNT(*) as Attrition_count
FROM HR_analytics
WHERE attrition = 'Yes'
GROUP BY JobRole
ORDER BY Attrition_count DESC;


-- 12. Attrition by Age

SELECT AgeGroup, COUNT(*) as Attrition_count
FROM HR_analytics
WHERE attrition = 'Yes'
GROUP BY AgeGroup
ORDER BY Attrition_count DESC;


-- 13. Average Job Satisfaction Of Employees In Company

SELECT ROUND(AVG(JobSatisfaction),2) AS Job_Satisfaction
FROM HR_analytics

-- 14. Department wise Attrition

SELECT Department, COUNT(*) as Employee_count 
FROM HR_analytics
GROUP BY Department;

SELECT Department, COUNT(*) as Attrition_count 
FROM HR_analytics
WHERE Attrition = 'Yes'
GROUP BY Department
ORDER BY Attrition_count DESC;

-- 15. Over-time Vs Attrition

SELECT OverTime, COUNT(*) as Attrition_count 
FROM HR_analytics
WHERE Attrition = 'Yes'
GROUP BY OverTime
ORDER BY Attrition_count DESC;

-- 16. Promotion Vs Attrition

SELECT YearsSinceLastPromotion, COUNT(*) as Attrition_count 
FROM HR_analytics
WHERE Attrition = 'Yes'
GROUP BY YearsSinceLastPromotion;

-- 17. Distance From Home Vs Attrition 

SELECT DistanceFromHome, COUNT(*) as Attrition_count 
FROM HR_analytics
WHERE Attrition = 'Yes'
GROUP BY DistanceFromHome
ORDER BY Attrition_count DESC;


-- 18. YearsInCurrentRole Vs Attrition

SELECT YearsInCurrentRole, COUNT(*) as Attrition_count 
FROM HR_analytics
WHERE Attrition = 'Yes'
GROUP BY YearsInCurrentRole;

-- 19. Attrition Rate By Department

WITH DepartmentAttrition AS (
    SELECT Department, 
           COUNT(*) AS TotalEmployees,
           SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
           100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS AttritionRate
    FROM HR_analytics
    GROUP BY Department
)
SELECT Department, TotalEmployees, AttritionCount, AttritionRate,
       RANK() OVER (ORDER BY AttritionRate DESC) AS AttritionRank
FROM DepartmentAttrition;


-- 20. Rolling Total Attrition Throughout Years

SELECT YearsAtCompany, 
       COUNT(*) AS AttritionCount,
       SUM(COUNT(*)) OVER (ORDER BY YearsAtCompany) AS RollingAttritionTotal
FROM HR_analytics
WHERE Attrition = 'Yes'
GROUP BY YearsAtCompany
ORDER BY YearsAtCompany;
