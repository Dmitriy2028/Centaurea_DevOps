.PHONY: create setup clean

# Путь к проекту в Windows
WINDOWS_PROJECT_PATH := C:\Users\centaurea\my-cluster-project

# Текущий проект в WSL
CURRENT_PROJECT_PATH := $(shell pwd)

create:
	# Создаем директорию, если она не существует
	mkdir -p /mnt/c/Users/centaurea/my-cluster-project
	# Копируем текущий проект в директорию Windows
	cp -r $(CURRENT_PROJECT_PATH)/* /mnt/c/Users/centaurea/my-cluster-project/
	# Переходим в Windows и запускаем Vagrant
	cmd.exe /C "cd /D $(WINDOWS_PROJECT_PATH) && vagrant up --provider=virtualbox"

setup:
	# Устанавливаем права доступа к приватному ключу
	chmod 600 /mnt/c/Users/centaurea/my-cluster-project/.vagrant/machines/cluster/virtualbox/private_key
	ssh-keygen -f '/home/centaurea/.ssh/known_hosts' -R '192.168.100.101'
	# Запускаем Ansible плейбук из WSL
	ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --ssh-extra-args='-o StrictHostKeyChecking=no'

clean:
	# Удаляем проект в директории Windows
	cmd.exe /C "cd /D $(WINDOWS_PROJECT_PATH) && vagrant destroy -f"
	# Дополнительно можно удалить проект
	rm -rf /mnt/c/Users/centaurea/my-cluster-project/*
