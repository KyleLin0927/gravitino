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

# [系統邏輯] 這個腳本用於在 Docker 容器中構建 Gravitino 項目，並將其打包成一個可執行的 JAR 文件。

# 設定 bash 選項
# -e：如果任何命令返回非零狀態（失敗），腳本會立即退出
# -x：會印出每個命令及其參數，方便除錯
set -ex

# 設定 gravitino_dir 變量，它會指向腳本所在的目錄
gravitino_dir="$(dirname "${BASH_SOURCE-$0}")"
gravitino_dir="$(cd "${gravitino_dir}">/dev/null; pwd)"
gravitino_home="$(cd "${gravitino_dir}/../../..">/dev/null; pwd)"

# 清理之前構建的成果
# 這行會清除 gravitino_home 目錄下的 distribution 目錄
# 這是為了確保每次構建時都從乾淨的狀態開始
rm -rf ${gravitino_home}/distribution

# 構建 Gravitino 項目
${gravitino_home}/gradlew clean build -x test

# 清理之前構建的成果
# 這行會清除 gravitino_home 目錄下的 distribution 目錄
# 這是為了確保每次構建時都從乾淨的狀態開始
rm -rf ${gravitino_home}/distribution

# 構建 Gravitino 項目
${gravitino_home}/gradlew compileDistribution -x test

# 清理之前構建的成果
# 這行會清除 gravitino_dir 目錄下的 packages 目錄
# 這是為了確保每次構建時都從乾淨的狀態開始
rm -rf "${gravitino_dir}/packages"
mkdir -p "${gravitino_dir}/packages"

# 複製 gravitino_home 目錄下的 distribution 目錄到 gravitino_dir 目錄下的 packages 目錄
cp -r "${gravitino_home}/distribution/package" "${gravitino_dir}/packages/gravitino"

# 複製 gravitino_home 目錄下的 bundles 目錄到 gravitino_dir 目錄下的 packages 目錄
cp ${gravitino_home}/bundles/aliyun-bundle/build/libs/*.jar "${gravitino_dir}/packages/gravitino/catalogs/hadoop/libs"
cp ${gravitino_home}/bundles/aws-bundle/build/libs/*.jar "${gravitino_dir}/packages/gravitino/catalogs/hadoop/libs"
cp ${gravitino_home}/bundles/gcp-bundle/build/libs/*.jar "${gravitino_dir}/packages/gravitino/catalogs/hadoop/libs"
cp ${gravitino_home}/bundles/azure-bundle/build/libs/*.jar "${gravitino_dir}/packages/gravitino/catalogs/hadoop/libs"

# 在 gravitino_dir 目錄下的 packages 目錄下的 gravitino 目錄下的 bin 目錄下的 gravitino.sh 文件中添加以下內容
# 這是為了確保每次構建時都從乾淨的狀態開始
cat <<EOF >> "${gravitino_dir}/packages/gravitino/bin/gravitino.sh"

# 保持一個進程在背景中運行
# Keeping a process running in the background
tail -f /dev/null
EOF

# 這行會執行 gravitino.sh 腳本，用於啟動 Gravitino 服務
./bin/gravitino.sh start
