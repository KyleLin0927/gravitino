#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

# [系統邏輯] 這個腳本用於在 Docker 容器中構建 Iceberg REST Server 項目，並將其打包成一個可執行的 JAR 文件。
# Gravitino 團隊是自行建構了 Iceberg REST Server 的容器，而不是直接使用 Iceberg 官方的容器。
# 這表示 Gravitino 團隊因為 Iceberg 官方沒有提供阿里雲的 bundle，所以自己實作了阿里雲的支援。
# 這個腳本會下載 Iceberg 的 bundle jar 文件，並將其複製到 iceberg_rest_server_dir 目錄下的 packages 目錄下的 gravitino-iceberg-rest-server 目錄下的 libs 目錄。

# 設定 bash 選項
#-e：如果任何命令返回非零狀態（失敗），腳本會立即退出
#-x：會印出每個命令及其參數，方便除錯
set -ex

# 設定 iceberg_rest_server_dir 變量，它會指向腳本所在的目錄
iceberg_rest_server_dir="$(dirname "${BASH_SOURCE-$0}")"

# 將 iceberg_rest_server_dir 變量中的路徑轉換為絕對路徑，並將其賦值給 iceberg_rest_server_dir 變量
iceberg_rest_server_dir="$(cd "${iceberg_rest_server_dir}">/dev/null; pwd)"

# 設定 gravitino_home 變量，它會指向腳本所在的目錄
gravitino_home="$(cd "${iceberg_rest_server_dir}/../../..">/dev/null; pwd)"

# 清理之前構建的成果
# 這行會清除 gravitino_home 目錄下的 distribution 目錄
# 這是為了確保每次構建時都從乾淨的狀態開始
rm -rf ${gravitino_home}/distribution

# 構建 Iceberg REST Server 項目
cd ${gravitino_home}
./gradlew clean assembleIcebergRESTServer -x test

# 清理之前構建的成果
# 這行會清除 iceberg_rest_server_dir 目錄下的 packages 目錄
# 這是為了確保每次構建時都從乾淨的狀態開始
rm -rf "${iceberg_rest_server_dir}/packages"
mkdir -p "${iceberg_rest_server_dir}/packages"

# 解壓縮 gravitino-iceberg-rest-server-*.tar.gz 文件
cd distribution
tar xfz gravitino-iceberg-rest-server-*.tar.gz

# 複製 gravitino-iceberg-rest-server*-bin 目錄到 iceberg_rest_server_dir 目錄下的 packages 目錄
cp -r gravitino-iceberg-rest-server*-bin ${iceberg_rest_server_dir}/packages/gravitino-iceberg-rest-server

# 構建 GCP、AWS、Azure 和 Aliyun 的 bundle jar
cd ${gravitino_home}
./gradlew :bundles:gcp:jar
./gradlew :bundles:aws:jar
./gradlew :bundles:azure:jar
## Iceberg doesn't provide Iceberg Aliyun bundle jar, so use Gravitino aliyun bundle to provide OSS packages.
./gradlew :bundles:aliyun-bundle:jar

# prepare bundle jar
cd ${iceberg_rest_server_dir}
mkdir -p bundles
cp ${gravitino_home}/bundles/gcp/build/libs/gravitino-gcp-*.jar bundles/
cp ${gravitino_home}/bundles/aws/build/libs/gravitino-aws-*.jar bundles/
cp ${gravitino_home}/bundles/azure/build/libs/gravitino-azure-*.jar bundles/
cp ${gravitino_home}/bundles/aliyun-bundle/build/libs/gravitino-aliyun-bundle-*.jar bundles/

# 下載 Iceberg GCP、AWS、Azure 和 Aliyun 的 bundle jar
iceberg_version="1.6.1"

# 下載 Iceberg GCP 的 bundle jar
iceberg_gcp_bundle="iceberg-gcp-bundle-${iceberg_version}.jar"
if [ ! -f "bundles/${iceberg_gcp_bundle}" ]; then
  curl -L -s -o bundles/${iceberg_gcp_bundle} https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-gcp-bundle/${iceberg_version}/${iceberg_gcp_bundle}
fi

# 下載 Iceberg AWS 的 bundle jar
iceberg_aws_bundle="iceberg-aws-bundle-${iceberg_version}.jar"
if [ ! -f "bundles/${iceberg_aws_bundle}" ]; then
  curl -L -s -o bundles/${iceberg_aws_bundle} https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-aws-bundle/${iceberg_version}/${iceberg_aws_bundle}
fi

# 下載 Iceberg Azure 的 bundle jar
iceberg_azure_bundle="iceberg-azure-bundle-${iceberg_version}.jar"
if [ ! -f "bundles/${iceberg_azure_bundle}" ]; then
  curl -L -s -o bundles/${iceberg_azure_bundle} https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-azure-bundle/${iceberg_version}/${iceberg_azure_bundle}
fi

# 下載 sqlite-jdbc-3.42.0.0.jar
# download jdbc driver
curl -L -s -o bundles/sqlite-jdbc-3.42.0.0.jar https://repo1.maven.org/maven2/org/xerial/sqlite-jdbc/3.42.0.0/sqlite-jdbc-3.42.0.0.jar

# 複製 bundles 目錄下的所有 jar 文件到 iceberg_rest_server_dir 目錄下的 packages 目錄下的 gravitino-iceberg-rest-server 目錄下的 libs 目錄
cp bundles/*jar ${iceberg_rest_server_dir}/packages/gravitino-iceberg-rest-server/libs/

# 複製 start-iceberg-rest-server.sh 和 rewrite_config.py 文件到 iceberg_rest_server_dir 目錄下的 packages 目錄下的 gravitino-iceberg-rest-server 目錄下的 bin 目錄
cp start-iceberg-rest-server.sh ${iceberg_rest_server_dir}/packages/gravitino-iceberg-rest-server/bin/
cp rewrite_config.py ${iceberg_rest_server_dir}/packages/gravitino-iceberg-rest-server/bin/

# 在 gravitino-iceberg-rest-server.sh 文件中添加以下內容
# 這是為了確保每次構建時都從乾淨的狀態開始
cat <<EOF >> "${iceberg_rest_server_dir}/packages/gravitino-iceberg-rest-server/bin/gravitino-iceberg-rest-server.sh"

# Keeping a process running in the background
tail -f /dev/null
EOF

# 執行 gravitino-iceberg-rest-server.sh 腳本，用於啟動 Iceberg REST Server
./bin/gravitino-iceberg-rest-server.sh start
