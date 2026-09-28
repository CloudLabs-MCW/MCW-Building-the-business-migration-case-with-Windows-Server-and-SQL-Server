## MetaData
Question Type : Single Choice

## Question
Before ticking the checkbox that confirms there are no further log backups to provide, what has to happen in a production migration?

## Options
Option 1 : The target database has to be set to read-only.
Option 2 : Application traffic to the source database has to stop, and a final log backup has to be taken.
Option 3 : The source database has to be deleted.
Option 4 : The Managed Instance has to be restarted.

## Answers
Option 2 : 5

## Correct Answer Feedback
Correct! Any transaction written to the source after the final log backup would be lost. Stopping traffic and taking that last backup is what makes the cutover safe, and it is the part that requires coordination with the business.

## Incorrect Answer Feedback
That's not correct. Think about what happens to a transaction written to the source one second after the last backup was taken. Review the cutover steps in Exercise 1.

## Number of Retries
2
