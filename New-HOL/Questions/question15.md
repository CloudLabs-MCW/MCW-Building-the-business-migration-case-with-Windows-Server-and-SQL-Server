## MetaData
Question Type : Single Choice

## Question
The Azure Arc onboarding script had to be run inside the nested virtual machine rather than on the Hyper-V host. Why?

## Options
Option 1 : The Hyper-V host does not have PowerShell installed.
Option 2 : The Hyper-V host is itself an Azure virtual machine, and the Connected Machine agent will not install on Azure virtual machines.
Option 3 : The script requires nested virtualization to be switched off.
Option 4 : The Hyper-V host has no outbound internet access.

## Answers
Option 2 : 5

## Correct Answer Feedback
Correct! Azure virtual machines are already managed by Azure and do not need Azure Arc. The agent detects this and refuses to install, reporting "Cannot install Azure Connected Machine agent on an Azure Virtual Machine."

## Incorrect Answer Feedback
That's not correct. Azure Arc exists to manage servers that are not already in Azure. Consider what the Hyper-V host actually is, and review the important note in Exercise 3.

## Number of Retries
2
