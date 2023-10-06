#!/bin/sh

MODULE=`basename $0`

NOW=$(date +"%F %T")
echo "${NOW} I ${MODULE}: Indices re-creating ..."

#sdeletelog=`echo "" 2>&1`
./bin/run bin/metacpan mapping --delete $@
ideleters=$?

NOW=$(date +"%F %T")
echo "${NOW} I ${MODULE}: Re-creation finished with [$ideleters]"
#echo "${NOW} I ${MODULE}: Re-creation Log:\n'$sdeletelog'"

if [ $ideleters -ne 0 ]; then
	  echo "${NOW} E ${MODULE}: Re-creation failed!"

  	exit $ideleters
fi

NOW=$(date +"%F %T")
echo "${NOW} I ${MODULE}: ElasticSearch - Info collecting ..."

sinfolog=`./bin/run bin/metacpan mapping --show_cluster_info $@ 2>&1`
iinfors=$?

NOW=$(date +"%F %T")
echo "${NOW} I ${MODULE}: Info finished with [$iinfors]"
echo "${NOW} I ${MODULE}: Info Log:\n'$sinfolog'"

if [ $iinfors -ne 0 ]; then
	  echo "${NOW} E ${MODULE}: ElasticSearch unavailable!"

  	exit $iinfors
fi

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
