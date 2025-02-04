# Cleaning Housing Data in SQL
This project focused on cleaning and transforming the Nashville housing dataset using SQL to improve data consistency and usability.
Utilized SQL Joins, Subqueries, Common Table Expressions (CTE), String Functions, and CASE statements to improve the dataset.

**Key Tasks:** 
- Standardized Date Format: Converted and stored sale dates in a proper date format.
- Populated Missing Property Addresses: Used self-joins to fill in missing addresses based on duplicate ParcelIDs.
- Split Address Fields: Extracted street addresses, cities, and states into separate columns for both property and owner addresses.
- Transformed Categorical Data: Converted SoldAsVacant values from 0 and 1 to "Yes" and "No".
- Removed Duplicates: Used ROW_NUMBER() with PARTITION BY to identify and remove duplicate records.
- Dropped Unnecessary Columns: Removed redundant fields to streamline the dataset.
