**SQL Data Cleaning Project**

This repository contains SQL scripts for cleaning and standardizing data in the Nashville Housing dataset. The aim is to ensure data consistency, accuracy, and readiness for further analysis or reporting.

**Table of Contents**
- [Introduction]
- [Contents]
- [Installation]
- [Usage]
- [Data Cleaning Steps]
  - [Standardize Date Format]
  - [Handle Null Property Addresses]
  - [Break Out Address into Individual Columns]
- [Contributing]


## Introduction

This project focuses on data cleaning tasks for a Nashville Housing dataset, ensuring that the data is consistent and ready for further analysis.

## Contents

- **SQLDataCleaning.sql**: Main SQL script that performs various data cleaning operations on the Nashville Housing dataset.

## Installation

1. Clone the repository to your local machine:
   ```bash
   git clone https://github.com/yourusername/SQLDataCleaningProject.git

Ensure you have a SQL Server environment set up where you can execute the script.   

**Data Cleaning Steps**

*Standardize Date Format*

This step involves using ALTER TABLE to add a new column and UPDATE to convert date values using CONVERT() to ensure a standardized date format.

```
ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE SQLProject..NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate);
```

*Handle Null Property Addresses*

In this step, the script uses SELECT to identify rows with null values and UPDATE with JOIN to set these values based on related rows, ensuring that null addresses are filled.

```
SELECT * 
FROM SQLProject..NashvilleHousing 
WHERE PropertyAddress IS NULL;

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM SQLProject..NashvilleHousing a
JOIN SQLProject..NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;
```

*Break Out Address into Individual Columns*

Property Address
The script uses ALTER TABLE to add new columns and UPDATE with SUBSTRING() and CHARINDEX() to split the address into separate columns.
```
ALTER TABLE SQLProject..NashvilleHousing
ADD PropertySpiltAddress NVARCHAR(255), PropertySpiltCity NVARCHAR(255);

UPDATE SQLProject..NashvilleHousing
SET PropertySpiltAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1);

UPDATE SQLProject..NashvilleHousing
SET PropertySpiltCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));
```

*Owner Address*

Similarly, the script employs ALTER TABLE to add new columns and UPDATE with SUBSTRING() and CHARINDEX() to split the owner address into individual components.
```
ALTER TABLE SQLProject..NashvilleHousing
ADD OwnerSpiltAddress NVARCHAR(255), OwnerSpiltCity NVARCHAR(255);

UPDATE SQLProject..NashvilleHousing
SET OwnerSpiltAddress = SUBSTRING(OwnerAddress, 1, CHARINDEX(',', OwnerAddress) - 1);

UPDATE SQLProject..NashvilleHousing
SET OwnerSpiltCity = SUBSTRING(OwnerAddress, CHARINDEX(',', OwnerAddress) + 1, LEN(OwnerAddress));
```

**Contributing**
If you would like to contribute to this project, please fork the repository and submit a pull request. For major changes, please open an issue first to discuss what you would like to change.

