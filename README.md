autobuildadhoc
==============

Description aboun automatization build ad-hoc app with xcode and send build on amazon s3

##Настройка среды вне Xcode
#####terminal-notifier
Открывает terminal.app и ставим terminal-notifier для того чтобы получать уведомления о ходе выполнения процесса
``` bash
$sudo gem install terminal-notifier
```
#####s3cmd
s3cmd это консольная утилитка для заливки файликов на амазоновские бакеты, которую мы будем ставить через macPorts. 
* Скачиваем пакет установки для нужной OS X

```
http://www.macports.org/install.php
```
* После установки открываем наш любимый terminal.app и ставим s3cmd. Ставится он 5-10 минут, потому как оно тянет за собой половину финляндии, с гражданином (с). Ждемс...

```bash
sudo port install s3cmd
```
* Далее конфигурируем нашу утилитку

```bash
s3cmd --configure
```

Выглядеть после настройки должно примерно так:

```
Enter new values or accept defaults in brackets with Enter.
Refer to user manual for detailed description of all options.

Access key and Secret key are your identifiers for Amazon S3
Access Key: КЛЮЧ_КОТОРЫЙ_НАДО_ВЗЯТЬ_У_РОМАНА_НА_БУМАЖКЕ_А_БУМАЖКУ_СКУШАТЬ
Secret Key: СЕКРЕТ_КОТОРЫЙ_НАДО_ВЗЯТЬ_У_РОМАНА_НА_БУМАЖКЕ_А_БУМАЖКУ_СКУШАТЬ

Encryption password is used to protect your files from reading
by unauthorized persons while in transfer to S3
Encryption password: 
Path to GPG program: 

When using secure HTTPS protocol all communication with Amazon S3
servers is protected from 3rd party eavesdropping. This method is
slower than plain HTTP and can't be used if you're behind a proxy
Use HTTPS protocol [No]: No

On some networks all internet access must go through a HTTP proxy.
Try setting it here if you can't conect to S3 directly
HTTP Proxy server name: 

New settings:
  Access Key: ПОВТОР_КЛЮЧА_ЕСЛИ_БУМАЖКА_ЦЕЛА_МОЖНО_СРАВНИТЬ
  Secret Key: ПОВТОР_СЕКРЕТА_ЕСЛИ_БУМАЖКА_ЦЕЛА_МОЖНО_СРАВНИТЬ
  Encryption password: 
  Path to GPG program: None
  Use HTTPS protocol: False
  HTTP Proxy server name: 
  HTTP Proxy server port: 0

Test access with supplied credentials? [Y/n] Y
Please wait...
Success. Your access key and secret key worked fine :-)

Now verifying that encryption works...
Not configured. Never mind.

Save settings? [y/N] y
Configuration saved to '/Users/st/.s3cfg'
```

##Настройка Xcode
#####Templates
Следующие файлики скачиваем и помещаем в "Supporting Files"

* templateHTML.html
* templatePLIST.plist
* autobuild.sh

<img src="https://api.monosnap.com/image/download?id=Qj1KrTdiQJXIAnop7i2meNPUt" alt="Supporting Files Screenshot" />

Если данные темплейты будут помещены в другую директорию,в autobuid.sh надо будет вносить изменения о которых написано в секции Настройка autobuild.sh

#####post-action
1. Edit Scheme
2. Post-action. Жмем на + внизу и выбираем "New Run Script Action"
3. Обязательно выбираем в выпадашке нужный target. Иначе это все не взлетит
4. Добавляем в поле ввода следующий код

```bash
/bin/sh ${SRCROOT}/${PRODUCT_NAME}/autobuild.sh
```
<img src="https://api.monosnap.com/rpc/image/download?id=BmNLQbQaKGdVlDhcCHTHl7XN7" alt="autobuild" />
  
##Настройка autobuild.sh
#####Переходим на вкладку Build Settings нашего проекта. Идем до секции Code Signing. Дальше действуем пошагово
* Получение PROV_UUID

<img src="https://api.monosnap.com/image/download?id=gHOrX1Dv8bECpHBW28GBIurxE" alt="PROV_UUID" />

* Получение SIGNING_IDENTITY

<img src="https://api.monosnap.com/image/download?id=Och4M9ynl748whV0wIiFhWIcd" alt="SIGNING_IDENTITY" />



