## MetaData
Question Type : Single Choice

## Question
Tailspin Toys chose Azure SQL Managed Instance rather than Azure SQL Database as the target for the WideWorldImporters migration. What made Managed Instance the right choice?

## Options
Option 1 : It is the cheapest of the Azure SQL deployment options.
Option 2 : It supports SQL Server Agent and cross-database queries, so the application needs no code changes.
Option 3 : It is the only Azure SQL option that provides automated backups.
Option 4 : It was the only Azure SQL option available in the lab region.

## Answers
Option 2 : 5

## Correct Answer Feedback
Correct! Managed Instance keeps the SQL Server engine surface the application depends on, including SQL Server Agent and cross-database queries. Because those features are present, the only change the application needs is its connection string.

## Incorrect Answer Feedback
That's not correct. Revisit the SQL target comparison in the Building the Business Case section, and look at which features Azure SQL Database does not support.

## Number of Retries
2
