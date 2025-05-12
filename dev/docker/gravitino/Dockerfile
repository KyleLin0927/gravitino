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

# [系統邏輯] 這個 Dockerfile 用於構建 Gravitino 的 Docker 映像

# 使用 openjdk:17-jdk-buster 作為基礎映像
FROM openjdk:17-jdk-buster

# 設定維護者
LABEL maintainer="dev@gravitino.apache.org"

# 設定工作目錄
WORKDIR /root/gravitino

# 複製 gravitino 的 packages 目錄到容器中
COPY packages/gravitino /root/gravitino

# 暴露 8090 和 9001 端口
EXPOSE 8090
EXPOSE 9001

# 設定容器啟動時的入口點
ENTRYPOINT ["/bin/bash", "/root/gravitino/bin/gravitino.sh", "start"]
