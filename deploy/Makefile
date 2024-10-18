.PHONY: create setup kubeconfig clean

# Путь к проекту в Windows
WINDOWS_PROJECT_PATH := C:\Users\centaurea\my-cluster-project

# Текущий проект в WSL
CURRENT_PROJECT_PATH := $(shell pwd)

CONFIG_PATH = /home/centaurea/Centaurea_DevOps/deploy/kubeconfig/config
TEMP_CONFIG = $(CONFIG_PATH).tmp

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
        # Выполняем настройку kubeconfig после установки
	$(MAKE) kubeconfig


clean:
	# Удаляем проект в директории Windows
	cmd.exe /C "cd /D $(WINDOWS_PROJECT_PATH) && vagrant destroy -f"
	# Дополнительно можно удалить проект
	rm -rf /mnt/c/Users/centaurea/my-cluster-project/*


kubeconfig: update-config export-kubeconfig


# Замена IP-адреса сервера в конфигурационном файле
update-config:
        # Устанавливаем права доступа к приватному ключу
	chmod 600 /mnt/c/Users/centaurea/my-cluster-project/.vagrant/machines/cluster/virtualbox/private_key
	ssh-keygen -f '/home/centaurea/.ssh/known_hosts' -R '192.168.100.101'
	# Запускаем Ansible плейбук из WSL
	ansible-playbook -i ansible/inventory.ini ansible/playbook_kubeconfig.yml --ssh-extra-args='-o StrictHostKeyChecking=no'

	@echo "Updating server IP in config..."
	sed 's|https://0.0.0.0|https://192.168.100.101|' $(CONFIG_PATH) > $(TEMP_CONFIG) && mv $(TEMP_CONFIG) $(CONFIG_PATH)
	@echo "Server IP updated to https://192.168.100.101:36061"

# Экспорт переменной KUBECONFIG
export-kubeconfig:
	@echo "Exporting KUBECONFIG..."
	export KUBECONFIG=$(CONFIG_PATH)
	@echo "KUBECONFIG set to $(CONFIG_PATH)"
