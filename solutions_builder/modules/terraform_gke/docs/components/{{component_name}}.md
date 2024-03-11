# Module: Terraform GKE Stage

This module defines a Terraform GKE setup stage named "3-gke".

Main components after setup:
- ./terraform/stage/3-gke

## Setup

Run `sb components add [COMPONENT_NAME]` to add this module.
```
cd my-solution-folder
sb components add terraform_gke .
```

Fill in the variables.
```
🎤 What is the name of this terraform stage?
   3-gke
🎤 Which Google Cloud region?
   us-central1
🎤 Kubernetes version?
   latest
🎤 Allow domains for CORS? (comma-seperated)
   http://localhost:4200,http://localhost:3000
🎤 Cert Issuer Email
   my_name@example.com

...

Complete. Component terraform_gke added to solution at .
```

Initialize the terraform stage using `st init --stage=[STAGE_NAME]`
```
sb init --stage=3-gke
```

## Development

## FAQ


