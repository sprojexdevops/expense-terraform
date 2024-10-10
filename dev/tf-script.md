## Run the below command from main folder to destroy all using script in reverse order of folders
    for i in $(ls -dr */) ; do echo ${i%/}; cd  ${i%/} ; terraform destroy -auto-approve ; cd .. ; done


## Run the below command from main folder to apply all using script in a sequence of folders
    for i in $(ls -d */) ; do echo ${i%/}; cd  ${i%/} ; terraform apply -auto-approve ; cd .. ; done


## Run the below command from main folder to apply all using script in a forward order of selected folders
    for i in 10-vpc 20-sg 35-vpn 40-rds 50-app-alb ; do echo ${i%/}; cd  ${i%/} ; terraform apply -auto-approve ; cd .. ; done

## Run the below command from main folder to destroy all using script in a reverse order of selected folders
    for i in 50-app-alb 40-rds 35-vpn 20-sg 10-vpc ; do echo ${i%/}; cd  ${i%/} ; terraform destroy -auto-approve ; cd .. ; done

> here the main folder is dev and other sub-folders have the tf files, while running the above commands pwd should point to 'dev'

## Resolving the state lock: If there is no other process still running: run this command
    terraform force-unlock <ID of the lock info error>