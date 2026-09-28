## MetaData
Question Type : Single Choice

## Question
You selected Online rather than Offline as the migration mode. What does that change?

## Options
Option 1 : The migration completes faster.
Option 2 : The source database stays available, and the service keeps syncing until you complete the cutover.
Option 3 : The backup is read from blob storage rather than from a file share.
Option 4 : The target database is created as read-only.

## Answers
Option 2 : 5

## Correct Answer Feedback
Correct! Online mode restores the full backup and then keeps applying log backups. The source database stays in use, and downtime is limited to the cutover itself.

## Incorrect Answer Feedback
That's not correct. The difference is in what the source database is doing during the migration, not in how quickly it finishes. Review the migration mode selection in Exercise 1.

## Number of Retries
2
