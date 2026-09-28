## MetaData
Question Type : Single Choice

## Question
You assigned the Storage Blob Data Reader role twice on the storage account. Which of the two assignments does the migration actually depend on?

## Options
Option 1 : The assignment to your own lab user account.
Option 2 : The assignment to the managed identity of the SQL Managed Instance.
Option 3 : Both assignments are equally required.
Option 4 : Neither. The migration service uses its own built-in credentials.

## Answers
Option 2 : 5

## Correct Answer Feedback
Correct! Azure Database Migration Service reads the backup file from blob storage using the Managed Instance's managed identity, not yours. Without that assignment, the migration fails at the data source configuration step.

## Incorrect Answer Feedback
That's not correct. Consider which identity is doing the reading when the backup file is pulled from blob storage. Review the role assignment task in Exercise 1.

## Number of Retries
2
