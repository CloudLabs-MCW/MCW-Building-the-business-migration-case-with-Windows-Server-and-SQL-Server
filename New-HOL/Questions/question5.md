## MetaData
Question Type : Single Choice

## Question
Why does the target database name have to include your deployment ID?

## Options
Option 1 : Azure requires all database names to be globally unique.
Option 2 : The migration service rejects database names shorter than twenty characters.
Option 3 : The Managed Instance is shared, so the default name would collide with another migration.
Option 4 : The deployment ID is used to derive the database encryption key.

## Answers
Option 3 : 5

## Correct Answer Feedback
Correct! Only one database of a given name can exist on an instance. Adding the deployment ID keeps each migration separate on an instance that more than one person is using.

## Incorrect Answer Feedback
That's not correct. Think about how many databases with the same name a single SQL Managed Instance can hold. Review the data source configuration step in Exercise 1.

## Number of Retries
2
