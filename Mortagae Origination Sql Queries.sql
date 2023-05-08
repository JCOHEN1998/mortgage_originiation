--Query to calculate the loan approval rate by gender:
SELECT App_Sex, COUNT(*) as Total, SUM(Approved) as Approved,
       CAST(SUM(Approved) as float)/CAST(COUNT(*) as float) as Approval_Rate
FROM [dbo].[mortgage_data]
GROUP BY App_Sex;

--Query to calculate the loan approval rate by ethnicity:
SELECT APP_Eth, COUNT(*) as Total, SUM(Approved) as Approved,
       CAST(SUM(Approved) as float)/CAST(COUNT(*) as float) as Approval_Rate
FROM [dbo].[mortgage_data]
GROUP BY APP_Eth;

--Query to find the approval rate by race:
SELECT APP_Race, 
       COUNT(*) AS Total_Loan_Applications, 
       SUM(CASE WHEN Outcome = 'Originated' THEN 1 ELSE 0 END) AS Approved_Loans,
       100*SUM(CASE WHEN Outcome = 'Originated' THEN 1 ELSE 0 END)/COUNT(*) AS Approval_Rate
FROM [dbo].[mortgage_data]
GROUP BY APP_Race;


--Loan approval rates by state:
SELECT State, 
       COUNT(*) AS Total_Loan_Applications, 
       SUM(CASE WHEN Outcome = 'Originated' THEN 1 ELSE 0 END) AS Approved_Loans,
       100*SUM(CASE WHEN Outcome = 'Originated' THEN 1 ELSE 0 END)/COUNT(*) AS Approval_Rate
FROM [dbo].[mortgage_data]
GROUP BY State;


--Calculates loan application and approval statistics by county.
SELECT County, 
       COUNT(*) AS Total_Loan_Applications, 
       SUM(CASE WHEN Outcome = 'Originated' THEN 1 ELSE 0 END) AS Approved_Loans,
       SUM(CASE WHEN Outcome IN ('Denied', 'Withdraw', 'Incomplete', 'Not Accepted') THEN 1 ELSE 0 END) AS Denied_Loans,
       100*SUM(CASE WHEN Outcome = 'Originated' THEN 1 ELSE 0 END)/COUNT(*) AS Approval_Rate
FROM [dbo].[mortgage_data]
GROUP BY County;

--Loan approval rate by Tract
SELECT Tract, COUNT(*) AS Total_Loan_Applications, 
       SUM(CASE WHEN Outcome = 'Originated' THEN 1 ELSE 0 END) AS Approved_Loans,
       SUM(CASE WHEN Outcome = 'Denied' THEN 1 ELSE 0 END) AS Denied_Loans,
       100*SUM(CASE WHEN Outcome = 'Originated' THEN 1 ELSE 0 END)/COUNT(*) AS Approval_Rate
FROM [dbo].[mortgage_data]
GROUP BY Tract;



--This query will group the loan applications by the loan type, count the total number of applications, sum up the number of approved loans for each loan type, and calculate the approval rate as a percentage for each loan type
WITH loan_counts AS (
    SELECT Type, 
           COUNT(*) AS Total_Loan_Applications, 
           SUM(CASE WHEN Outcome = 'Originated' THEN 1 ELSE 0 END) AS Approved_Loans
    FROM [dbo].[mortgage_data]
    GROUP BY Type
)
SELECT Type, 
       Total_Loan_Applications, 
       Approved_Loans, 
       100*Approved_Loans/Total_Loan_Applications AS Approval_Rate
FROM loan_counts;

--loan type with the highest approval rate:
SELECT TOP(1) Type, 
       COUNT(*) AS Total_Loans, 
       SUM(CASE WHEN Outcome = 'Originated' THEN 1 ELSE 0 END) AS Approved_Loans,
       100*SUM(CASE WHEN Outcome = 'Originated' THEN 1 ELSE 0 END)/COUNT(*) AS Approval_Rate
FROM [dbo].[mortgage_data]
GROUP BY Type
ORDER BY Approval_Rate DESC

--correlation between loan amount and approval rates:
SELECT 
  AVG(Loan_Amount) AS Avg_Loan_Amount,
  COUNT(*) AS Total_Loan_Applications,
  SUM(CASE WHEN Outcome = 'Originated' THEN 1 ELSE 0 END) AS Approved_Loans,
  100 * SUM(CASE WHEN Outcome = 'Originated' THEN 1 ELSE 0 END) / COUNT(*) AS Approval_Rate
FROM [dbo].[mortgage_data]
GROUP BY Type;

--Based on the results of your query, we can see that higher average loan amounts are 
--generally associated with higher approval rates. For example, the loan type with 
--an average loan amount of 184 has an approval rate of 78%, which is higher 
--than the loan type with an average loan amount of 128, which has an approval rate of 76%.