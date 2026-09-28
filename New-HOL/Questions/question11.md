## MetaData
Question Type : Single Choice

## Question
The migrated database reported Not encrypted, even though Azure SQL Managed Instance encrypts databases by default. Why?

## Options
Option 1 : Encryption is only available on the Business Critical service tier.
Option 2 : The default applies to newly created databases. A database restored from an unencrypted backup keeps the source setting.
Option 3 : The migration service disabled encryption during the restore.
Option 4 : The database has to be online for an hour before encryption is applied.

## Answers
Option 2 : 5

## Correct Answer Feedback
Correct! Transparent Data Encryption is on by default for new databases, but a restore preserves whatever the source had. Enabling it is a post-migration step, and a good example of something a checklist catches that an assumption does not.

## Incorrect Answer Feedback
That's not correct. There is a difference between a database that Managed Instance creates and one that it restores from a backup. Review the database configuration output in Exercise 2.

## Number of Retries
2
