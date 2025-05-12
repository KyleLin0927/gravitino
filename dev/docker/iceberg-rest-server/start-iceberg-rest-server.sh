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

# [系統邏輯] 這是一個典型的服務啟動腳本，用於在 Docker 容器中啟動 Iceberg REST 服務。

#這行設定了兩個重要的 bash 選項：
#-e：如果任何命令返回非零狀態（失敗），腳本會立即退出
#-x：會印出每個命令及其參數，方便除錯
set -ex

#這行會設定 bin_dir 變量，它會指向腳本所在的目錄
bin_dir="$(dirname "${BASH_SOURCE-$0}")"

#這行會將 bin_dir 變量中的路徑轉換為絕對路徑，並將其賦值給 iceberg_rest_server_dir 變量
iceberg_rest_server_dir="$(cd "${bin_dir}/../">/dev/null; pwd)"

#這行會將腳本所在的目錄設為工作目錄
cd ${iceberg_rest_server_dir}

#這行會執行 rewrite_config.py 腳本，用於更新配置文件
python bin/rewrite_config.py

#這行會執行 gravitino-iceberg-rest-server.sh 腳本，用於啟動 Iceberg REST Server
./bin/gravitino-iceberg-rest-server.sh start
