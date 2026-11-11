CREATE DATABASE IF NOT EXISTS credit_risk;
USE credit_risk;

CREATE TABLE loan_scored_final (
    LoanID            VARCHAR(20) PRIMARY KEY,
    Age               INT,
    Income            DECIMAL(14,2),
    LoanAmount        DECIMAL(14,2),
    InterestRate      DECIMAL(6,2),
    LoanTerm          INT,
    CreditScore       INT,
    DTIRatio          DECIMAL(8,4),
    LoanToIncomeRatio DECIMAL(10,4),
    EMItoIncomeRatio  DECIMAL(10,4),
    EmploymentType    VARCHAR(30),
    IncomeSegment     VARCHAR(30),
    CIBILBand         VARCHAR(20),
    DTIBucket         VARCHAR(30),
    RiskIndex_v2      DECIMAL(10,6),
    RBI_Style_Band    VARCHAR(40),
    DefaultFlag       TINYINT,
    RiskScore         DECIMAL(10,6),
    Cost_FN           DECIMAL(14,2),
    Cost_FP           DECIMAL(14,2),
    ModelBand         VARCHAR(30),
    Action            VARCHAR(30),
    Eval_Half         VARCHAR(20)
);