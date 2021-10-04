#!/bin/sh

MODULE=`basename $0`

NOW=$(date +"%F %T")
echo "${NOW} I ${MODULE}: Indices re-creating ..."

sdeletelog=`./bin/run bin/metacpan mapping --delete --yes 2>&1`
ideleters=$?

NOW=$(date +"%F %T")
echo "${NOW} I ${MODULE}: Re-creation finished with [$ideleters]"
echo "${NOW} I ${MODULE}: Re-creation Log:\n'$sdeletelog'"

if [ $ideleters -ne 0 ]; then
	  echo "${NOW} I ${MODULE}: Re-creation failed!"

  	exit $ideleters
fi

NOW=$(date +"%F %T")
echo "${NOW} I ${MODULE}: ElasticSearch 'elasticsearch:9200': Indices showing ..."

curl -v 'elasticsearch:9200/_cat/indices'

NOW=$(date +"%F %T")
echo "${NOW} I ${MODULE}: Packages downloading ..."

/bin/partial-cpan-mirror.sh

NOW=$(date +"%F %T")
echo "${NOW} I ${MODULE}: Indices rebuilding ..."

./bin/run bin/metacpan release /CPAN/authors/id/
./bin/run bin/metacpan latest
./bin/run bin/metacpan author
./bin/run bin/metacpan permission

NOW=$(date +"%F %T")
echo "${NOW} I ${MODULE}: done."
