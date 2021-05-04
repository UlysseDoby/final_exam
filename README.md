# Github module creation with terraform

## Introduction

The company EPSICorp wants to manage all its github repos (application code, terraform), as well as its users and teams. 

The interest is to have a follow-up of the modifications, and to give autonomy to the teams to add members to a team and teams to repos.

## The needs

* Governance teams want to have a trace of all modifications on github repos, and a saved state of all modifications.
* Security teams want each modification to be traced and validated by a workflow.
* Validation of a change should result in automatic deployment of the changes
* The repository must be configured to use a branch protection

## Tools

The OPS teams have recently been trained on the **Terraform** tool, this tool could meet some of the needs, especially for the autonomy of the teams and the state saving of the repos. 

Concerning validation workflows, **Github actions** is a managed service integrated to github allowing to create simple validation tests, this solution integrated to github will be privileged to limit the multiplication of tools.

## Prerequisites

* Create a github organization with your name [Github doc](https://docs.github.com/en/organizations/collaborating-with-groups-in-organizations/creating-a-new-organization-from-scratch)
* Create a repository in your organization named "github-management
* A working environment with git and terraform (preferably under linux)

## Project

### Terraform module

You will have to write a terraform module allowing the deployment of a github repository, as well as the management of users and groups (team) according to the needs of the company.

#### Minimum Viable Product (MVP)

The MVP version of the module will be the basis of the rating, focus on this part before trying to make it more complex, you should manage at least:

* The creation of a repository in your organization
* Adding github users to your organization
* The management of the teams of the organization (adding users, creation, rights on a repo)
* Enable mandatory branch protection on all repos
* Add variables to configure the repo (visibility, wiki, gitignore, etc)

#### Example of how it works

As a user I need to be able to open a pull request in your github-management and by adding a file like below the repo should be created with the rights on users and teams.

```json
module "repository" {
  source = "./module"

  name = "mysuperapp"

  description = "My super app"

  collaborators = [
    {
      username   = "skhedim"
      permission = "push"
    },
    {
      username   = "linuxtorvalds"
      permission = "pull"
    },
  ]

  teams = [
    {
      name       = "terraform"
      permission = "push"
    },
  ]
}
```

#### Useful informations 
##### Template

To help you to start this repo contains the structure of your module you can copy its content in your repo "github-management" The template contains the structure of the minimal files. 

Obviously you will have to edit the resources and add files for the output, variables etc, this structure just helps you to organize your code.

##### Github provider

For this exercise you will only need the github provider (look at the documentation for the authentication part), all the resources you will need are here [Terraform Github](https://registry.terraform.io/providers/integrations/github/latest/docs)

##### Tests

To test your code as you develop it you can edit the example.tf file at the root of the repo and adapt the module block to the variables needed in your code. Work locally in the repo folder so that when your code works you can commit it directly

##### Functions, loops, and conditionals

To improve your module, it will probably be necessary to use functions to manipulate variables, loops to add a set of users to a repo and conditionals to check if a team exists.

[Conditionals](https://www.terraform.io/docs/language/expressions/conditionals.html)
[Functions](https://www.terraform.io/docs/language/functions/index.html)
[Loops](https://www.terraform.io/docs/language/functions/index.html)

#### Deliverables

You should provide a working module in your terraform-guthub-repository, give member rights to the github skhedim account in your organization. The user should be able to create a PR to add a repo to your organization based on the example provided in the example.tf file

### Workflow

To validate the modifications of a user, especially for the terraform syntax, a validation workflow must test the Pull Request before it is approved and applied by a second workflow.

#### Minimum Viable Product (MVP)

Focus on the MVP for the creation of the workflow before adding additional features. The workflow should support the following features:

* A workflow that starts at the creation of the PR to lint the terraform code, then execute a teraform plan and send the logs of these 2 actions in the Pull Request comments.
* A workflow that starts once the PR is merged to apply the code and create the associated repos.
* The state of what has been deployed (tfstate) must be saved to keep the history of deployments. (use an aws bucket or terraform cloud)

#### Useful information
##### Secrets github

To give the rights to terraform you will need a token that you will have to call in your github workflow actions for that use github secrets to not show any secret in your repo. See the following documentation: [Secrets github](https://docs.github.com/en/actions/reference/encrypted-secrets#creating-encrypted-secrets-for-a-repository)

##### Actions

Hashicorp provides an action to do terraform in github actions, use this action to do different actions requested (lint, plan, apply) the documentation of the module is here [Terraform action](https://github.com/marketplace/actions/hashicorp-setup-terraform)

##### Worflow triggers

You will need 2 workflows that will be started ***on pull_request*** and ***on push*** You can find the documentation here [Workflow events](https://docs.github.com/en/actions/reference/events-that-trigger-workflows#example-using-a-single-event)

#### Deliverables

You will need to create 2 workflows in your github-management as explained above. A user who creates a PR will be able to see the feedback of the workflow as a comment of his PR and this will allow him to correct these errors himself.