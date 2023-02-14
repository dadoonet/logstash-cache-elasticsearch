source .env

if [ -e .cloud ] ; then
	source .cloud

	if [ -z "$EC_API_KEY" ] ; then
    echo ".cloud file is incorrect. It must contain:"
    echo "EC_API_KEY=YOUR_CLOUD_API_KEY"
		exit 1
	fi

else
	echo ".cloud must be created. It must contain:"
	echo "EC_API_KEY=YOUR_CLOUD_API_KEY"
	echo "To generate a new key,"
	echo "open https://cloud.elastic.co/deployment-features/keys"
fi
