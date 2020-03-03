info:
	@echo "\nTo release a new version of anything in Comanage that uses multistage builds you will need to:"
	@echo "1) Update the file \".jenkins.template\" with the versions you want" 
	@echo "2) Run \"make release\" to update these versions into \".jenkins.yaml\""
	@echo "3) If the diff looks good, commit and push the new \".jenkins.yaml\" and let the CI build the new version"
	@echo "4) After the CI has built the new version and tagged it you MAY have to download it manually on the machine(s) it should run at. This is easiest to do with \"docker pull <tag>\"\n"

release:
	@perl jenkins_builder.pl < .jenkins.template
	@echo "\n***\nBelow is shown what is substituted into .jenkins.yaml pending git commit & push for it to get snapped by the CI \n***\n"	
	@diff --suppress-common-lines -y .jenkins.yaml .jenkins.template
push:
	git commit -m"New version coming up!\n" .jenkins.yaml
	git push

all: release push
