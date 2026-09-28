## MetaData
Question Type : Single Choice

## Question
The application virtual machine has no public IP address, and you reached it through Azure Bastion. What does that achieve?

## Options
Option 1 : It reduces the cost of running the virtual machine.
Option 2 : It allows more than one administrator to connect at the same time.
Option 3 : Port 3389 is never exposed to the internet, so there is nothing for an attacker to find.
Option 4 : It encrypts the virtual machine's managed disks.

## Answers
Option 3 : 5

## Correct Answer Feedback
Correct! Bastion delivers the session over HTTPS from inside the Azure portal. An exposed RDP port is one of the most commonly attacked entry points on a server, and this removes it entirely.

## Incorrect Answer Feedback
That's not correct. Think about what an attacker scanning the internet would find for this server, compared with a server that has RDP open. Review the Bastion connection task in Exercise 2.

## Number of Retries
2
