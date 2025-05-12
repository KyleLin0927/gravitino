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

# [系統邏輯] 這個 Dockerfile 用於構建 Iceberg REST Server 的 Docker 鏡像。
# 它會將 Iceberg REST Server 的 jar 文件複製到 Docker 容器中，並設置啟動腳本。
# 最後，它會執行啟動腳本，用於啟動 Iceberg REST Server。

FROM openjdk:17-jdk-buster

# 設置作者
LABEL maintainer="dev@gravitino.apache.org"

# 設置工作目錄
WORKDIR /root/gravitino-iceberg-rest-server

# 複製 Iceberg REST Server 的 jar 文件到 Docker 容器中
COPY packages/gravitino-iceberg-rest-server /root/gravitino-iceberg-rest-server

# 暴露端口
EXPOSE 9001

# 設置啟動腳本
ENTRYPOINT ["/bin/bash", "/root/gravitino-iceberg-rest-server/bin/start-iceberg-rest-server.sh"]
