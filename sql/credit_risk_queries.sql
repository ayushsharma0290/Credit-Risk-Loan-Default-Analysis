USE credit_risk;

-- Q1: Segment-wise default rate (holdout)
SELECT ModelBand,
       COUNT(*)                       AS borrowers,
       SUM(DefaultFlag)               AS defaults,
       ROUND(100*AVG(DefaultFlag), 1) AS default_rate_pct
FROM loan_scored_final
WHERE Eval_Half = 'holdout'
GROUP BY ModelBand
ORDER BY default_rate_pct;

-- Q2: Share of borrowers vs share of defaults
SELECT ModelBand,
       ROUND(100*COUNT(*) / SUM(COUNT(*)) OVER (), 1)                  AS pct_borrowers,
       ROUND(100*SUM(DefaultFlag) / SUM(SUM(DefaultFlag)) OVER (), 1)  AS pct_of_all_defaults
FROM loan_scored_final
WHERE Eval_Half = 'holdout'
GROUP BY ModelBand;

-- Q3: Employment type x segment default rate
SELECT EmploymentType, ModelBand,
       COUNT(*) AS borrowers,
       ROUND(100*AVG(DefaultFlag), 1) AS default_rate_pct
FROM loan_scored_final
WHERE Eval_Half = 'holdout'
GROUP BY EmploymentType, ModelBand
ORDER BY EmploymentType, default_rate_pct;

-- Q4: Default rate by Income Segment and CIBIL band (all rows)
SELECT IncomeSegment, CIBILBand,
       COUNT(*) AS borrowers,
       ROUND(100*AVG(DefaultFlag), 1) AS default_rate_pct
FROM loan_scored_final
GROUP BY IncomeSegment, CIBILBand
ORDER BY default_rate_pct DESC;

-- Q5a: Business impact by band (INR Cr, holdout)
SELECT ModelBand, Action,
       COUNT(*) AS borrowers,
       ROUND(SUM(LoanAmount)/1e7, 2) AS exposure_cr,
       ROUND(SUM(CASE WHEN DefaultFlag = 1 THEN Cost_FN ELSE 0 END)/1e7, 2) AS loss_if_approved_cr,
       ROUND(SUM(CASE WHEN DefaultFlag = 0 THEN Cost_FP ELSE 0 END)/1e7, 2) AS margin_forgone_if_rejected_cr
FROM loan_scored_final
WHERE Eval_Half = 'holdout'
GROUP BY ModelBand, Action;

-- Q5b: Approve-all cost vs policy cost (holdout)
SELECT ROUND(SUM(CASE WHEN DefaultFlag = 1 THEN Cost_FN ELSE 0 END)/1e7, 2) AS approve_all_cost_cr,
       ROUND(SUM(CASE WHEN Action = 'Reject'  AND DefaultFlag = 0 THEN Cost_FP
                      WHEN Action <> 'Reject' AND DefaultFlag = 1 THEN Cost_FN
                      ELSE 0 END)/1e7, 2) AS policy_cost_cr
FROM loan_scored_final
WHERE Eval_Half = 'holdout';

-- Q6: Top 10 riskiest borrower groups (CTE + RANK)
WITH grp AS (
    SELECT EmploymentType, IncomeSegment, CIBILBand,
           COUNT(*) AS borrowers,
           ROUND(100*AVG(DefaultFlag), 1) AS default_rate_pct
    FROM loan_scored_final
    GROUP BY EmploymentType, IncomeSegment, CIBILBand
    HAVING COUNT(*) >= 300
)
SELECT *, RANK() OVER (ORDER BY default_rate_pct DESC) AS risk_rank
FROM grp
ORDER BY risk_rank
LIMIT 10;