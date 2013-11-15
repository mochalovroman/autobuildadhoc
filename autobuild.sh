#/usr/bin/open -a /Applications/Utilities/Console.app $LOG

# Build and sign app
xcodebuild -configuration Distribution clean build

# Log name
LOG="/tmp/post-build-upload-to-s3.log"

# Name Amazon Bucket
AMAZON_DOMAIN="https:\/\/s3-us-west-2.amazonaws.com" #имя домена. Для моего аккаунта это имя будет неизменно
BUCKET_NAME="adhocwork" #имя бакета. Для моего аккаунта это имя будет неизменно
BUCKET_FOLDER="" #!ДОБАВИТЬ! Имя папочки в которую будем складывать файлики. Для каждого проекта буду заводить новую
AMAZON_BUCKET="\/${BUCKET_NAME}\/${BUCKET_FOLDER}\/"
AMAZON_BUCKET_S3CMD="/${BUCKET_NAME}/${BUCKET_FOLDER}/"

# Sign app variables
SIGNING_IDENTITY="" #!ДОБАВИТЬ! https://github.com/mochalovroman/autobuildadhoc/blob/master/README.md  Получение SIGNING_IDENTITY
PROV_UUID="" #!ДОБАВИТЬ! https://github.com/mochalovroman/autobuildadhoc/blob/master/README.md. Получение PROV_UUID
PROVISIONING_PROFILE="${HOME}/Library/MobileDevice/Provisioning Profiles/${PROV_UUID}.mobileprovision"

# Variables
DATE_ARCHIVE=$(/bin/date +"%Y-%m-%d")
ARCHIVE=$(/bin/ls -t "${HOME}/Library/Developer/Xcode/Archives/${DATE_ARCHIVE}" | /usr/bin/grep xcarchive | /usr/bin/sed -n 1p )
DSYM="${HOME}/Library/Developer/Xcode/Archives/${DATE_ARCHIVE}/${ARCHIVE}/dSYMs/${PRODUCT_NAME}.app.dSYM"
APP="${HOME}/Library/Developer/Xcode/Archives/${DATE_ARCHIVE}/${ARCHIVE}/Products/Applications/${PRODUCT_NAME}.app"
PLIST_PATH="${SRCROOT}/${INFOPLIST_FILE}"
DATE_WITH_HOURS=$(/bin/date +"%d.%m.%Y_%H.%M" )
BUILD_NUMBER=$(defaults read "${PLIST_PATH}" CFBundleVersion)

IPA_FINAL_NAME=${PRODUCT_NAME}-${DATE_WITH_HOURS}-$USER.ipa
PLIST_FINAL_NAME=${PRODUCT_NAME}-${DATE_WITH_HOURS}-$USER.plist
HTML_FINAL_NAME="Install${PRODUCT_NAME}".html

# Growl init
GROWL="/usr/bin/terminal-notifier -title Xcode -message"

# Create ipa
echo "Creating IPA ${IPA_FINAL_NAME}" >> $LOG
${GROWL} "Creating IPA"
/bin/rm "/tmp/${PRODUCT_NAME}.ipa"
/usr/bin/xcrun -sdk iphoneos PackageApplication "${APP}" -o "/tmp/${IPA_FINAL_NAME}" --sign "${SIGNING_IDENTITY}" --embed "${PROVISIONING_PROFILE}" >> $LOG

# Create plist
echo "Creating PLIST ${PLIST_FINAL_NAME}" >> $LOG
${GROWL} "Creating PLIST"
cat "${SRCROOT}/${PRODUCT_NAME}/templatePLIST.plist" | sed -e "s/\${PRODUCT_NAME}/$PRODUCT_NAME/" -e "s/\${BUILD_NUMBER}/$BUILD_NUMBER/" -e "s/\${AMAZON_BUCKET}/$AMAZON_BUCKET/" -e "s/\${AMAZON_DOMAIN}/$AMAZON_DOMAIN/" -e "s/\${IPA_FINAL_NAME}/$IPA_FINAL_NAME/" > /tmp/${PLIST_FINAL_NAME}

# Create html
echo "Creating HTML ${HTML_FINAL_NAME}" >> $LOG
${GROWL} "Creating HTML"
cat "${SRCROOT}/${PRODUCT_NAME}/templateHTML.html"  | sed -e "s/\${PRODUCT_NAME}/$PRODUCT_NAME/" -e "s/\${PLIST_FINAL_NAME}/$PLIST_FINAL_NAME/" -e "s/\${AMAZON_BUCKET}/$AMAZON_BUCKET/" -e "s/\${AMAZON_DOMAIN}/$AMAZON_DOMAIN/" > /tmp/${HTML_FINAL_NAME}

# Upload amazon s3
echo "Uploading to S3..." >> $LOG
${GROWL} "Uploading to Amazon S3..."

/opt/local/bin/s3cmd put --acl-public --force --guess-mime-type /tmp/${IPA_FINAL_NAME} "s3:/${AMAZON_BUCKET_S3CMD}${IPA_FINAL_NAME}" >> $LOG
${GROWL} "IPA upload complete"
/opt/local/bin/s3cmd put --acl-public --force --guess-mime-type /tmp/${PLIST_FINAL_NAME} "s3:/${AMAZON_BUCKET_S3CMD}${PLIST_FINAL_NAME}" >> $LOG
${GROWL} "PLIST upload complete"
/opt/local/bin/s3cmd put --acl-public --force --guess-mime-type /tmp/${HTML_FINAL_NAME} "s3:/${AMAZON_BUCKET_S3CMD}${HTML_FINAL_NAME}" >> $LOG
${GROWL} "HTML upload complete"

echo "Info HTML to S3... " >> $LOG
/opt/local/bin/s3cmd info "s3:/${AMAZON_BUCKET_S3CMD}${HTML_FINAL_NAME}" >> $LOG

FINAL_URL=`awk 'NF{p=$0}END{print p}' $LOG | sed 's/.*URL://' | tr -d ' '` #awk получаем последнюю строку файла, sed получаем все что после url:, ну а tr удаляем пробелы
echo "FINAL_URL = ${FINAL_URL}" >> $LOG
echo ${FINAL_URL} | pbcopy
${GROWL} "Done"
${GROWL} "URL copy to clipboard"
${GROWL} "Open URL in Safari"
echo "FINAL_URL copy to clipboard" >> $LOG
echo
echo "Done." >> $LOG
/usr/bin/open -a /Applications/Safari.app ${FINAL_URL} #можно закоментить если не хочется открывать ссылку в сафари
