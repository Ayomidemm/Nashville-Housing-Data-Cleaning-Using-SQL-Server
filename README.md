# Nashville Housing Data Cleaning Using SQL Server

## 📌 Project Overview

This project focuses on cleaning and preparing the Nashville Housing dataset using Microsoft SQL Server and T-SQL. The objective is to improve data consistency, handle missing property addresses, standardise values, separate address fields into meaningful components, and prepare the dataset for further analysis.

The project demonstrates practical SQL data-cleaning techniques used to transform raw data into a more structured and analysis-ready format.

## 🎯 Business Problem

Raw datasets often contain missing values, inconsistent formats, duplicate records, and columns that are not suitable for direct analysis. These issues can affect the reliability of reporting and lead to inaccurate conclusions.

The Nashville Housing Data Cleaning project addresses these challenges by applying SQL queries and table modifications to improve the structure and consistency of housing transaction data.

## 🎯 Project Objectives

- Create a dedicated database for the project.
- Inspect the imported Nashville Housing dataset.
- Populate missing property addresses using matching parcel IDs.
- Separate property addresses into street address and city fields.
- Split owner address information into address, city, and state components.
- Standardise `SoldAsVacant` values from `Y` and `N` to `Yes` and `No`.
- Identify potential duplicate records.
- Remove columns considered unnecessary for the intended analysis.
- Validate the results of data-cleaning operations.

## 🛠️ Tools & Technologies

- **Microsoft SQL Server:** Database creation, storage, and data manipulation.
- **SQL Server Management Studio (SSMS):** Executing queries and inspecting results.
- **T-SQL:** Data cleaning, filtering, updating, string manipulation, and table modification.

## 🧹 Data Cleaning Process

### 1. Database Creation and Data Inspection

The project begins by creating a database named `ProjectDB` and inspecting the imported Nashville Housing dataset.

```sql
CREATE DATABASE ProjectDB;

SELECT *
FROM [Nashville Housing Data];
```

This initial inspection provides an overview of the dataset before applying cleaning operations.

### 2. Populating Missing Property Addresses

Some records contain missing values in the `PropertyAddress` column. The script uses a self-join on `ParcelID` to locate matching records with an available property address.

The `ISNULL()` function is then used to populate missing addresses where a matching record is found.

This approach helps recover available address information without manually entering values.

### 3. Splitting Property Addresses

The `PropertyAddress` field contains address information separated by a comma. The script creates two additional columns:

- `PropertySplitAddress`
- `PropertyCity`

The `SUBSTRING()`, `CHARINDEX()`, and `LEN()` functions are used to separate the property address from the city.

This transformation makes the information easier to organise and analyse by location.

### 4. Splitting Owner Addresses

The script introduces three columns for storing owner address information separately:

- `Owners_Address`
- `Owners_Address_City`
- `Owners_Address_State`

The `REPLACE()` and `PARSENAME()` functions are used to separate the comma-delimited address components.

Separating these fields improves the structure of the address data and supports more flexible filtering and grouping.

### 5. Standardising SoldAsVacant Values

The `SoldAsVacant` column contains abbreviated values such as `Y` and `N`.

A `CASE` expression is used to standardise these values:

- `Y` becomes `Yes`.
- `N` becomes `No`.
- Other values are retained.

The script also checks the distinct values before and after the update to help validate the transformation.

### 6. Identifying Potential Duplicate Records

The script uses a Common Table Expression (CTE) and the `ROW_NUMBER()` window function to identify records that share the selected combination of fields:

- `ParcelID`
- `PropertyAddress`
- `SaleDate`
- `LegalReference`

Records are ordered by `UniqueID`, allowing subsequent occurrences within each matching group to be flagged with a row number greater than one.

This step provides a method for investigating potential duplicate records before deciding which records should be removed.

**Note:** The current script identifies potential duplicates but does not yet delete them.

### 7. Removing Unused Columns

The final cleaning operation drops the following columns:

- `PropertyAddress`
- `OwnerAddress`
- `TaxDistrict`

The intention is to remove the original address fields after creating separate address components and to remove a column considered unnecessary for the intended analysis.

The script then retrieves the resulting table for inspection.

## 🧠 SQL Concepts Demonstrated

This project applies several practical SQL techniques:

| SQL Concept | Application |
|---|---|
| `CREATE DATABASE` | Creating the project database |
| `SELECT` | Inspecting and validating records |
| `JOIN` | Matching records to populate missing addresses |
| `ISNULL()` | Replacing missing property addresses with available values |
| `UPDATE` | Modifying existing records |
| `ALTER TABLE` | Adding and dropping columns |
| `SUBSTRING()` | Extracting address components |
| `CHARINDEX()` | Locating delimiters within strings |
| `LEN()` | Determining string length |
| `REPLACE()` | Replacing commas with periods for parsing |
| `PARSENAME()` | Extracting separated address components |
| `CASE` | Standardising categorical values |
| `GROUP BY` | Summarising distinct categories |
| `ROW_NUMBER()` | Assigning row numbers to potential duplicate groups |
| CTE | Organising the duplicate-identification query |

## 📋 Data Quality Considerations

The script demonstrates several important data-cleaning practices, including handling missing information, standardising categorical values, restructuring address fields, and identifying potential duplicates.

For reliable results, address parsing should be checked against the original values, duplicate records should be reviewed before deletion, and the final table should be validated against the intended analysis requirements.

## ⚠️ Limitations and Validation

The SQL script represents a practical data-cleaning workflow, but a few operations require further validation:

- The owner-address assignments should be corrected and checked to ensure that street address, city, and state are stored in their intended columns.
- The duplicate-identification query should be followed by a deliberate deletion step if removing duplicates is required.
- Address splitting should be validated for missing commas and inconsistent address formats.
- Dropping original columns should only occur after confirming that the replacement fields contain the required information.
- The final dataset should be checked for remaining missing values, unexpected categories, and duplicate records.

These checks are important because a successful SQL execution does not automatically guarantee that every transformation produced the intended result.

## 🏁 Conclusion

The Nashville Housing Data Cleaning project demonstrates how SQL Server can be used to prepare raw housing data through structured queries and data manipulation techniques.

By working with missing values, address parsing, categorical standardisation, duplicate identification, and column management, the project builds practical experience in preparing datasets for reliable analysis.

It also highlights the importance of validating transformations and reviewing data quality before using a cleaned dataset for reporting or decision-making.

---

**Project Category:** Data Analytics  
**Project Focus:** SQL Data Cleaning and Transformation  
**Database Platform:** Microsoft SQL Server  
**Language:** T-SQL  
**Dataset:** Nashville Housing Data
