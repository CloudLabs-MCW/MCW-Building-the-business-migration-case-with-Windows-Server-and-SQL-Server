## MetaData
Question Type : Single Choice

## Question
When creating the application virtual machine, you chose the subnet intended for virtual machines rather than the one the Managed Instance uses. What would have happened had you chosen the Managed Instance subnet?

## Options
Option 1 : The virtual machine would have been created but unable to reach the database.
Option 2 : The deployment would have failed, because that subnet is delegated to the SQL Managed Instance service.
Option 3 : The virtual machine would have been given a public IP address automatically.
Option 4 : Nothing. Both subnets behave the same way.

## Answers
Option 2 : 5

## Correct Answer Feedback
Correct! A delegated subnet can only host the service it is delegated to. No other resource type can be placed in it, so the deployment would not succeed.

## Incorrect Answer Feedback
That's not correct. A delegated subnet is reserved for one specific service. Review the networking step in Exercise 2 and the subnet layout in the Know Your Resources section.

## Number of Retries
2
