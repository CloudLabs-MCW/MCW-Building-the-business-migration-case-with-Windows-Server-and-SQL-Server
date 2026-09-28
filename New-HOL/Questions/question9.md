## MetaData
Question Type : Single Choice

## Question
The migrated database reported a recovery model of FULL. Why does that matter for the migration you ran?

## Options
Option 1 : FULL recovery is required for Transparent Data Encryption.
Option 2 : Transaction log backups can only be taken from a database in FULL recovery, and those are what kept the target in sync.
Option 3 : Azure SQL Managed Instance only accepts databases in FULL recovery.
Option 4 : It makes the backup file smaller.

## Answers
Option 2 : 5

## Correct Answer Feedback
Correct! An online migration depends on a chain of transaction log backups. A database in SIMPLE recovery cannot produce them, so an online migration would not be possible from it.

## Incorrect Answer Feedback
That's not correct. An online migration depends on a chain of backups being applied continuously. Consider which recovery model can produce that chain.

## Number of Retries
2
