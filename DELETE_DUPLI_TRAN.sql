/******************************************************************
           
Author: Prathivi Raj Singh                
Date: 16/01/2023       
Purpose: Removing duplicate ReferenceNo and PaymentTransactionID

--EXEC DELETE_DUPLI_TRAN
*******************************************************************/


CREATE OR ALTER PROC
	DELETE_DUPLI_TRAN
AS
BEGIN
WITH CTE AS (
	SELECT 
		referenceno, 
		PaymentTransactionID
	FROM 
		MD_AMSTransactionDetailReceipt_US
	WHERE 
		PaymentTransactionID NOT IN ('NULL', '')
	UNION ALL
	SELECT 
		referenceno, 
		PaymentTransactionID
	FROM 
		MD_AMSTransactionDetailRefund_US
	WHERE 
		PaymentTransactionID NOT IN ('NULL', '')
),
	duplicate_tran AS (
	SELECT 
		PaymentTransactionID
	FROM 
		CTE
	GROUP BY 
		PaymentTransactionID
	HAVING COUNT(PaymentTransactionID) > 1
)
DELETE FROM 
	MD_AMSTransactionDetailReceipt_US
WHERE 
	PaymentTransactionID IN (
		SELECT 
			PaymentTransactionID 
		FROM 
			duplicate_tran
		)
DELETE FROM 
	MD_AMSTransactionDetailRefund_US
WHERE 
	PaymentTransactionID IN (
		SELECT 
			PaymentTransactionID 
		FROM 
			MD_AMSTransactionDetailRefund_US
		)
END