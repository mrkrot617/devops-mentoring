# Grodno DevOps mentoring

Тестовая задача:  
Part #1

1. Используя terraform (https://www.terraform.io/ v1), развернуть в  AWS EC2 инстанс (AMI Amazon Linux 2)
2. Средствами Ansibe (https://www.ansible.com/ v4/5) развернуть на инстансе из первого пункта конфигурацию сервисов, описанную в следующих шагах
3. [Средствами Ansible] На одном из инстансов поднять:  
    a) Jenkins (https://jenkins.io/)
    b) TBD

Part #2

1. Используя terraform развернуть дополнительный инстанс `app-server`
2. Установить и настроить [EC2 Fleet plugin](https://plugins.jenkins.io/ec2-fleet/)
    a) Можно сначала вручную
    b) Автоматизировать установку и настройку плагина при разворачивании Jenkins сервера
4. Создать Jenkins Job([declarative pipeline](https://www.jenkins.io/doc/book/pipeline/syntax/#declarative-pipeline)) которая будет выполнять следующее:  
    a) Создавать динамические Jenkins agents via EC2 Fleet plugin (CentOS)
    b) на Jenkins agent выполнять скрипт, который будет подключаться к `app-server` и устанавливать Java (используя готовую Ansible role https://github.com/lean-delivery/ansible-role-java)
   
Part #3
TBD

Useful links:

* [Pro Git book](https://git-scm.com/book/en/v2)
* [Terraform Best Practices](https://www.terraform-best-practices.com/)
* [Ansible Documentation](https://docs.ansible.com/ansible/latest/)
