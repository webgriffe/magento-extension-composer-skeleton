#!/usr/bin/env sh

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
VENDOR_NAME=$1
MODULE_NAME=$2
COMPOSER_NAME=$3

if [ -z "${VENDOR_NAME}" ]; then
	echo "Please enter a vendor name."
	exit 1;
fi

if [ -z "${MODULE_NAME}" ]; then
        echo "Please enter a module name."
	exit 1
fi

if [ -z "${COMPOSER_NAME}" ]; then
        echo "Please enter a composer package name."
        exit 1
fi

echo "Vendor name: ${VENDOR_NAME}"
echo "Module name: ${MODULE_NAME}"
echo "Composer package name: ${COMPOSER_NAME}"

VENDOR_NAME_LOWER=$(echo ${VENDOR_NAME} | tr '[:upper:]' '[:lower:]')
MODULE_NAME_LOWER=$(echo ${MODULE_NAME} | tr '[:upper:]' '[:lower:]')

for i in $(find ${SCRIPT_DIR} -name "Vendor")
do
	dir=$(dirname "$i")
	echo "$i -> $dir/${VENDOR_NAME}"
	mv $i "$dir/${VENDOR_NAME}"
done

for i in $(find ${SCRIPT_DIR} -name "Module")
do
        dir=$(dirname "$i")
        echo "$i -> $dir/${MODULE_NAME}"
	mv $i "$dir/${MODULE_NAME}"
done

for i in $(find ${SCRIPT_DIR} -name "Vendor_Module.xml")
do
        dir=$(dirname "$i")
        echo "$i -> $dir/${VENDOR_NAME}_${MODULE_NAME}.xml"
	mv $i "$dir/${VENDOR_NAME}_${MODULE_NAME}.xml"
done

for i in $(find ${SCRIPT_DIR} -name "vendor_module_setup")
do
        dir=$(dirname "$i")
        echo "$i -> $dir/${VENDOR_NAME_LOWER}_${MODULE_NAME_LOWER}_setup"
	mv $i "$dir/${VENDOR_NAME_LOWER}_${MODULE_NAME_LOWER}_setup"
done

for i in $(find ${SCRIPT_DIR} -name "*.php")
do
	echo "Replacing 'Vendor_Module' with '${VENDOR_NAME}_${MODULE_NAME}' in $i..."
	sed -i '.original' 's/Vendor_Module/${VENDOR_NAME}_${MODULE_NAME}/g' $i
done

for i in $(find ${SCRIPT_DIR} -name "*.xml")
do
        echo "Replacing 'Vendor_Module' with '${VENDOR_NAME}_${MODULE_NAME}' in $i..."
        sed -i '.original' 's/Vendor_Module/${VENDOR_NAME}_${MODULE_NAME}/g' $i
done

for i in $(find ${SCRIPT_DIR} -name "*.xml")
do
        echo "Replacing 'vendor_module' with '${VENDOR_NAME_LOWER}_${MODULE_NAME_LOWER}' in $i..."
        sed -i '.original' 's/vendor_module/${VENDOR_NAME_LOWER}_${MODULE_NAME_LOWER}/g' $i
done

file="${SCRIPT_DIR}/modman"
echo "Replacing 'Vendor_Module' with '${VENDOR_NAME}_${MODULE_NAME}' in $file..."
sed -i '.original' 's/Vendor_Module/${VENDOR_NAME}_${MODULE_NAME}/g' $file

file="${SCRIPT_DIR}/composer.json"
echo "Replacing 'module/vendor' with '${COMPOSER_NAME}' in $file..."
sed -i '.original' 's|vendor/module|webgriffe/store-redirect|g' $file
