--Creating database and accessing it
CREATE DATABASE Laptop_Price

USE Laptop_Price


--Checking if data was imported successfully
SELECT *
FROM laptops_test


--Seeing how many laptops from each brand were used in this study
SELECT Manufacturer, COUNT(Manufacturer) AS Total_laptops
FROM laptops_test
GROUP BY Manufacturer


--Finding how many laptops from each category were used in this study
SELECT Category, COUNT(*) AS Total_Units
FROM laptops_test
GROUP BY Category
ORDER BY 2 DESC


--Finding Average price by manufacturer and category in Rupees
WITH CTE_FixedPrice AS(
	SELECT Manufacturer, Category, (Price/100) AS Fixed_Price
	FROM laptops_test
	)
SELECT Manufacturer, Category, ROUND(AVG(Fixed_Price),2) AS Average_Price
FROM CTE_FixedPrice
GROUP BY Manufacturer, Category
ORDER BY 1,2,3


--Displaying Laptops by User GPU Selection
CREATE PROCEDURE GPUSelect (@GPUName as varchar(50))
AS
BEGIN
	SELECT Manufacturer, Model_Name, Category, Screen_Size,Screen, CPU, RAM, Storage, GPU, Operating_System, Operating_System_Version, Weight,ROUND((Price/100),2) AS Price
	FROM laptops_test
	WHERE GPU LIKE @GPUName
END
GO

EXEC GPUSelect 'AMD%'
EXEC GPUSelect 'Intel%'


SELECT TRIM('GB' FROM RAM) AS Ram_Updated
FROM laptops_test


--How many models each CPU brand provides CPUs for
WITH CTE_CPU_Brand AS(
	SELECT LEFT(CPU, CHARINDEX(' ',CPU) - 1) AS CPU_Brand
	FROM laptops_test
	)
SELECT CPU_Brand, COUNT(*) AS Laptops_Containing
FROM CTE_CPU_BRAND
GROUP BY CPU_Brand
ORDER BY 2 DESC


--Creating a temporary table for gaming laptops for analysis instead of filtering each time
SELECT Manufacturer, Model_Name, Screen_Size, Screen, CPU, TRIM('GB' FROM RAM) AS RAM, Storage, GPU, Operating_System, Operating_System_Version, Weight, ROUND((Price/100),2) AS Price
INTO #temp_gaming_laptops
FROM laptops_test
WHERE Category = 'Gaming'


--Checking if data was successfully loaded into temporary table
SELECT *
FROM #temp_gaming_laptops


--Changing RAM datatype from nvarchar to int to use operations
ALTER TABLE #temp_gaming_laptops
ALTER COLUMN RAM int


--Finding the mode of RAM in gaming laptops
SELECT TOP(1) RAM AS RAM_GB, COUNT(*) AS RAM_Count
FROM #temp_gaming_laptops
GROUP BY RAM
ORDER BY 2 DESC


--Finding the minimum and maximum GB for RAM in gaming laptops
SELECT MIN(RAM)
FROM #temp_gaming_laptops

SELECT MAX(RAM)
FROM #temp_gaming_laptops


--Highest Priced Gaming Laptops by Manufacturer
SELECT Manufacturer, Model_Name, Price
FROM #temp_gaming_laptops
GROUP BY Manufacturer, Model_Name, Price
ORDER BY 1, 3 DESC, 2


--Most popular GPUs for Gaming Laptops
SELECT GPU, COUNT(*) AS Count_of_Laptops
FROM #temp_gaming_laptops
GROUP BY GPU
ORDER BY 2 DESC

