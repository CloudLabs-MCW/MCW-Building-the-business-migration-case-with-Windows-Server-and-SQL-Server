## MetaData
Question Type : Single Choice

## Question
Your connectivity test to the Managed Instance succeeded on port 1433. What would have been different had the virtual machine been created in its own separate virtual network?

## Options
Option 1 : Nothing. The test would still succeed.
Option 2 : The test would fail, and the database would only be reachable over its public endpoint on port 3342.
Option 3 : The test would succeed, but the connection would be unencrypted.
Option 4 : The virtual machine would need a second network interface.

## Answers
Option 2 : 5

## Correct Answer Feedback
Correct! Port 1433 is the private endpoint, reachable only from inside the same virtual network. From outside it, the only route is the public endpoint, which means exposing the database to the internet.

## Incorrect Answer Feedback
That's not correct. Consider who can reach a private endpoint and who cannot. Review the connectivity test in Exercise 2.

## Number of Retries
2
