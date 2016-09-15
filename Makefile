run-servers:
	cd container; vagrant up; cd ..
composer-update:
	cd application; composer update; cd ..
vagrant-ssh:
	cd container; vagrant ssh
