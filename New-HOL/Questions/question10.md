## MetaData
Question Type : Single Choice

## Question
The migrated database reported a compatibility level of 100. What does that tell you?

## Options
Option 1 : The migration failed and fell back to an older database engine.
Option 2 : The database is running in a degraded mode with reduced performance.
Option 3 : The source database's compatibility level was preserved, so queries behave exactly as they did before.
Option 4 : The database must be upgraded before the application can use it.

## Answers
Option 3 : 5

## Correct Answer Feedback
Correct! Level 100 corresponds to SQL Server 2008, and the migration preserved it. That is precisely why the application needs no code changes, and it is the clearest evidence of the compatibility that made Managed Instance the right target.

## Incorrect Answer Feedback
That's not correct. Preserving the compatibility level is intended behaviour rather than a problem. Review the database configuration output in Exercise 2.

## Number of Retries
2
