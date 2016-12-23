# VI
Replace a word in vi
:%s/FindMe/ReplaceME/g

# GIT
## Résolution de rebase :
`git rebase origin/dev`
conflit :
`git co -- ours [file]`
`git add [file]`
`git rebase --continue`

## Ajout d'un repository sur un remote
Create the repo on the git server
`git remote add origin remote repository [URL]`

## Deleting tag :
* local : `git tag -d v2.10.1` 
* remote : `git push --delete origin tagname`

# Linux 
##Install a .deb package
`sudo dpkg -i paquet.deb

## Install a rpm
`rpm -Uvh pentaho-kettle-5.4.0.5_lbc-1.x86_64.rpm`

## Command line tips
### ssh & co:
ssh -L  25439:brutus-dwh-db.data.qa.leboncoin.io:5439 sshgw -p 222  -fN
ssh -L  4242:data-redshift-prod:5439  52.18.80.191 -fN
ssh -L  4343:vqa22.leboncoin.lan:5432  vqetl01.leboncoin.lan -fN
ssh -L  7777:vqa23.leboncoin.lan:5432  vqetl01.leboncoin.lan -fN
ssh -L  9090:vvcrm02.leboncoin.lan:3306  vqetl01.leboncoin.lan -fN
ssh -L  8989:127.0.0.1:25   vqetl01.leboncoin.lan -fN #tunnel ssh pour forward le smtp

### Identify the kernel version
uname -a

### Kernel upgrade
Download linux-headers & linux-image here : http://kernel.ubuntu.com/~kernel-ppa/mainline/
dpkg-i linux-*
reboot


# Pyspark tips
`pyspark --jars data/git/data_brutus/spark_etl/target/spark-etl-1.1.0-SNAPSHOT.jar`

```scala 
sqlContext.sparkContext.hadoopConfiguration.set("fs.s3a.access.key", s3AccessKey)
sqlContext.sparkContext.hadoopConfiguration.set("fs.s3a.secret.key", s3SecretKey)
val store_params_path = "s3a://leboncoin.fr-datalake-prod/platform/prod/databases/blocketdb/public/snapshot/66/store_params/parquet"
val store_param_data = sqlContext.read.parquet(store_params_path)
store_param_data.registerTempTable("store_params")
val generic_store = "s3a://leboncoin.fr-data-staging-prod/work_manager/prod/666/generic/transform_store_master"
sqlContext.read.parquet(generic_store).registerTempTable("store_master")

# Maven
## Création du jar d'un projet
`mvn clean package`

# AWS Cli
aws s3 cp stores_sorted_8_1.txt s3://leboncoin.fr-datalake-dev/platform/sba/databases/blocketdb/public/snapshot/8/stores/csv/
aws s3 help

# PostgreSQL / Redshift
## Création de rôle
`ALTER database data_em_dev OWNER TO data_em_dev`

`create role data_em_dev
with login password 'data_em_dev' ;`

## Liste des schémas d'une base
\dn

## Getting global table info (size, compression, ...) : 
`SELECT * FROM svv_table_info`

## Getting details for each columns : 
`SELECT * FROM pg_table_def`

# Elastic tips 
## See mapping
curl -X GET http://elasticsearch01.data.qa.leboncoin.io:9200/platform_qa2/store_master/_mapping?pretty

## Create a new index from a file mapping 
curl -X POST http://elasticsearch01.data.qa.leboncoin.io:9200/platform_qa2/store_master/_mapping -d @databases/brutus/indexer/platform/mapping_store_master.json?pretty

## Search for stuff
curl -X GET http://elasticsearch01.data.qa.leboncoin.io:9200/platform_qa2/store_master/_search?q=*&pretty
curl -XGET http://elasticsearch01.data.qa.leboncoin.io:9200/platform_qa2/store_master/_search?q=store_id:987654321
curl -XGET http://elasticsearch01.data.qa.leboncoin.io:9200/platform_qa2/store_master/_search?q=store_id:998885555

## DELETE Stuff
curl -X DELETE http://elasticsearch01.data.qa.leboncoin.io:9200/platform_qa2/store_master/987654321

# Generate password
pwgen -0BnC

# Chef
knife data bag -z show security lbc_brutus  --secret-file ~/.security/encrypted_data_bag_secret

# Python
Remove compilation files
find . -name *.pyc -type f -delete
## Venv 
Create a new venv 
`python -m venv [folder]
Activate it 
`source bin/activate`
Deactivate it
deactivate`

# Add zsh & oh-my-zsh on mac OS X 
`brew install zsh`
`curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh`
