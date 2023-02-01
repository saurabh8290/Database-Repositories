/******************************************************************
           
Author: Prathivi Raj Singh                
Date: 27/01/2023       
Purpose: Deleting Identical Rows and keeping unique rows with adding ReviewCode column

--EXEC #UniqueRowsRC       
*******************************************************************/



CREATE OR ALTER PROC
	#UniqueRowsRC
AS
BEGIN

WITH xcte AS (
	SELECT top 1500
		MAX(IM.StoneScode) AS StoneScode, 
		PM.ProductConfigurationID, 
		PM.ProductSizeID, 
		PM.ProductColorID, 
		PM.ProductStyleID
	FROM 
		MD_item_master IM
	LEFT JOIN
		MD_Productvariant_Master PM
	ON
		IM.ProductNumber = PM.ProductMasterNumber AND IM.DataAreaID = PM.DataAreaID
	LEFT JOIN
		MD_Product_Hierarchy PH
	ON
		IM.ProductNumber = PH.ProductNumber
	LEFT JOIN
		MD_HierarchyMaster HM
	ON
		PH.ProductCategoryName = HM.CategoryName
	WHERE
		IM.StoneScode NOT IN ('NULL', '')
	AND
		HM.ItemClassId = '2'
	GROUP BY
		IM.StoneScode,
		PM.ProductConfigurationID, 
		PM.ProductSizeID, 
		PM.ProductColorID, 
		PM.ProductStyleID
	HAVING COUNT (IM.StoneScode) > 1
	)

SELECT * INTO #DUP FROM xcte


ALTER TABLE
	#DUP 
ADD ID int IDENTITY(1,1) PRIMARY KEY,
ReviewCode as 'RC' + RIGHT('0000000' + CAST(ID AS varchar(8)), 8);

SELECT 
	StoneScode,
	ProductConfigurationID,
	ProductSizeID,
	ProductColorID,
	ProductStyleID,
	ReviewCode 
FROM
	#DUP
END