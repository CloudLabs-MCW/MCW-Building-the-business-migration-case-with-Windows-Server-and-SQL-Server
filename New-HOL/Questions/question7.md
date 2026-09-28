## MetaData
Question Type : Single Choice

## Question
The migration stopped at the status Ready for cutover and did not complete on its own. Why?

## Options
Option 1 : The migration had failed and was waiting to be retried.
Option 2 : The Managed Instance had run out of storage.
Option 3 : Online mode waits for a person to decide when the switch happens.
Option 4 : The backup file was still uploading to blob storage.

## Answers
Option 3 : 5

## Correct Answer Feedback
Correct! Online migrations keep syncing indefinitely until someone completes the cutover. In a real project that moment is agreed with the business rather than chosen by whoever is running the tool.

## Incorrect Answer Feedback
That's not correct. Nothing had gone wrong at that point. Think about who decides the moment an application moves across to a new database.

## Number of Retries
2
