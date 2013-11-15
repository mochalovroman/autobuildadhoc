autobuildadhoc
==============

Description aboun automatization build ad-hoc app with xcode and send build on amazon s3

## Table of Contents
- [Settings working environment](#settings-working-environment)
- [Xcode settings](#xcode-settings)
- [Settings autobuild script](#settings-autobuild-script)
- [Total](#total)


## Settings working environment
###terminal-notifier
Открывает terminal.app и ставим terminal-notifier для того чтобы получать уведомления о ходе выполнения процесса
``` bash
$sudo gem install terminal-notifier
```
###s3cmd
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

## Xcode settings
###Templates
Следующие файлики скачиваем и помещаем в "Supporting Files"

* templateHTML.html
* templatePLIST.plist
* autobuild.sh

<img src="https://api.monosnap.com/image/download?id=Qj1KrTdiQJXIAnop7i2meNPUt" alt="Supporting Files Screenshot" />

Если данные темплейты будут помещены в другую директорию,в autobuid.sh надо будет вносить изменения. Документ будет обновляться, там и появится описание всего чего можно потыкать и понастраивать.

###post-action
1. Edit Scheme
2. Post-action. Жмем на + внизу и выбираем "New Run Script Action"
3. Обязательно выбираем в выпадашке нужный target. Иначе это все не взлетит
4. Добавляем в поле ввода следующий код

```bash
/bin/sh ${SRCROOT}/${PRODUCT_NAME}/autobuild.sh
```
<img src="https://api.monosnap.com/rpc/image/download?id=BmNLQbQaKGdVlDhcCHTHl7XN7" alt="autobuild" />
  
## Settings autobuild script
###Добавление необходимых параметров
Открываем autobuild.sh прямо в xcode. Находим поиском строки содержащие 

```
!ДОБАВИТЬ! 
```

Поиск должен найти три строки
```
BUCKET_FOLDER=""
SIGNING_IDENTITY=""
PROV_UUID=""
```
####BUCKET_FOLDER

```
BUCKET_FOLDER="angryiphone" 
```

Данное имя актуально для проекта angry. Для других проектов будет создаваться новая папка

####SIGNING_IDENTITY
Переходим на вкладку Build Settings нашего проекта. Идем до секции Code Signing. Дальше действуем пошагово

<img src="https://api.monosnap.com/image/download?id=Och4M9ynl748whV0wIiFhWIcd" alt="SIGNING_IDENTITY" />

```
SIGNING_IDENTITY="то_что_получили_действуя_пошагово_по_картинке" 
```

#### PROV_UUID
Переходим на вкладку Build Settings нашего проекта. Идем до секции Code Signing. Дальше действуем пошагово

<img src="https://api.monosnap.com/image/download?id=gHOrX1Dv8bECpHBW28GBIurxE" alt="PROV_UUID" />

```
PROV_UUID="то_что_получили_действуя_пошагово_по_картинке" 
```

## Total
Вот вообщем-то и все. Делаем Product-->Archive. И если все было сделано правильно то Ваш билд зальется на S3 и ссылка на него будет скопирована в буфер обмена и также открыта в сафари. Enjoy!

p.s. Это первая версия скрипта и документа readme. Как будет время все будет обновляться.
