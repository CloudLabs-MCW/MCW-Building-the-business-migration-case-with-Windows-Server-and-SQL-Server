## MetaData
Question Type : Single Choice

## Question
Which workload would be a better fit for Azure SQL Database than for Azure SQL Managed Instance?

## Options
Option 1 : A database that runs nightly processing through SQL Server Agent jobs.
Option 2 : A database that queries across three other databases on the same instance.
Option 3 : A self-contained database with no Agent jobs and a development team able to make changes.
Option 4 : A database that uses CLR assemblies and linked servers.

## Answers
Option 3 : 5

## Correct Answer Feedback
Correct! Azure SQL Database costs less and requires less management, but it does not support Agent jobs, cross-database queries, CLR, or linked servers. A self-contained database with a team able to adapt it fits well there.

## Incorrect Answer Feedback
That's not correct. Three of these options depend on a feature that Azure SQL Database does not offer. Review the comparison table in the Building the Business Case section.

## Number of Retries
2
